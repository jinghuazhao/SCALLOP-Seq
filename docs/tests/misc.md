# Miscellaneous utilities

## cmp

Comparison of results is to seed from [cmp.sh](cmp.sh).

## rm

This is to remove nonactive (NR>5) empty directories,

```bash
ls -t | awk 'NR>5' | parallel -C' ' 'rmdir {}'
```
