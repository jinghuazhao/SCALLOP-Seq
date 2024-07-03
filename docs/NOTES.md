# NOTES

## Installation

```bash
singularity pull -F library://hmgu-itg/default/burden_testing:latest
singularity inspect burden_testing_latest.sif
singularity exec burden_testing_latest.sif help
singularity exec burden_testing_latest.sif single_cohort_munge_variantlist -h
singularity exec burden_testing_latest.sif prepare-regions -h
singularity exec burden_testing_latest.sif make-group-file -h
singularity exec --containall burden_testing_latest.sif step2 --help
```
for the latest or `:1.5.4`, see wiki instructions on [installation](https://github.com/hmgu-itg/burden_testing/wiki/Prerequisites-and-installation), [data](https://github.com/hmgu-itg/burden_testing/wiki/Data-input) and [SMMAT](https://github.com/hmgu-itg/burden_testing/wiki/Single-cohort-analysis-using-SMMAT).

## Debugging

Additional information can be obtained with `singularity exec --help`. For debugging, e.g., on VCF2GDS, one can invoke the singularity shell via

```bash
singularity shell --bind ${PWD} --containall --shell /usr/bin/bash burden_testing_latest.sif
```

and the container has its own HOME directory within which `~` is recognised.

1. The embedded call to `sbatch` implicates the `--wait` option as the succeeding steps would require its full results.
2. The array jobs could be altered to accommodate software and model (BOLT-LMM, GCTA `--fastGWA/fastGWAS-lr` for mixed model/linear regression).
3. The group filess for rare variant analysis have been provided by the central analysis team. Note that
   (**a**). They are whole-genome so are preferably split by chromosome.
   (**b**). No groupings are contained for chromosomes X and Y, so they could be dropped from the analysis.

## File upload

This is a heavy burden for the system, so the files are compressed first with `sftp.sb`[^addons].

The usual sftp wrapped by lftp utility is considerably faster.

```bash
export HOST=
export USER=
export PASS=

export RVA=/rds/project/jmmh2/rds-jmmh2-projects/olink_proteomics/scallop/SCALLOP-Seq/rva
lftp -c "open sftp://${USER}:${PASS}@${HOST}:/genetic_data/for_Grace; mirror -c -P=20 -R -v ${RVA}"
```

## File download

We simply drop "-R" from above to have,

```bash
export HOST=
export USER=
export PASS=

export RVA=/rds/project/jmmh2/rds-jmmh2-projects/olink_proteomics/scallop/SCALLOP-Seq/rva
lftp -c "open sftp://${USER}:${PASS}@${HOST}:/genetic_data/for_Grace; mirror -c -P=20 -v ${RVA}"
```

## URLs

* [Sylabs](https://sylabs.io/) ([GitHub](https://github.com/sylabs))

---

[^addons]: Add-ons

This is used to add some incomplete files.

```bash
#!/usr/bin/bash

cat addons/*txt | \
parallel -C' ' 'echo {} | sed "s/INTERVAL-//;s/-/\t/g" | awk -vf={} "{print \$1\"-\"\$2\"/\" f}"' | \
parallel -C' ' -j10 'cp -r {} addons'
cp -r wgs-cvd2_IgG.Fc.receptor.II.b__P31994 addons
```

where we have

```
==> addons/INTERVAL.cvd2.corruptedfiles.txt <==
INTERVAL-wgs-cvd2_MMP.12__P39900-reg_Only-chr21.var.28.gz
INTERVAL-wgs-cvd2_MMP.12__P39900-reg_Only-chr21.var.47.gz

==> addons/INTERVAL.cvd3.corruptedfiles.txt <==
INTERVAL-wgs-cvd3_PGLYRP1__O75594-reg_Only-chr10.score.50.gz
INTERVAL-wgs-cvd3_PGLYRP1__O75594-reg_Only-chr10.score.51.gz

==> addons/missing.txt <==
INTERVAL-wgs-cvd2_DCN__P07585-exon_reg-chr4.gz
INTERVAL-wgs-cvd2_CXCL1__P09341-exon_reg-chr5.gz
```
