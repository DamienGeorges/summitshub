# SuMMITS downscaled data presentation
damien g. (damien.georges2 at gmail.com)  
04/11/2015  
## What is this document for?
This document aims to present the downsclaled version of past temperature
for mountains of the **SUMMITS** project. For each location **30s resolution**
version of past monthly/seasonal mean  temperature have been produced based on 
**cru_ts 3.23**, **casty 2007**, **Xoplaki 2005** downscaled according to the 
latest version of **worldclim** data. 

## where are the downscaled data?
Data are currently stored on the Ecoinformatics network drive at the locataion :

[I:/C_Write/Damien/SUMMITS/OUTPUTS/summits_downsc_temp.csv](I:/C_Write/Damien/SUMMITS/OUTPUTS/summits_downsc_temp.csv)

## What data has been used?
The aim of this procedure is to produce 30s resolution monthly/seasonal mean 
temperature from 1800 to nowadays.

### Past temperatures
The past mean temperature are originaly at 0.5deg resolution.
We considered 3 different past temperature datasets:

 - **cru**: monthly mean temperature from 1900 to 2014 based on CRU_TS 3.23  
    *download link*: [http://www.cru.uea.ac.uk/cru/data/hrg/cru_ts_3.23/](http://www.cru.uea.ac.uk/cru/data/hrg/cru_ts_3.23/)  
    *ref*: Harris, I., Jones, P.D., Osborn, T.J. and Lister, D.H. (2014), Updated
    high-resolution grids of monthly climatic observations the CRU TS3.10
    Dataset. Int. J. Climatol., 34: 623642. doi: 10.1002/joc.3711  
    *extra info*: refer to [Release_Notes_CRU_TS3.23_rev231015.txt](http://www.cru.uea.ac.uk/cru/data/hrg/cru_ts_3.23/Release_Notes_CRU_TS3.23_rev231015.txt)  
    
 - **cas**: monthly mean temperature from 1500 to 2000  
    *download link*: [http://www1.ncdc.noaa.gov/pub/data/paleo/historical/europe/casty2007/](http://www1.ncdc.noaa.gov/pub/data/paleo/historical/europe/casty2007/)
    *ref*: Casty, C., et al.  2008. European Gridded Monthly Temperature, Precipitation and 500hPa Reconstructions. 
    IGBP PAGES/World Data Center for Paleoclimatology Data Contribution Series # 2008-023. 
    NOAA/NCDC Paleoclimatology Program, Boulder CO, USA.  
    *extra info*: refer to [readme-casty2007.txt](http://www1.ncdc.noaa.gov/pub/data/paleo/historical/europe/casty2007/readme-casty2007.txt)  
 
 - **xop**: seasonal mean temperature from 1500 to 2002  
    *download link*: [http://www1.ncdc.noaa.gov/pub/data/paleo/historical/europe-seasonal-files/](http://www1.ncdc.noaa.gov/pub/data/paleo/historical/europe-seasonal-files/)  
    *ref*: Luterbacher, J., Dietrich, D., Xoplaki, E., Grosjean, M., and Wanner, H., 2004:
    European seasonal and annual temperature variability, trends, and extremes since 1500,
    Science 303, 1499-1503 (DOI:10.1126/science.1093877).  
    Xoplaki, E., Luterbacher, J., Paeth, H., Dietrich, D., Steiner N., Grosjean, M., and Wanner, H., 2005:
    European spring and autumn temperature variability and change of extremes over the last half millennium,
    Geophys. Res. Lett., 32, L15713 (DOI:10.1029/2005GL023424)  
    *extra info*: refer to [Readme_TT_1500_2002.txt](http://www1.ncdc.noaa.gov/pub/data/paleo/historical/europe-seasonal-files/Readme_TT_1500_2002.txt)  

### Higher resolution data  
To downscale the past climatic data from 0.5deg resolution to 30s resolution
we used the **worldclim monthly mean temperature**.  
*download link*: [http://www.worldclim.org/current](http://www.worldclim.org/current)  
*ref*: Hijmans, R.J., S.E. Cameron, J.L. Parra, P.G. Jones and A. Jarvis, 2005. 
Very high resolution interpolated climate surfaces for global land areas. 
International Journal of Climatology 25: 1965-1978.  
*extra info*: [http://www.worldclim.org/methods](http://www.worldclim.org/methods)


**note**: we also used the **worldclim elevation** data to correct predicted 
 predicted temperature according to the differences between worlclim elevation
 and summits observed elevatrion (we use a **-0.5deg / 100m** correction factor)
 
## Downscale procedure
Here is a schematic representation of the downscale procedure:  

![downscaling procedure scheme](https://github.com/DamienGeorges/summitshub/blob/master/images/downscaling_procedure.png)
  
The main downscaling procedure should be summarised in 3 main steps:

  1. Calculating the **&Delta; temp due to climatic source**: anomalies between worldclim and one of the past cliamtic dataset (PCD)
    + we extract the mean monthly temperature from WorldClim layer for one summit location
    + we extract the mean temperature from PCD for the matching period (same month(s) from 1950 to 2000) and compute the average value
    + we deduce the anomaly associated to the PCD for this summit
    
  2. Calculating the **&Delta; temp due to elevation correction**: correction of temperature 
  according to altitudinal difference between woldclim elevation layer and the observed elevation of our summit
  
  3. Calculate the downscaled past temperature of our summit: we simply add the 2 &Delta; to the raw past temperature extraction
  
  
## Source code
If you want to see exactly how the downscale procedure have been proceed, you
should refer to the source code available here :  
[https://github.com/DamienGeorges/summitshub/tree/master/scripts](https://github.com/DamienGeorges/summitshub/tree/master/scripts)  
Scripts workflow is the following (some scripts needs outputs of others to be run):  
  1. [cell_extraction_and_polygons.R](https://github.com/DamienGeorges/summitshub/tree/master/scripts/cell_extraction_and_polygons.R)  
  2. [climatic_sources_comparison.R](https://github.com/DamienGeorges/summitshub/tree/master/scripts/climatic_sources_comparison.R)  
  3. [climatic_sources_mean_tmp_extraction.R](https://github.com/DamienGeorges/summitshub/tree/master/scripts/climatic_sources_mean_tmp_extraction.R)  
  4. [downscale_mean_temperature.R](https://github.com/DamienGeorges/summitshub/tree/master/scripts/downscale_mean_temperature.R)  

Optionaly:
 - [climatic_sources_comparison_graphs.R](https://github.com/DamienGeorges/summitshub/tree/master/scripts/climatic_sources_comparison_graphs.R)  
 - [check_downscaled_mean_temperature.R](https://github.com/DamienGeorges/summitshub/tree/master/scripts/check_downscaled_mean_temperature.R) (to produce this document)
 
## Donwscaled data exploration


```r
setwd("J:/People/Damien/SUMMITS/WORKDIR")
rm(list = ls())
```

### load libraries 


```r
library(dplyr)
library(tidyr)
library(ggplot2)
```

### basics checkings
Downscaled data are stored within [summits_downsc_temp.csv]() file.


```r
# tmp.dwsc <- read.csv("../OUTPUTS/summits_downsc_temp.csv")
tmp.dwsc <- read.csv("I:/C_Write/Damien/SUMMITS/OUTPUTS/summits_downsc_temp.csv")
head(tmp.dwsc)
```

```
##   mountain_id mountain_name   ycoord   xcoord mtn_altitude clim_source
## 1        sds1         Agjek 69.36749 20.42337         1262         cas
## 2        sds1         Agjek 69.36749 20.42337         1262         cas
## 3        sds1         Agjek 69.36749 20.42337         1262         cas
## 4        sds1         Agjek 69.36749 20.42337         1262         cas
## 5        sds1         Agjek 69.36749 20.42337         1262         cas
## 6        sds1         Agjek 69.36749 20.42337         1262         cas
##   year period mean_tmp_dwsc
## 1 1800      1    -17.472059
## 2 1800      2    -17.192059
## 3 1800      3    -15.782059
## 4 1800      4     -8.751863
## 5 1800      5     -3.093235
## 6 1800      6      2.995196
```

In this file we have:  

| var name  |  var type | var description  |
|---|---|---|
| **mountain_id** | *character* | a unique id identifying the summit (unique combinasion of summit name, coordinates and altitude)  |
| **mountain_name** | *character* | summit name as given in the formal dataset  |
| **ycoord**  | *numeric* | the raw latitude of the summit (wgs84) |
| **xcoord**  | *numeric* | the raw longitude of the summit (wgs84)  |
| **mtn_altitude**  | *numeric* | the raw elevation of the summit  |
| **clim_source** | *character* | the data climatic value values are based on (i.e. cru, cas or xop)  |
| **year**  | *numeric* | the year oconsidered |
| **period**  | *numeric* | the period considered (i.e. 1-12: month (Jan-Dec), 13: winter, 14: spring, 15: summer, 16 fall)  |
| **mean_tmp_dwsc** | *numeric* | the 30s resolution downscaled temperature |
|   |   |   |

### Time scale according to climatic data source


```r
tmp.dwsc %>% group_by(clim_source) %>% summarise(first_year = min(year), last_year = max(year), n_year = length(unique(year)))
```

```
## Source: local data frame [3 x 4]
## 
##   clim_source first_year last_year n_year
##        (fctr)      (int)     (int)  (int)
## 1         cas       1800      2000    201
## 2         cru       1901      2014    114
## 3         xop       1800      2002    203
```

```r
tmp.dwsc %>% group_by(clim_source) %>% summarise(first_period = min(period), last_period = max(period), n_period = length(unique(period)))
```

```
## Source: local data frame [3 x 4]
## 
##   clim_source first_period last_period n_period
##        (fctr)        (int)       (int)    (int)
## 1         cas            1          16       16
## 2         cru            1          16       16
## 3         xop           13          16        4
```

### Number of summit considered according to climatic data source


```r
tmp.dwsc %>% group_by(clim_source) %>% summarise(n_mnt = length(unique(mountain_id)))
```

```
## Source: local data frame [3 x 2]
## 
##   clim_source n_mnt
##        (fctr) (int)
## 1         cas   399
## 2         cru   399
## 3         xop   399
```

```r
tmp.dwsc %>% group_by(clim_source) %>% summarise(n_NA = sum(is.na(mean_tmp_dwsc)), pc_NA = sum(is.na(mean_tmp_dwsc)) / length(mean_tmp_dwsc))
```

```
## Source: local data frame [3 x 3]
## 
##   clim_source  n_NA      pc_NA
##        (fctr) (int)      (dbl)
## 1         cas     0 0.00000000
## 2         cru     0 0.00000000
## 3         xop  5684 0.01754386
```

**note:** some high latitude doesn't have data for Xoplakis (reduced extent)


```r
na_sites <- function(dd){
  NA_sites = unique(dd$mountain_name[is.na(dd$mean_tmp_dwsc)])
  if(!length(NA_sites)) NA_sites <- NA
  data.frame(clim_source = unique(dd$clim_source), NA_sites = NA_sites)
} 
tmp.dwsc %>% group_by(clim_source) %>% do(na_sites(dd = .))
```

```
## Source: local data frame [9 x 2]
## Groups: clim_source [3]
## 
##   clim_source       NA_sites
##        (fctr)         (fctr)
## 1         cas             NA
## 2         cru             NA
## 3         xop    Hjorthfjell
## 4         xop       Konussen
## 5         xop  Lundbohmfjell
## 6         xop      Botn/Brun
## 7         xop Campbellryggen
## 8         xop          Vesuv
## 9         xop    Gattytoppen
```

### some graphical reperesentations
#### mean summer temperature accros our summits


```r
tmp.dwsc.win <- tmp.dwsc %>% filter(period == 13) %>% arrange(mountain_id)
tmp.dwsc.win$mountain_id <- factor(tmp.dwsc.win$mountain_id, levels = gtools::mixedsort(unique(tmp.dwsc.win$mountain_id)))
gg <- ggplot(data = tmp.dwsc.win, mapping = aes(x = year, y = mean_tmp_dwsc, colour = clim_source)) +
  geom_line(alpha = .3) + facet_wrap(~mountain_id, ncol = 10) + 
  theme(axis.text.x = element_text(angle=90))
gg
```

![](https://github.com/DamienGeorges/summitshub/blob/master/images/summits_past_temp_trends.png) 

#### correspondance between summits id and summits names


```r
mont_ids <- tmp.dwsc %>% select(mountain_id, mountain_name, ycoord, xcoord, mtn_altitude) %>% 
   as.data.frame %>% distinct %>% arrange(mountain_name)
```

```r
knitr::kable(mont_ids)
```



mountain_id | mountain_name | ycoord | xcoord | mtn_altitude
------------ | ------------------------------ | --------- | ----------- | -------------
sds1 | Agjek | 69.36749 | 20.4233725 | 1262.0
sds2 | Alplihorn_Monstein | 46.71083 | 9.8258220 | 3006.0
sds3 | Altenorenstock | 46.86039 | 8.9412590 | 2480.0
sds4 | Aroser_Alplihorn | 46.74832 | 9.6108960 | 2842.0
sds5 | Aroser_Rothorn | 46.73788 | 9.6139570 | 2980.0
sds6 | Arre_Sourins | 42.92528 | 0.3336080 | 2614.0
sds7 | Basdino | 46.41156 | 8.4684270 | 3272.0
sds8 | Basdino | 46.41156 | 8.4684270 | 3272.0
sds9 | Basâdino | 46.41156 | 8.4684270 | 3272.0
sds10 | Baslersch_Chopf | 46.78146 | 9.9044270 | 2629.0
sds11 | Båtfjellet | 66.85974 | 15.6041295 | 1060.0
sds12 | Becca_di_Nona | 45.68714 | 7.3660540 | 3142.0
sds13 | Becca_di_Nona | 45.68729 | 7.3657700 | 3142.0
sds14 | Beggistock_Vorgipfel | 46.84916 | 8.9363870 | 2587.0
sds15 | Beinn Hearsgarnich | 56.51020 | -4.5791400 | 1078.0
sds16 | Belianska_kopa | 49.22722 | 20.2238880 | 1835.0
sds17 | Ben Lawers | 56.54556 | -4.2208330 | 1214.0
sds18 | Ben Lui | 56.39704 | -4.8111000 | 1130.0
sds19 | Ben More | 56.38638 | -4.5392670 | 1174.0
sds20 | Bentsjordtinden | 69.51551 | 18.6447032 | 1096.0
sds21 | Berdalseken | 61.20294 | 7.9164609 | 1814.0
sds22 | Bergheien | 69.04640 | 17.4059271 | 563.0
sds23 | Bessho | 61.50523 | 8.7050233 | 2258.0
sds24 | Borterhorn | 46.74372 | 9.8855900 | 2697.0
sds25 | Bos_Fulen | 46.96694 | 8.9455610 | 2802.0
sds26 | Botn/Brun | 78.27000 | 16.5200000 | 922.0
sds27 | Broran | 68.89342 | 18.9556001 | 1427.0
sds28 | Bueelenhorn | 46.67244 | 9.7664260 | 2808.0
sds29 | BUHAIESCU | 47.58263 | 24.6324500 | 2221.0
sds30 | Bukkehammaren | 61.47022 | 8.7072311 | 1910.0
sds31 | Camoghe | 46.13486 | 9.0642130 | 2228.0
sds32 | Camp Cairn | 57.09029 | -3.8428500 | 904.0
sds33 | Campbellryggen | 78.60000 | 16.7800000 | 862.0
sds34 | Campo_Tencia | 46.42977 | 8.7259410 | 3072.0
sds35 | Casanna | 46.85938 | 9.8281900 | 2557.0
sds36 | Cassonsgrat_calcareous | 46.88106 | 9.2700090 | 2665.0
sds37 | Cassonsgrat_silicate | 46.87868 | 9.2795490 | 2695.0
sds38 | Chamerstock | 46.89377 | 8.9649630 | 2126.0
sds39 | Chlein_Schwarzhorn | 46.74341 | 9.9365300 | 2968.0
sds40 | Chlin_Horn | 46.43539 | 9.4980030 | 2869.0
sds41 | Chorbsch_Horn | 46.79063 | 9.7674080 | 2654.0
sds42 | Chrachenhorn | 46.68848 | 9.8143440 | 2891.0
sds43 | Chuepfenflue | 46.80736 | 9.7760740 | 2658.0
sds44 | Chummer_Schwarzhorn | 46.77767 | 9.7425220 | 2759.0
sds45 | Chummerhuereli | 46.77284 | 9.7535270 | 2600.0
sds46 | Cima_Gana_Bianca | 46.46249 | 8.9716610 | 2842.0
sds47 | Cime Bianche | 45.92071 | 7.6951310 | 3014.0
sds48 | Colle Lago Bianco | 45.64729 | 7.5950810 | 2340.0
sds49 | Corno_del_camoscio | 45.87311 | 7.8678400 | 3026.0
sds50 | Corno_del_Camoscio | 45.87319 | 7.8694720 | 3026.0
sds51 | Corno_di_Gesero | 46.18548 | 9.1312720 | 2227.0
sds52 | Corona_di_Redorta | 46.37549 | 8.7322710 | 2804.0
sds53 | Creag Mhigeachaidh | 57.09889 | -3.8602770 | 742.0
sds54 | Creag Mhor | 56.48889 | -4.6138890 | 1047.0
sds55 | Da Wllane | 46.72748 | 10.9593000 | 3074.0
sds56 | Dadatjkka | 66.45226 | 16.1700160 | 1213.0
sds57 | Dadatjkka | 66.45226 | 16.1700160 | 1213.0
sds58 | Do Peniola | 46.38282 | 11.6054500 | 2463.0
sds59 | Dømannknut | 69.86033 | 22.0520678 | 683.0
sds60 | Dreggfjellet | 68.74409 | 19.6134272 | 1464.0
sds61 | Elgen | 68.89375 | 16.2665309 | 534.0
sds62 | Emilius | 45.34448 | 7.2747000 | 3559.0
sds63 | Emilius | 45.67886 | 7.3848630 | 3559.0
sds64 | Estom_Soubiran | 42.78115 | -0.0926010 | 2829.0
sds65 | Faglmugl | 46.74385 | 11.1618200 | 2180.0
sds66 | Fannaraaki | 61.51463 | 7.9061559 | 2068.0
sds67 | Fastdalstind | 69.62938 | 20.1679725 | 1275.0
sds68 | Felsberger_Calanda | 46.88121 | 9.4561150 | 2697.0
sds69 | Festkogel | 46.85218 | 11.0511090 | 3038.0
sds70 | Fibbia | 46.54276 | 8.5476410 | 2738.0
sds71 | Fierras | 66.48998 | 15.9141210 | 1605.0
sds72 | Finnkona | 69.41801 | 17.4345904 | 779.0
sds73 | Flueela_Schwarzhorn | 46.73448 | 9.9375560 | 3146.0
sds74 | Flueela_Weisshorn | 46.73581 | 9.9418100 | 3085.0
sds75 | frihetsli storfjellet | 68.77771 | 19.7122152 | 1091.0
sds76 | Frondiella | 42.83280 | -0.2906000 | 3071.0
sds77 | Frostdalsnosi | 61.19535 | 7.9903235 | 1536.0
sds78 | Gmpiflue | 46.96417 | 9.8631620 | 2390.0
sds79 | Galdhopiggen | 61.63325 | 8.3434603 | 2469.0
sds80 | Gatschieferspitz | 46.83222 | 9.9269400 | 2676.0
sds81 | Gattytoppen | 78.28000 | 16.6600000 | 866.0
sds82 | Gazzirola | 46.11774 | 9.0723720 | 2116.0
sds83 | Gemsfairenstock | 46.86047 | 8.9178540 | 2972.0
sds84 | Gerlachovsk? ?tt | 49.16389 | 20.1341670 | 2654.0
sds85 | Gerlachovskì ?t¡t | 49.16389 | 20.1341670 | 2654.0
sds86 | Giewont | 49.25097 | 19.9330560 | 1894.0
sds87 | Gïhacktkogel | 47.61389 | 15.1315200 | 2214.0
sds88 | Gletscherducan | 46.67482 | 9.8301650 | 3020.0
sds89 | Glittertinden | 61.65196 | 8.5261779 | 2472.0
sds90 | GOLGOTA | 47.60050 | 24.6252700 | 2010.0
sds91 | Gorihorn | 46.79533 | 9.9593430 | 2986.0
sds92 | Gran Facha | 42.80830 | -0.2378000 | 3005.0
sds93 | Grand_Gabizos | 42.93094 | 0.2838000 | 2684.0
sds94 | Grand_Vignemale | 42.77394 | 0.1473500 | 3298.0
sds95 | Grannosi | 61.20887 | 7.9602029 | 1615.0
sds96 | Grasmugl | 46.33082 | 11.5624800 | 2199.0
sds97 | Graveggi | 61.16922 | 7.8518281 | 1564.0
sds98 | Gretji | 46.68738 | 9.8057690 | 2652.0
sds99 | GROPILE | 47.57251 | 24.6175400 | 2063.0
sds100 | Grosshorn | 46.44923 | 9.4976560 | 2781.0
sds101 | Guener_Horn | 46.71916 | 9.2844520 | 2851.0
sds102 | Hrteigen | 61.11350 | 7.4900000 | 1691.0
sds103 | HÃrteigen | 61.11350 | 7.4900000 | 1691.0
sds104 | Haldensteiner_Calanda | 46.89979 | 9.4674070 | 2805.0
sds105 | Havran | 49.24833 | 20.1975000 | 2152.0
sds106 | Havran2 | 49.24833 | 20.1975000 | 2152.0
sds107 | Heimdalsho | 61.45614 | 8.9043305 | 1843.0
sds108 | Hinterer_Seelenkogel | 46.80139 | 11.0444440 | 3470.0
sds109 | Hinterer_Spiegelkogel | 46.82930 | 10.9588110 | 3426.0
sds110 | Hjertinden | 68.99538 | 18.2268559 | 1380.0
sds111 | Hjorthfjell | 78.26000 | 15.8300000 | 904.0
sds112 | Hl£py | 49.23667 | 20.2100000 | 2060.0
sds113 | Hl£py2 | 49.23667 | 20.2100000 | 2061.0
sds114 | HlÂ·py | 49.23667 | 20.2100000 | 2060.0
sds115 | Hlpy | 49.23667 | 20.2100000 | 2060.0
sds116 | Hoch_Turm | 46.93222 | 8.9355640 | 2666.0
sds117 | Huereli_Avers | 46.49332 | 9.5086100 | 2762.0
sds118 | Igl_Compass | 46.58930 | 9.8231170 | 3016.0
sds119 | Jah?ac¡ ?t¡t | 49.21972 | 20.2119430 | 2230.0
sds120 | Jah?ac ?tt | 49.21972 | 20.2119430 | 2230.0
sds121 | Jah?acÃ_ÃtÃt | 49.21972 | 20.2119430 | 2230.0
sds122 | Jatzhorn | 46.76583 | 9.8600320 | 2682.0
sds123 | Kbrek_nord | 66.45702 | 16.0257970 | 1435.0
sds124 | Kbrek_sr | 66.45530 | 16.0235550 | 1425.0
sds125 | KRSATJKKA | 68.34817 | 18.3336300 | 1560.0
sds126 | KRSAVAGGE | 68.34221 | 18.5031900 | 1000.0
sds127 | Kamienista | 49.19544 | 19.8706390 | 2126.0
sds128 | Kampen | 68.96090 | 18.2571842 | 963.0
sds129 | Kaserwartl | 46.75567 | 10.8824700 | 3287.0
sds130 | Kavringtind | 69.54710 | 20.1243994 | 1289.0
sds131 | Kebnetjakko_Liltoppen | 67.88645 | 18.5928510 | 1531.0
sds132 | Kirken | 61.54323 | 8.2945692 | 2032.0
sds133 | Knutsholstinden | 61.43391 | 8.5557323 | 2341.0
sds134 | Kbrek_nord | 66.45702 | 16.0257970 | 1435.0
sds135 | Kbrek_s¿r | 66.45530 | 16.0235550 | 1425.0
sds136 | Kolla | 62.29214 | 9.4866100 | 1651.0
sds137 | Konussen | 78.32000 | 15.8300000 | 983.0
sds138 | Kopa Magury | 49.24861 | 20.0006390 | 1704.0
sds139 | Kr tka | 49.16306 | 20.0144400 | 2335.5
sds140 | Kr¡?na | 49.18083 | 19.9497200 | 1918.6
sds141 | Krekahaugen | 61.23548 | 7.9782702 | 1512.0
sds142 | Krekanosi | 61.22951 | 7.9471918 | 1554.0
sds143 | Krekanosi.S | 61.21899 | 7.9435027 | 1533.0
sds144 | Krzesanica | 49.23169 | 19.9102220 | 2122.0
sds145 | La Ly | 46.03076 | 7.2491700 | 2360.0
sds146 | Lago Balena | 45.64030 | 7.5517440 | 2584.0
sds147 | Lancebranlette | 45.68525 | 6.8571530 | 2938.0
sds148 | Las_Sours | 46.50100 | 9.9280830 | 2979.0
sds149 | LATNJACHORRU | 68.35533 | 18.5222400 | 1300.0
sds150 | Lenzer_Horn | 46.70901 | 9.5950790 | 2906.0
sds151 | Lifjellet | 68.68358 | 19.0313530 | 1051.0
sds152 | Lomnick? ?tt | 49.19583 | 20.2127780 | 2634.0
sds153 | Lomnickì ?t¡t | 49.19583 | 20.2127780 | 2634.0
sds154 | Loppenosi | 61.17046 | 7.8974976 | 1612.0
sds155 | Lundbohmfjell | 78.59000 | 14.4400000 | 480.0
sds156 | Madone_Batnall | 46.30413 | 8.4405210 | 2748.0
sds157 | Mattagaisi | 68.79769 | 19.1591029 | 1636.0
sds158 | Meall nan | Tarmachan | 56.52168 | -4.3016500 | 1043.0
sds159 | Mederger_Flue | 46.79233 | 9.7501330 | 2706.0
sds160 | Merciantaira | 44.50586 | 6.5253700 | 3293.0
sds161 | Merciantaira | 44.84885 | 6.8823760 | 3293.0
sds162 | Mi?guszowiecki | 49.18306 | 20.0675000 | 2410.0
sds163 | Middagshaugen | 67.50674 | 14.7636796 | 275.0
sds164 | Minschuns | 46.64543 | 10.3379200 | 2519.0
sds165 | Mittler_Wissberg | 46.48563 | 9.5291350 | 3002.0
sds166 | Monne_de_Cauterets | 42.89361 | 0.1669420 | 2724.0
sds167 | Mont Brl | 46.02057 | 7.2013700 | 2550.0
sds168 | Mont_Crammont | 45.76329 | 6.9464200 | 2737.0
sds169 | Mont_FallÃre | 45.77541 | 7.1945100 | 3061.0
sds170 | Mont_Fallre | 45.77541 | 7.1945100 | 3061.0
sds171 | Mont_Valaisan | 45.66382 | 6.9022600 | 2891.0
sds172 | Mont_Valier | 42.79748 | 1.0856700 | 2838.0
sds173 | Monte Schutto | 46.52470 | 11.8147800 | 2893.0
sds174 | Monte_Garone | 46.48775 | 10.0485160 | 3030.0
sds175 | Monte_Marzo | 45.33448 | 7.3631800 | 2756.0
sds176 | Monte_Marzo | 45.56245 | 7.6088480 | 2756.0
sds177 | Monte_Perdido | 42.67555 | 0.0343640 | 3345.0
sds178 | Monte_Perdido | 42.67555 | 0.0343640 | 3355.0
sds179 | Monte_Turbon | 42.41691 | 0.5053170 | 2492.0
sds180 | Monte_Vago | 46.44070 | 10.0790340 | 3059.0
sds181 | Mot dal Gajer | 46.69434 | 10.3311000 | 2796.6
sds182 | Mot sper Chamana Sesvenna | 46.73565 | 10.4286000 | 2424.0
sds183 | Mot_dal_Gajer | 46.69440 | 10.3308120 | 2797.0
sds184 | Muchetta | 46.67519 | 9.7320930 | 2623.0
sds185 | Munt Buffalora | 46.63856 | 10.2436400 | 2438.0
sds186 | Munt Chavagl | 46.64419 | 10.2340700 | 2542.0
sds187 | Munt_Pers | 46.42142 | 9.9535550 | 3207.0
sds188 | Napfspitze | 46.94015 | 11.7399530 | 2888.0
sds189 | Negoiu | 45.58700 | 24.5557000 | 2535.0
sds190 | Neidatjkko | 66.87116 | 16.1448980 | 1505.0
sds191 | Neidatjkko | 66.87116 | 16.1448980 | 1505.0
sds192 | Nheils | 61.57707 | 8.4275105 | 2072.0
sds193 | Nissontjarro_high | 68.25213 | 18.9343710 | 1738.0
sds194 | Nissontjarro_low | 68.27565 | 18.8897820 | 1372.0
sds195 | Nissontjarro_mid | 68.26085 | 18.9578030 | 1633.0
sds196 | Njulla | 68.37257 | 18.6988000 | 1164.0
sds197 | Nord_Saulo | 66.98430 | 16.1931820 | 1768.0
sds198 | Nosal | 49.27644 | 19.9894440 | 1206.0
sds199 | Novì | 49.25000 | 20.1869400 | 1999.0
sds200 | Ober_Rothorn | 46.01039 | 7.4845900 | 3415.0
sds201 | Ober_Rothorn | 46.02758 | 7.8127580 | 3415.0
sds202 | Ochsenstock | 46.82869 | 8.9473220 | 2265.0
sds203 | Ornak | 49.21936 | 19.8336110 | 1854.0
sds204 | Ortstock | 46.92527 | 8.9483450 | 2717.0
sds205 | P_2845_westofSassCorviglia | 46.51526 | 9.7958800 | 2845.0
sds206 | P_2866_Radnt | 46.72821 | 9.9698600 | 2866.0
sds207 | P_3024 | 46.68741 | 9.9374690 | 3024.0
sds208 | Pallentjokka_high | 68.24802 | 18.8137360 | 1737.0
sds209 | Pallentjokka_low | 68.26284 | 18.7821080 | 1523.0
sds210 | Paras | 69.09982 | 20.1579618 | 1419.0
sds211 | Parpaner_Rothorn | 46.69266 | 9.9240300 | 2899.0
sds212 | Peljekaise | 66.34229 | 16.9483370 | 1137.0
sds213 | Petit_Gabizos | 42.93914 | 0.2793080 | 2639.0
sds214 | Pic_Balaitous | 42.83894 | 0.2902580 | 3144.0
sds215 | Pic_Balaitous | 42.83894 | 0.2902580 | 3146.0
sds216 | Pic_Carlitte | 42.57110 | 1.9313920 | 2921.0
sds217 | Pic_du_Ger | 42.93639 | 0.3541670 | 2613.0
sds218 | Pic_du_Midi_dOssau | 42.84306 | 0.4372190 | 2884.0
sds219 | Pic_du_Midi_dOssau | 42.84306 | 0.4372190 | 2885.0
sds220 | Pica_de_Canigo | 42.51910 | 2.4565000 | 2785.0
sds221 | Pico_Bisaurin | 42.78848 | 0.6399580 | 2670.0
sds222 | Pico_del_Aspe | 42.76347 | 0.5657890 | 2645.0
sds223 | Pischahorn | 46.81389 | 9.9472730 | 2980.0
sds224 | Piz Costainas | 46.56224 | 10.4748800 | 3004.0
sds225 | Piz Cotschen/Ciantun | 46.54185 | 10.4572800 | 3026.0
sds226 | Piz Foraz | 46.69075 | 10.2767200 | 3092.0
sds227 | Piz Murtr | 46.64578 | 10.1417100 | 2836.0
sds228 | Piz Plazer | 46.70862 | 10.3880000 | 3104.0
sds229 | Piz Umbrail | 46.55096 | 10.4144300 | 3033.0
sds230 | Piz_Alv | 46.44931 | 9.9995780 | 2975.0
sds231 | Piz_Beverin | 46.65248 | 9.3579240 | 2998.0
sds232 | Piz_Blaisun | 46.60317 | 9.8628890 | 3200.0
sds233 | Piz_Borel | 46.58217 | 8.6994150 | 2951.0
sds234 | Piz_Calderas | 46.53646 | 9.6960490 | 3397.0
sds235 | Piz_Chalchagn | 46.45065 | 9.9063160 | 3154.0
sds236 | Piz_Chatscheders | 46.47800 | 10.0165820 | 2986.0
sds237 | Piz_D_Agnel | 46.51131 | 9.7022600 | 3204.0
sds238 | Piz_Daint | 46.61884 | 10.2908270 | 2968.0
sds239 | Piz_dal_Botsch | 46.68673 | 10.2481630 | 2852.0
sds240 | Piz_dal_Fuorn | 46.68036 | 10.2130000 | 2906.0
sds241 | Piz_dals_Lejs | 46.44801 | 10.0379040 | 3044.0
sds242 | Piz_Foraz | 46.69057 | 10.2767240 | 3092.0
sds243 | Piz_Forun | 46.65530 | 9.8649690 | 3052.0
sds244 | Piz_Julier | 46.49097 | 9.7599150 | 3380.0
sds245 | Piz_Kesch | 46.62119 | 9.8728030 | 3418.0
sds246 | Piz_la_Stretta | 46.47668 | 10.0447650 | 3104.0
sds247 | Piz_Lagalb | 46.43154 | 10.0235630 | 2959.0
sds248 | Piz_Lai_Blau | 46.59764 | 8.7651670 | 2961.0
sds249 | Piz_Languard | 46.48845 | 9.9564600 | 3262.0
sds250 | Piz_Laschadurella | 46.69253 | 10.1763210 | 3046.0
sds251 | Piz_Linard | 46.79897 | 10.0713880 | 3410.0
sds252 | Piz_Lischana | 46.76959 | 10.3448980 | 3105.0
sds253 | Piz_Mezdi | 46.46025 | 9.8537080 | 2992.0
sds254 | Piz_Minor | 46.45102 | 10.0283340 | 3049.0
sds255 | Piz_Mirutta | 46.88710 | 9.3212710 | 2680.0
sds256 | Piz_Nair | 46.66718 | 10.2720000 | 3010.0
sds257 | Piz_Nuna | 46.72341 | 10.1545000 | 3124.0
sds258 | Piz_Ot | 46.54321 | 9.8102340 | 3246.0
sds259 | Piz_Padella | 46.53257 | 9.8363960 | 2857.0
sds260 | Piz_Picougl_West | 46.52250 | 9.7025800 | 3316.0
sds261 | Piz_Plazr | 46.70851 | 10.3880750 | 3104.0
sds262 | Piz_PlazÃr | 46.70851 | 10.3880750 | 3104.0
sds263 | Piz_Plazr | 46.70851 | 10.3880750 | 3104.0
sds264 | Piz_Sesvenna | 46.70600 | 10.4029340 | 3204.0
sds265 | Piz_Signina | 46.71540 | 9.2838010 | 2848.0
sds266 | Piz_Surlej | 46.45322 | 9.8431200 | 3188.0
sds267 | Piz_Tasna | 46.85908 | 10.2523650 | 3179.0
sds268 | Piz_Tavrue | 46.67916 | 10.2960700 | 3168.0
sds269 | Piz_Tomuel | 46.62343 | 9.2285760 | 2946.0
sds270 | Piz_Trovat | 46.40574 | 9.9704710 | 3146.0
sds271 | Piz_Tschueffer_ca | 46.47223 | 10.0004920 | 2918.0
sds272 | Piz_Tschueffer_si | 46.47223 | 10.0004920 | 2914.0
sds273 | Piz_Tschueffer_si | 46.47223 | 10.0004920 | 2918.0
sds274 | Piz_Tuf | 46.63390 | 9.3285260 | 2834.0
sds275 | Piz_ueertsch | 46.59625 | 9.8368850 | 3267.0
sds276 | Piz_Vadret_da_Pruenas | 46.50892 | 9.9508550 | 3199.0
sds277 | Pizzo_del_Lago_Scuro | 46.46986 | 8.5756800 | 2648.0
sds278 | Pizzo_del_Sole | 46.52506 | 8.7679110 | 2773.0
sds279 | Pizzo_di_Gino | 46.12353 | 9.1446700 | 2245.0
sds280 | Pizzo_Quadro | 46.29825 | 8.4278220 | 2792.0
sds281 | Pointe de Boveire | 45.99452 | 7.2400300 | 3212.0
sds282 | Pointe du Parc | 45.99798 | 7.2322700 | 2989.0
sds283 | Pollvartind | 69.17017 | 19.9721365 | 1275.0
sds284 | Pra Pelat | 45.65875 | 7.5481860 | 2790.0
sds285 | Prestkonetinden | 67.93244 | 15.0430759 | 646.0
sds286 | Puig_de_Coma_Pedrosa | 42.59194 | 1.4441670 | 2946.0
sds287 | Pulpito | 46.42357 | 8.5474930 | 2616.0
sds288 | Punta Acuta | 42.63758 | -0.0623218 | 2242.0
sds289 | Punta Custodia | 42.65004 | 0.0326600 | 2519.0
sds290 | Punta de las Olas | 42.66227 | 0.0539400 | 3022.0
sds291 | Punta Tobacor | 42.65514 | -0.0130900 | 2779.0
sds292 | Punta_Nera | 45.58083 | 7.4631250 | 3064.0
sds293 | Raduener_Rothorn | 46.72424 | 9.9464130 | 3022.0
sds294 | Ragnaroek | 46.38368 | 11.5926700 | 2757.0
sds295 | RAKKASVARE | 68.43136 | 18.5955400 | 492.0
sds296 | Ras_Rau | 61.39933 | 8.7210021 | 2105.0
sds297 | rasfjellet | 69.24124 | 20.7174135 | 1059.0
sds298 | Raslet | 61.38680 | 8.7398310 | 1854.0
sds299 | REBRA | 47.58555 | 24.6358200 | 2268.0
sds300 | Rihpogaisi | 69.19070 | 20.5868821 | 1195.0
sds301 | Ripeskardegg | 61.13145 | 7.9220857 | 1555.0
sds302 | Rocciamelone | 45.12125 | 7.0438100 | 3538.0
sds303 | Rocciamelone | 45.20346 | 7.0772380 | 3538.0
sds304 | Rosa_dei_Banchi | 45.34376 | 7.3155400 | 3164.0
sds305 | Rosa_dei_Banchi | 45.57738 | 7.5325040 | 3164.0
sds306 | Rossbodenstock | 46.63539 | 8.6512990 | 2836.0
sds307 | Rostafjell | 69.04332 | 19.6169538 | 1590.0
sds308 | Rostafjellet | 69.04834 | 19.6407583 | 1590.0
sds309 | Rundkollen | 68.76790 | 18.0829942 | 951.0
sds310 | Rysy | 49.17944 | 20.0880560 | 2503.0
sds311 | Rysy2 | 49.17944 | 20.0880560 | 2503.0
sds312 | Sr_Saulo | 66.89005 | 16.1493070 | 1715.0
sds313 | Salvaguardia | 42.69466 | 0.2780720 | 2728.0
sds314 | Sandhubel | 46.74014 | 9.6844460 | 2764.0
sds315 | Sarregaisi | 69.11918 | 19.6308915 | 1442.0
sds316 | Sass_Queder | 46.41071 | 9.9726150 | 3066.0
sds317 | Sassal_Masone | 46.38990 | 10.0137610 | 3032.0
sds318 | Sassalb | 46.33386 | 10.0988100 | 2862.0
sds319 | Scalettahorn | 46.69347 | 9.9423930 | 3068.0
sds320 | Schafberg | 46.74023 | 11.1097800 | 2619.0
sds321 | Schafberg | 47.00287 | 9.8154490 | 2456.0
sds322 | Schafgrind | 46.78448 | 9.7513030 | 2636.0
sds323 | SchaflAger | 46.82494 | 9.8070070 | 2681.0
sds324 | Schiahorn | 46.81817 | 9.8040750 | 2709.0
sds325 | Schollberg | 46.97498 | 9.8645050 | 2574.0
sds326 | Scopi | 46.57171 | 8.8299040 | 3190.0
sds327 | Scrigno_di_Poltrinone | 46.15007 | 9.1011740 | 1956.0
sds328 | Sedielkov  kopa | 49.14972 | 20.0205600 | 2061.3
sds329 | Sentischhorn | 46.76619 | 9.9153720 | 2827.0
sds330 | Sgoran Dubh Mor | 57.07972 | -3.8094440 | 1111.0
sds331 | Sikkilsdalshoa | 61.50465 | 8.9643029 | 1778.0
sds332 | Skauthoi | 61.62562 | 8.4454756 | 1993.0
sds333 | Sl vkovskì ?t¡t2 | 49.16611 | 20.1847220 | 2452.0
sds334 | Slavkovsk? ?tt | 49.16611 | 20.1847220 | 2452.0
sds335 | Slavkovskì ?t¡t | 49.16611 | 20.1847220 | 2452.0
sds336 | Slettningseggi | 61.23179 | 8.1095383 | 1524.0
sds337 | Solitinden | 69.14965 | 18.7284066 | 689.0
sds338 | Spiter | 61.61482 | 8.4400121 | 2033.0
sds339 | Stakken | 68.81588 | 17.2798845 | 817.0
sds340 | Stavel_da_Radnt | 46.73542 | 9.9736900 | 2640.0
sds341 | Steindalsnosi | 61.52067 | 7.8758645 | 1936.0
sds342 | Stockkogel | 46.89611 | 11.0000000 | 3109.0
sds343 | Storala | 68.90862 | 18.3303244 | 1237.0
sds344 | Store_Graddis | 66.77933 | 15.7811820 | 1153.0
sds345 | Storeknippa | 61.10286 | 8.2525325 | 1649.0
sds346 | Storkinn | 62.34667 | 9.4406900 | 1845.0
sds347 | Strel | 46.75130 | 9.7151950 | 2674.0
sds348 | Strela | 46.80931 | 9.7831590 | 2636.0
sds349 | Suletinden | 61.12270 | 8.1266980 | 1791.0
sds350 | Sulzfluh | 47.01262 | 9.8396370 | 2817.0
sds351 | Sur_Rau | 61.53356 | 8.5580711 | 2368.0
sds352 | Surtningstinden | 61.53000 | 8.1764031 | 1997.0
sds353 | Svartdalspiggan | 61.42207 | 8.5090540 | 2137.0
sds354 | Szeroka Jaworzy?ska | 49.20889 | 20.1363890 | 2210.0
sds355 | TAlihorn_Avers | 46.47840 | 9.5614340 | 3164.0
sds356 | TAllihorn_Davos | 46.74018 | 9.8664340 | 2684.0
sds357 | TAllihorn_Safien | 46.64665 | 9.2384000 | 2856.0
sds358 | Tamokfjell | 69.10004 | 19.7717197 | 1342.0
sds359 | Tarfalatjakko_South | 67.92596 | 18.6338350 | 1806.0
sds360 | Tjknris | 66.44978 | 16.0941650 | 1200.0
sds361 | Tjamuhas_high | 68.25279 | 18.7156320 | 1743.0
sds362 | Tjamuhas_low | 68.25669 | 18.7006120 | 1688.0
sds363 | Tjernhu | 61.43061 | 8.6569948 | 2145.0
sds364 | Tjidtjak | 66.61658 | 16.5498710 | 1586.0
sds365 | Tjknris | 66.44978 | 16.0941650 | 1200.0
sds366 | Tjornholstinden | 61.44407 | 8.6568469 | 2330.0
sds367 | Torten | 69.39415 | 17.0357437 | 570.0
sds368 | Totalp_Schwarzhorn | 46.84296 | 9.8111450 | 2670.0
sds369 | Tristelhorn | 46.90192 | 9.3164990 | 3114.0
sds370 | Tromsdalstinden | 69.60705 | 19.1463287 | 1238.0
sds371 | Tschima_da_Flix | 46.52160 | 9.6997310 | 3301.0
sds372 | Tverbotnhorn | 61.56464 | 8.2696106 | 2084.0
sds373 | Tverraatindan | 61.61796 | 8.3381269 | 2302.0
sds374 | Unknown Hillock | 57.07944 | -3.8300000 | 978.0
sds375 | Unnamed | 61.18767 | 7.9285736 | 1653.0
sds376 | Valbellahorn | 46.73985 | 9.7018050 | 2764.0
sds377 | Valser_Horn | 46.56039 | 9.2083050 | 2886.0
sds378 | Varful_Bucura | 45.36583 | 21.8616670 | 2433.0
sds379 | Varful_Custura | 45.34944 | 22.9294440 | 2457.0
sds380 | Varful_Parang_Mare | 45.34111 | 23.5405560 | 2519.0
sds381 | Varful_Peleaga | 45.36610 | 22.8944000 | 2509.0
sds382 | Vassatjokka_high | 68.36868 | 18.3188370 | 1590.0
sds383 | Vassatjokka_low | 68.38478 | 18.2594530 | 1491.0
sds384 | Velk  kopa | 49.20056 | 19.9736100 | 2052.0
sds385 | Vesle Armodshokollen | 62.26210 | 9.6658200 | 1161.0
sds386 | Veslekolla | 62.30665 | 9.4573000 | 1418.0
sds387 | Veslfjellet | 61.50712 | 8.7538582 | 1743.0
sds388 | Vestre istinden | 68.98977 | 20.0141757 | 1397.0
sds389 | Vesuv | 78.07000 | 14.8300000 | 739.0
sds390 | Vorderer_Eggstock | 46.96046 | 8.9800710 | 2449.0
sds391 | Weihbrunnkogel | 47.62474 | 15.1628500 | 2065.0
sds392 | Weissfluh | 46.83777 | 9.7930410 | 2843.0
sds393 | Weissfluhjoch_Institutsgipfel | 46.83338 | 9.8064350 | 2693.0
sds394 | Wilde_Kreuzspitze | 46.91250 | 11.5933330 | 3135.0
sds395 | Witihuereli | 46.75212 | 9.8674820 | 2635.0
sds396 | Wuosthorn | 46.73456 | 9.8779090 | 2815.0
sds397 | Zagelkogel-NW-summit | 47.61076 | 15.1233200 | 2255.0
sds398 | Zinken-NW-summit | 47.59826 | 15.0915200 | 1910.0
sds399 | Zuetribistock | 46.85194 | 8.9440400 | 2645.0

**note:** As you can see some sites have been replicated because of name encoding..


generated via: "check_downscaled_mean_temperature.R"
author: "damien georges"
date: "Tue Nov 10 15:52:21 2015"

