#!/usr/bin/bash

export PERL5LIB=
ls | grep -e 'wes-' -e 'wgs-' | parallel -C' ' 'ls {}*' | gzip -f > weswgs.txt.gz
gunzip -c weswgs.txt.gz | parallel -j8 -C' ' 'md5sum {}*' | gzip -f > weswgs.md5.gz
