# Miscellaneous utilities

## rm

This is to remove nonactive (NR>5) empty directories,

```bash
ls -t | awk 'NR>5' | parallel -C' ' 'rmdir {}'
```
