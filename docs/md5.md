# md5

The md6sum file is obtained from [`weswgs.sh`](weswgs.sh),

```bash
#!/usr/bin/bash

export PERL5LIB=
ls | grep -e 'wes-' -e 'wgs-' | parallel -C' ' 'ls {}*' | gzip -f > weswgs.txt.gz
gunzip -c weswgs.txt.gz | parallel -j8 -C' ' 'md5sum {}*' > weswgs.md5
```

The `weswgs.md5.gz` file is ~87MB which is well above the 50MB threshold for GitHub so it is available as follows,

- wes.md5.gz
- wgs-0.gz, wgs-1.gz

for WES and WGS results, respectively. Optionally, as shown in [`split.sh`](split.sh) a `wgs.md5.gz` can be obtained from `zcat wgs-{0..1}.gz | gzip -f > wgs.m5.gz`.
