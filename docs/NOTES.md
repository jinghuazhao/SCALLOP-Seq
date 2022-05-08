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

This is a heavy burden for the system, so the files are compressed first with `sftp.sb`.

The usual sftp wrapped by lftp utility is considerably faster.

```bash
export HOST=
export USER=
export PASS=

lftp -u ${USER},${PASS} sftp://${HOST} <<EOF
cd genetic_data/for_Grace/compressed;
lcd /rds/project/jmmh2/rds-jmmh2-projects/olink_proteomics/scallop/SCALLOP-Seq/rva;
mirror --parallel=20 --continue --reverse --log=sftp.log --verbose;
bye;
EOF
```

## URLs

* [Sylabs](https://sylabs.io/) ([GitHub](https://github.com/sylabs))
