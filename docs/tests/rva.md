# rva

It is a dummy for [wes, wgs] x [1-5 proteins] x [4 groups] x [1-22 chromosomes] combinations as in the rare variant analysis (rva).

## scripts

```bash
#!/usr/bin/bash

#SBATCH --job-name=_rva
#SBATCH --account=PETERS-SL3-CPU
#SBATCH --partition=skylake
#SBATCH --cpus-per-task=2
#SBATCH --array=1-5
#SBATCH --mem=18800
#SBATCH --time=12:00:00
#SBATCH --output=/home/jhz22/_rva_%A_%a.o
#SBATCH --error=/home/jhz22/_rva_%A_%a.e
#SBATCH --export ALL

export TMPDIR=${HPC_WORK}/work
export SEQ=~/COVID-19/SCALLOP-Seq
export COHORT=INTERVAL

singularity_exec()
{
  echo ${weswgs}
}

export groups=(exon_CADD exon_reg exon_severe reg_Only)
for weswgs in wes wgs
do
  export pheno=$(ls ${SEQ}/work/${weswgs}/*-lr.pheno | xargs -I {} basename {} -lr.pheno | awk 'NR==ENVIRON["SLURM_ARRAY_TASK_ID"]')
  export weswgs=${weswgs}
  for chrs in {1..22}
  do
    export chr=chr${chrs}
    for group in ${groups[@]}
    do
      export group_file=${group}-${chrs}.groupfile.txt
      echo ${pheno} ${weswgs} ${chr} ${group}
      singularity_exec
    done
  done
done
```

## An example list

The _rva*.o files list the combinations as intended, e.g., [_rva_46245269_1.o](_rva_46245269_1.o) with an empty [_rva_46245269_1.e](_rva_46245269_1.e).

```
cvd2_ACE2__Q9BYF1 wes chr1 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr1 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr1 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr1 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr2 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr2 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr2 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr2 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr3 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr3 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr3 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr3 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr4 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr4 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr4 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr4 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr5 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr5 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr5 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr5 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr6 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr6 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr6 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr6 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr7 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr7 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr7 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr7 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr8 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr8 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr8 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr8 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr9 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr9 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr9 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr9 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr10 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr10 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr10 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr10 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr11 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr11 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr11 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr11 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr12 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr12 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr12 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr12 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr13 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr13 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr13 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr13 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr14 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr14 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr14 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr14 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr15 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr15 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr15 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr15 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr16 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr16 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr16 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr16 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr17 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr17 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr17 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr17 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr18 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr18 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr18 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr18 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr19 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr19 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr19 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr19 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr20 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr20 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr20 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr20 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr21 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr21 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr21 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr21 reg_Only
wes
cvd2_ACE2__Q9BYF1 wes chr22 exon_CADD
wes
cvd2_ACE2__Q9BYF1 wes chr22 exon_reg
wes
cvd2_ACE2__Q9BYF1 wes chr22 exon_severe
wes
cvd2_ACE2__Q9BYF1 wes chr22 reg_Only
wes
cvd2_ACE2__Q9BYF1 wgs chr1 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr1 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr1 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr1 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr2 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr2 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr2 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr2 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr3 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr3 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr3 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr3 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr4 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr4 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr4 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr4 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr5 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr5 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr5 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr5 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr6 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr6 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr6 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr6 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr7 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr7 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr7 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr7 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr8 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr8 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr8 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr8 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr9 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr9 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr9 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr9 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr10 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr10 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr10 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr10 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr11 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr11 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr11 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr11 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr12 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr12 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr12 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr12 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr13 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr13 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr13 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr13 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr14 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr14 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr14 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr14 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr15 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr15 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr15 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr15 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr16 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr16 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr16 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr16 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr17 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr17 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr17 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr17 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr18 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr18 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr18 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr18 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr19 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr19 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr19 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr19 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr20 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr20 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr20 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr20 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr21 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr21 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr21 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr21 reg_Only
wgs
cvd2_ACE2__Q9BYF1 wgs chr22 exon_CADD
wgs
cvd2_ACE2__Q9BYF1 wgs chr22 exon_reg
wgs
cvd2_ACE2__Q9BYF1 wgs chr22 exon_severe
wgs
cvd2_ACE2__Q9BYF1 wgs chr22 reg_Only
wgs
```
