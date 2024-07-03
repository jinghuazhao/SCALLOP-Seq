#!/usr/bin/bash

export md5=~/rds/results/private/proteomics/scallop-seq/weswgs.md5.gz
gunzip -c ${md5} | grep wes | sort -k2,2 | gzip -f > wes.md5.gz
gunzip -c ${md5} | grep wgs | sort -k2,2 | gzip -f > wgs.md5.gz
export N=$(($(gunzip -c wgs.md5.gz | wc -l)/2+1))
gunzip < wgs.md5.gz | split - --lines=$N --numeric-suffixes --suffix-length=1 wgs-
gzip wgs-*
rm wgs.md5.gz
zcat wgs-{0..1}.gz | gzip -f > wgs.m5.gz
