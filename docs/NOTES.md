# NOTES

## Installation

```bash
singularity pull -F library://hmgu-itg/default/burden_testing:latest
singularity inspect burden_testing_latest.sif | \
grep Version
singularity exec burden_testing_latest.sif help
singularity exec burden_testing_latest.sif single_cohort_munge_variantlist -h
singularity exec burden_testing_latest.sif prepare-regions -h
singularity exec burden_testing_latest.sif make-group-file -h
```
for the latest or `:1.5.3`, see wiki instructions on [installation](https://github.com/hmgu-itg/burden_testing/wiki/Prerequisites-and-installation), [data](https://github.com/hmgu-itg/burden_testing/wiki/Data-input) and [SMMAT](https://github.com/hmgu-itg/burden_testing/wiki/Single-cohort-analysis-using-SMMAT).

## Debugging

Additional information can be obtained with `singularity exec --help`. For debugging, e.g., on VCF2GDS, one can invoke the singularity shell via

```bash
singularity shell --bind ${PWD} --containall -s /usr/bin/bash burden_testing_latest.sif
```

and the container has its own HOME directory within which `~` is recognised. It is worth noting that the `--bind` option is `-B` with `singularity exec`.

1. in particular that sbatch implicates the `--wait` option as the succeeding steps would require its full results.
2. It would need change `spa.sb` in the number of array jobs and function to call in order to accommodate software and model (BOLT-LMM, GCTA `--fastGWA/fastGWAS-lr` for mixed model/linear regression).
3. The groups have been provided by the central analysis team.

## URLs

* [Sylabs](https://sylabs.io/)