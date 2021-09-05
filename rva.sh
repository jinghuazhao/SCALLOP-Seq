#!/usr/bin/bash

export TMPDIR=${HPC_WORK}/work
export SEQ=~/COVID-19/SCALLOP-Seq
export COHORT=INTERVAL
export CONFIG=${SEQ}/geneset_data/config.txt
export STEP1="singularity exec -B ${SEQ} ${SEQ}/burden_testing_latest.sif"
export STEP2="singularity exec -B ${SEQ} --containall -H ${HOME}:${HOME}/COVID-19/SCALLOP-INF ${SEQ}/burden_testing_latest.sif"

# --- step1 ---

function step1()
{
# 1.1 obtain variant lists

  export weswgs=${weswgs}
  echo chr{1..22} chrX chrY | \
  tr ' ' '\n' | \
  parallel --env COHORT --env STEP1 --env weswgs -C' ' '${STEP1} step1 ${COHORT}-${weswgs} ${weswgs}-{}.vcf.gz'
  (
    echo -e "#CHROM\tPOS\tREF\tALT\tAC\tAN"
    for chr in chr{1..22} chrX chrY; do zcat ${COHORT}-${weswgs}.${chr}.variantlist.gz; done | \
    sed 's/^chr//' 
  ) | gzip -f > ${COHORT}-${weswgs}.variantlist.gz

  join -v1 -t$'\t' <(gunzip -c ${COHORT}-wes.variantlist.gz | awk -vOFS="\t" 'NR>1 {snpid=$1":"$2"_"$3"_"$4;print snpid,$0}' | sort -k1,1) \
                   <(gunzip -c ${COHORT}-wgs.variantlist.gz | awk -vOFS="\t" 'NR>1 {snpid=$1":"$2"_"$3"_"$4;print snpid,$0}' | sort -k1,1) | \
  sort -k2,2n -k3,3n | \
  cut -f1 --complement | \
  gzip -f > ${COHORT}-wes-wgs.variantlist.gz

  (
    gunzip -c ${COHORT}-wgs.variantlist.gz | head -1
    gunzip -c ${COHORT}-wgs.variantlist.gz ${COHORT}-wes-wgs.variantlist.gz | \
    sed '1d;s/^[x,X]/23/;s/^[y,Y]/24/' | sort -k1,1n -k2,2n | sed 's/^[2]3/X/;s/^[2]4/Y/'
  ) | \
  gzip -f > ${COHORT}-wes+wgs.variantlist.gz

# 1.2 prepare regions

  ${STEP1} prepare-regions -o $(pwd)/geneset_data

# 1.3 make (annotation) group files
#
#1. exon severe
#   variants with a "high" predicted consequence according to Ensembl (roughly equivalent to more severe than missense)
#2. exon CADD
#   all exonic variants (+50 bp outside of exons) weighted by CADD scores
#3. exon regulatory
#   weighted by Eigen scores (phred-scaled). Variants in regulatory regions that overlap with eQTL for that gene are also included.
#4. regulatory only
#   excluding exonic variants

  export exon_severe="-g exon"
  export exson_CADD="-g exon -x 50 -s CADD"
  export exon_regulatory="-g exon -x 50 -e promoter,enhancer,TF_bind -l promoter,enhancer,TF_bind -s EigenPhred"
  export regulatory_only="-e promoter,enhancer,TF_bind -l promoter,enhancer,TF_bind -s EigenPhred"
  export groups=(exon_severe exson_CADD exon_regulatory regulatory_only)

  export chunks=2
  for group in ${!groups[@]}
  do
    export name=${groups[$group]}
    export options=${!groups[$group]}
    for i in $(seq $chunks)
    do
       ${STEP1} make-group-file -C ${CONFIG} -i ${SEQ}/work/variantlist/${COHORT}-wes+wgs.variantlist.gz ${options} -o -w $(pwd) -d ${chunks} -c $i &
    done
    find -name "group_file*.txt" -exec cat \{} \+ > ${name}.group_file.txt
    cut -f1 concat.group.file.txt | sort | uniq -c | awk '$1==1{print $2}'> ${name}-singlesnp.genes.txt
    fgrep -wvf ${name}-singlesnp.genes.txt concat.group.file.txt > ${name}-concat.group.file.filtered.txt
  done
}

# --- step2 ---

function step2setup()
{
# 2.1 GDS
  for i in {{1..22},X,Y}
  do
    export i=${i}
    R --no-save ${SEQ}/rva.R 2>&1 | tee ${SEQ}/rva.log
# inputs
# - Filtered VCF file (see above section on Variant QC) OR GDS files if they already exist
# - Phenotype files containing two columns: sample ID and INT-transformed, covariate-adjusted and renormalised residuals without header
# - Genetic relatedness matrix (GRM) with sample IDs as row and column names
# outputs
# - A space-delimited file containing single variant scores
# - A binary file containing between-variant covariance matrices
#   ${STEP2} VCF2GDS ${weswgs}-chr${i}.vcf.gz ${weswgs}-chr${i}.gds 10
# singularity shell -B $(pwd) --containall -s /bin/bash burden_testing_latest.sif
  done
# 2.2 relatedness matrix files
# prune genotypes
  if [ ! -d ${SEQ}/work/prune ]; then mkdir ${SEQ}/work/prune; fi
  sbatch --job-name=_${weswgs} --account CARDIO-SL0-CPU --partition cardio --qos=cardio --array=1-22 --mem=40800 --time=5-00:00:00 --export ALL \
         --output=${TMPDIR}/_${weswgs}_prune_%A_%a.out --error=${TMPDIR}/_${weswgs}_prune_%A_%a.err --wrap ". ${SEQ}/prune.wrap"
  export SLURM_ARRAY_TASK_ID=X
  ${SEQ}/prune.wrap
  export SLURM_ARRAY_TASK_ID=Y
  ${SEQ}/prune.wrap
# process of pruned genotypes
  echo ${SEQ}/work/prune/${weswgs}-chr{{1..22},X} | tr ' ' '\n' > ${SEQ}/work/${weswgs}.list
  plink --merge-list ${SEQ}/work/${weswgs}.list --make-bed --out ${SEQ}/work/${weswgs}
# GRM with GCTA --mbfile but it does not tolerate
# gcta-1.9 --mbfile work/${weswgs}.list --make-grm-gz --out work/${weswgs}
  gcta-1.9 --bfile ${SEQ}/work/${weswgs} --autosome --make-grm-gz --out ${SEQ}/work/${weswgs} --thread-num 12
# PCA
  gcta-1.9 --grm-gz ${SEQ}/work/${weswgs} --pca 20 --out ${SEQ}/work/${weswgs}
# 2.3 once is enough for generating phenotypes
  if [ ${weswgs} == "wes" ]; then R --no-save <wes.R 2>&1 | tee wes.log; fi
  if [ ${weswgs} == "wgs" ]; then R --no-save <wgs.R 2>&1 | tee wgs.log; fi
}

function smmat()
{
# 2.4 Single-cohort SMMAT assocaition analysis
  if [ ! -d ${SEQ}/rva/${weswgs} ]; then mkdir -p ${SEQ}/rva/${weswgs}; fi
  export groups=(exon_CADD exon_reg exon_severe reg_Only)
  for pheno in $(ls ${SEQ}/work/${weswgs}/*-lr.pheno | xargs -I{} basename {} -lr.pheno)
  do
    export pheno=${pheno}
    for group in ${groups[@]}
    do
      export group_file=${group}.groupfile.txt
      for i in 22 # {1..22} # X Y
      do
        echo ${pheno} ${group} ${i}
        export SLURM_ARRAY_TASK_ID=${i}
        sbatch --job-name=_${weswgs}_${pheno} --account CARDIO-SL0-CPU --partition cardio --qos=cardio \
               --mem=40800 --time=5-00:00:00 --export ALL \
               --output=${TMPDIR}/_${weswgs}_${pheno}_%A_%a.out --error=${TMPDIR}/_${weswgs}_${pheno}_%A_%a.err \
               --wrap ". ${SEQ}/rva.wrap"
      done
    done
  done
}

cd work
for weswgs in wes wgs
do
  export weswgs=${weswgs}
# step1
# step2setup
  smmat
done
cd -

# --- deprecated ---

# Meta-analysis

# Group file
#Column no.     Column name     Description
#1      CHR     Chromosome number (1-22)
#2      POS     Physical base-pair position on the chromosome (in b38 coordinates)
#3      REF     Reference allele
#4      ALT     Alternate allele
#5      AC      Allele count in genotypes for each ALT allele
#6      AN      Total number of alleles in called genotypes

export idmap=${SEQ}/WGS-WES-Olink_ID_map_INTERVAL_release_28FEB2020.txt
awk '($2!="NA" || $3!="NA") && ($5!="NA"||$6!="NA"||$7!="NA"||$8!="NA")' ${idmap} | wc -l
awk '($2=="NA" && $4!="NA") && ($5!="NA"||$6!="NA"||$7!="NA"||$8!="NA")' ${idmap} | wc -l
awk '($2=="NA" && $4!="NA") && ($5!="NA"||$6!="NA"||$7!="NA"||$8!="NA")' ${idmap} | \
cut -f4 | sed '1d' | grep -v -f work/wes.samples
awk '($2=="NA" && $4!="NA") && ($5!="NA"||$6!="NA"||$7!="NA"||$8!="NA")' ${idmap} | \
cut -f4 | sed '1d' | grep -v -f work/wes.samples | grep -f - ${idmap}

function github()
# Various steps based on the GitHub other than singularity version.
{
  cd burden_testing
  for panel in cvd2 cvd3 inf neu
  do
    export panel=${panel}
    for weswgs in wes wgs
    do
      export weswgs=${weswgs}
      echo chr{1..22} chrX chrY | \
      tr ' ' '\n' | \
      parallel --env COHORT --env panel --env weswgs -C' ' 'burden.1.6.5 step1 ${COHORT}-${panel}-${weswgs} ../work/${panel}-${weswgs}-{}.vcf.gz'
      for chr in chr{1..22} chrX chrY; do zcat ${COHORT}-${panel}-${weswgs}.${chr}.variantlist.gz; done | \
      sed 's/^chr//' | gzip -f > ${COHORT}-${panel}-${weswgs}.variantlist.gz
      tabix -f ${COHORT}-${panel}-${weswgs}.variantlist.gz
    # single_cohort_munge_variantlist ${COHORT}-${panel}-${weswgs}.variantlist.gz 1 1
    done
  done
}

# Resources to be used.
# http://www.tucows.com/preview/231886/Axel
# git://git.joeyh.name/moreutils
# sudo apt install docbook2x
# sudo apt install libxml2-utils
# git clone git://git.joeyh.name/moreutils
# cd moreutils
# make
# make install
# partial alternatives
# http://downloads.sourceforge.net/docbook2x/docbook2X-0.8.8.tar.gz
# ftp://xmlsoft.org/libxml2/
# ftp://xmlsoft.org/libxml2/libxslt-1.1.34.tar.gz
# ftp://xmlsoft.org/libxml2/libxml2-2.9.10.tar.gz
# ln -sf geneset_data/ensembl-vep/INSTALL.pl
