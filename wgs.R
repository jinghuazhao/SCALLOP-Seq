olink <- function(panel)
{
  if (panel=="neu") {
     x <- within(read.table("olink_proteomics/post_QC/interval_olink_neuro_post_qc_data_20180309.txt",as.is=TRUE,header=TRUE),
                {Aliquot_Id <- as.character(Aliquot_Id)})
     renameList <- !names(x)=="Aliquot_Id"
     names(x)[renameList] <- paste(panel,names(x)[renameList],sep="_")
  } else {
     require(Biobase)
     prefix <- "olink_proteomics/post-qc/eset"
     suffix <- "flag.out.outlier.in.rds"
     f <- paste(prefix,panel,suffix,sep=".")
     eset <- readRDS(f)
     fd <- within(as(featureData(eset),"data.frame")[c("ID","uniprot.id")],{
                     ID <- as.character(ID)
                     fdi <- paste0(paste(panel,ID,sep="_"),"__",uniprot.id)
           }) %>% select(-uniprot.id)
    cb <-  cbind(rownames(eset),fd)
    rownames(eset) <- cb[,3]
    x <- as(eset,"data.frame")
  }
  x
}

options(width=200)
require(plyr)
library(dplyr)
cvd2 <- olink("cvd2")
cvd3 <- olink("cvd3")
inf1 <- olink("inf1")
neu <- olink("neu")

# WES/WGS samples
weswgs <- read.delim("work/weswgs.txt")
wgs <- scan("work/wgs.idmap",what="")
pca_wgs <- read.table("work/wgs.eigenvec",col.names=c("FID","id",paste0("PC",1:20))) %>% select(-FID)

## Stata version
idmap <- function(f,weswgs_id)
# the upper bound is already set for all panels
{
  d <- within(read.delim(f), {
         Olink_cvd2_QC_24m <- as.character(Olink_cvd2_QC_24m)
         Olink_cvd3_QC_24m <- as.character(Olink_cvd3_QC_24m)
         Olink_inf_QC_24m <- as.character(Olink_inf_QC_24m)
         Olink_neu_QC_24m <- as.character(Olink_neu_QC_24m)
       })
  names(d)[2] <- "id"
  subset(d,id%in%weswgs_id)
}

id_wgs <- idmap("work/wgs.txt",wgs) %>% select(-c(Olink_cvd2_gwasQC_24m, Olink_cvd3_gwasQC_24m, Olink_inf_gwasQC_24m, Olink_neu_gwasQC_24m))

panels <- function(d,weswgs_id,pca)
{
  d <- d %>%
  rename(Aliquot_Id=Olink_cvd2_QC_24m) %>% left_join(cvd2[c(1:92,104)],by="Aliquot_Id") %>% select(-Aliquot_Id) %>%
  rename(Aliquot_Id=Olink_cvd3_QC_24m) %>% left_join(cvd3[c(1:92,104)],by="Aliquot_Id") %>% select(-Aliquot_Id) %>%
  rename(Aliquot_Id=Olink_inf_QC_24m) %>% left_join(inf1[c(1:92,104)],by="Aliquot_Id") %>% select(-Aliquot_Id) %>%
  rename(Aliquot_Id=Olink_neu_QC_24m) %>% left_join(neu[c(7,53:144)],by="Aliquot_Id") %>% select(-Aliquot_Id) %>%
  rename(id=weswgs_id) %>% mutate(average = rowMeans(select(., starts_with("cvd2_BMP.6__P22004")), na.rm = TRUE)) %>%
  left_join(weswgs[c("identifier","sex","age","age2")]) %>% 
  left_join(pca)
  rownames(d) <- d[["id"]]
  d
}

y_wgs <- panels(id_wgs,"id",pca_wgs)

library(gap)
normalize_sapply <- function(d)
{
  normfun <- function(col,verbose=FALSE)
  {
    if (verbose) cat(names(d[col]),col,"\n")
    y <- invnormal(d[[col]])
    l <- lm(y~average+sex+age+age2+PC1+PC2+PC3+PC4+PC5+PC6+PC7+PC8+PC9+PC10+PC11+PC12+PC13+PC14+PC15+PC16+PC17+PC18+PC19+PC20, data=d[covars])
    r <- y-predict(l,na.action=na.pass)
    invnormal(r)
  }
  proteins <- grep("cvd2|cvd3|inf1|neu",names(d))
  covars <- c(names(d)[grep("average|sex|age",names(d))],paste0("PC",1:20))
  z <- sapply(names(d[proteins]), normfun)
  colnames(z) <- names(d[proteins])
  rownames(z) <- d[["id"]]
  data.frame(id=d[["id"]],z)
}
y_wgs_sapply <- normalize_sapply(y_wgs)
wgs.id <- y_wgs_sapply %>% select(id) %>% rename(FID=id) %>% mutate(IID=FID)
wgs.pheno <- y_wgs_sapply %>% select(-id)
write.table(data.frame(wgs.id,wgs.pheno),file="work/wgs-lr.pheno",quote=FALSE,row.names=FALSE,sep="\t")

output <- function(weswgs,d)
{
  if(!dir.exists(weswgs)) dir.create(weswgs)
  n_vars <- ncol(d)
  invisible(sapply(2:n_vars,function(x)
            {
              print(names(d[x]))
              write.table(d[c(1,x)],file=file.path(weswgs,paste0(names(d[x]),"-lr.pheno")),quote=FALSE,row.names=FALSE,sep="\t")
            })
  )
}
output("work/wgs",y_wgs_sapply)
