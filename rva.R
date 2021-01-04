weswgs <- Sys.getenv("weswgs")
chr <- paste0("chr",Sys.getenv("i"))
vcffile <- paste(weswgs,paste0(chr,".vcf.gz"),sep="-")
gdsfile <- paste(weswgs,paste0(chr,".gds"),sep="-")
# Only SNPs
# SNPRelate::snpgdsVCF2GDS(vcffile, gdsfile)
# the latest
SeqArray::seqVCF2GDS(vcffile, gdsfile, storage.option="ZIP_RA")

