# INTERVAL analysis

## Programs

| Sequence | Filename  | Description           |
| ---------|---------- | --------------------- |
| 1        | weswgs.sh | WES/WGS preprocessing |
| 2.1      | spa.sh    | Single-point analysis |
| 2.2      | rva.sh    | Rare-variant analysis |

The hierachy of the scripts is as follows,

```mermaid
graph TB;
setup ==> 1; 1 ==> 2;
    1 --> idmap.do; 1 --> wgs.sb;
    2 --> 2.1; 2.1 --> spa.sb; 2.1 --> bgen.sb;
    2 --> 2.2; 2.2 --> wes.R; 2.2 --> wgs.R; 2.2 --> weswgs.R; 2.2 --> rva.sb; 2.2 --> prune.wrap;
```

## Variant lists and results

INTERVAL variant lists and results submitted centrally are detailed below..

## Variant lists as of 11/11/2020

The following two files were also uploaded.

* INTERVAL-wes.variantlist.gz
* INTERVAL-wgs.variantlist.gz

for WES and WGS, respectively.

## Variant lists as of 10/11/2020

* A combination of WES+WGS when there were samples with cvd2/cvd3/inf/neu measurements.

To find out which variants were exclusively from WES, we do
```
gunzip -c INTERVAL-wes+wgs.variantlist.gz | awk '$6<2000' | wc -l
```
giving 636,046 out of 116,133,865.

## Variant lists as of 09/11/2020

* The data contains both WES and WGS genotypes
  -- the sample overlap was only five in the four Olink panels.

* It is expected that there will be very minor changes with additional work on sample/genotype QC.

## Multiple linear regressions (+20 PCs as covariates)

They replaced mixed models for 122 proteins + WES and inf1_IL.17A__Q16552 + WGS.

```
cvd2_ANG.1__Q15389
cvd2_ADAM.TS13__Q76LX8
cvd2_Protein.BOC__Q9BWV1
cvd2_IL.4RA__P24394
cvd2_STK4__Q13043
cvd2_PAR.1__P25116
cvd2_TF__P13726
cvd2_IL1RL2__Q9HB29
cvd2_PDGF.subunit.B__P01127
cvd2_CXCL1__P09341
cvd2_GIF__P27352
cvd2_PIgR__P01833
cvd2_SOD2__P04179
cvd2_FGF.23__Q9GZV9
cvd2_GH__P01241
cvd2_GLO1__Q04760
cvd2_CD84__Q9UIB8
cvd2_PAPPA__Q13219
cvd2_REN__P00797
cvd2_THBS2__P35442
cvd2_XCL1__P47992
cvd2_SORT1__Q99523
cvd2_CCL17__Q92583
cvd2_MMP.7__P09237
cvd2_ITGB1BP2__Q9UKP3
cvd2_Dkk.1__O94907
cvd2_LPL__P06858
cvd2_THPO__P40225
cvd2_BNP__P16860
cvd2_MMP.12__P39900
cvd2_hOSCAR__Q8IYS5
cvd2_TGM2__P21980
cvd2_CA5A__P35218
cvd2_HSP.27__P04792
cvd2_PARP.1__P09874
cvd2_HAOX1__Q9UJM8
cvd3_TNFRSF14__Q92956
cvd3_ITGB2__P05107
cvd3_IL.17RA__Q96F46
cvd3_OPG__O00300
cvd3_SELP__P16109
cvd3_BLM.hydrolase__Q13867
cvd3_PLC__P98160
cvd3_LTBR__P36941
cvd3_Notch.3__Q9UM47
cvd3_PAI__P05121
cvd3_CCL24__O00175
cvd3_SELE__P16581
cvd3_AZU1__P20160
cvd3_IL.6RA__P08887
cvd3_RETN__Q9HD89
cvd3_FAS__P25445
cvd3_MB__P02144
cvd3_OPN__P10451
cvd3_CTSD__P07339
cvd3_Gal.4__P56470
cvd3_CASP.3__P42574
cvd3_CPB1__P15086
cvd3_CHI3L1__P36222
cvd3_ST2__Q01638
cvd3_CTSZ__Q9UBR2
cvd3_MMP.3__P08254
cvd3_PDGF.subunit.A__P04085
cvd3_PECAM.1__P16284
cvd3_NT.pro.BNP__NA
inf1_MCP.3__P80098
inf1_CD244__Q9BZW8
inf1_IL.7__P13232
inf1_IL.17A__Q16552
inf1_CXCL11__O14625
inf1_AXIN1__O15169
inf1_IL.20RA__Q9UHF4
inf1_CST5__P28325
inf1_CXCL1__P09341
inf1_CCL4__P13236
inf1_CD6__Q8WWJ7
inf1_MCP.4__Q99616
inf1_CCL11__P51671
inf1_TNFSF14__O43557
inf1_FGF.23__Q9GZV9
inf1_LIF.R__P42702
inf1_IL.22.RA1__Q8N6P7
inf1_Beta.NGF__P01138
inf1_IL.13__P35225
inf1_MMP.10__P09238
inf1_TNF__P01375
inf1_CD5__P06127
inf1_CXCL6__P80162
inf1_4E.BP1__Q13541
inf1_IL.20__Q9NYY1
inf1_SIRT2__Q8IXJ6
inf1_CD40__P25942
inf1_IFN.gamma__P01579
inf1_FGF.19__O95750
inf1_LIF__P15018
inf1_NRTN__Q99748
inf1_MCP.2__P80075
inf1_CCL25__O15444
inf1_NT.3__P20783
inf1_IL.5__P05113
inf1_ADA__P00813
neu_GDNF___P39905
neu_EZR___P15311
neu_NCAN___O14594
neu_PRTG___Q2VWP7
neu_PLXNB3___Q9ULL4
neu_LRPAP1___P30533
neu_CLEC1B___Q9P126
neu_ADAM23___O75077
neu_RSPO1___Q2MKA7
neu_LGALS8___O00214
neu_FLRT2___O43155
neu_CLEC10A___Q8IUN9
neu_CTSC___P53634
neu_JAM2___P57087
neu_CTSS___P25774
neu_ASAH2___Q9NR71
neu_ULBP2___Q9BZM5
neu_CD300LF___Q8TDQ1
neu_LAT___O43561
neu_NTRK3___Q16288
neu_TNR___Q92752
```
