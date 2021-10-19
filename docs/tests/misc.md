# Miscellaneous utilities

## cmp

Comparison of results is to seed from [cmp.sh](cmp.sh).

## rm

This is to remove nonactive (non-Cardio, NR>4) empty directories,

```bash
ls -t | awk 'NR>4' | parallel -C' ' 'rmdir {}'
```
## scontrol

The `exon_reg` group is particularly slow (~10hr each) and we attempted to let faster groups done first and hold it with

```bash
scontrol hold 46817784_[29-368]
```

the array indexes were necessary since _22 was already done.

We have from `squeue -u $USER`

```
46817784_[29-368] cclake-hi     _rva    jhz22 PD       0:00      1 (JobHeldUser,None)
```

and restore the jobs with

```bash
scontrol release 46817784
```

to get

```
46817784_[29-368] cclake-hi     _rva    jhz22 PD       0:00      1 (Priority,QOSMaxCpuPerUserLimit)
```

## scancel

This is appropriate since some cclake jobs were furnished with cardio.

```bash
scancel 46817784_[250-299]
```

They were then dropped according to `squeue -u $USER`.
