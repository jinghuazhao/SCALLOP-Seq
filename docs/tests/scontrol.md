# scontrol

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
