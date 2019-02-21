##' ---
##' title: SuMMITS downscaled data presentation
##' date: 04/11/2015
##' author: damien g. (damien.georges2 at gmail.com)
##' output:
##'   html_document:
##'     keep_md: true
##' ---
  
  

##' ## What is this document for?
##' This document aims to present the downsclaled version of past temperature
##' for mountains of the **SUMMITS** project. For each location **30s resolution**
##' version of past monthly/seasonal mean  temperature have been produced based on 
##' **cru_ts 4.02**, **casty 2007**, **Xoplaki 2005** downscaled according to the 
##' latest version of **worldclim** data. 
##' 

##' ## where are the downscaled data?
##' Data are currently stored on the Ecoinformatics network drive at the locataion :
##' 
##' [I:/C_Write/Damien/SUMMITS/OUTPUTS/summits_downsc_temp.csv](I:/C_Write/Damien/SUMMITS/OUTPUTS/summits_downsc_temp.csv)
##' 

##' ## What data has been used?
##' The aim of this procedure is to produce 30s resolution monthly/seasonal mean 
##' temperature from 1800 to nowadays.
##' 
##' ### Past temperatures
##' The past mean temperature are originaly at 0.5deg resolution.
##' We considered 3 different past temperature datasets:
##' 
##'  - **cru**: monthly mean temperature from 1900 to 2014 based on CRU_TS 4.02  
##'     *download link*: [http://www.cru.uea.ac.uk/cru/data/hrg/cru_ts_4.02/](http://www.cru.uea.ac.uk/cru/data/hrg/cru_ts_3.23/)  
##'     *ref*: Harris, I., Jones, P.D., Osborn, T.J. and Lister, D.H. (2014), Updated
##'     high-resolution grids of monthly climatic observations the CRU TS3.10
##'     Dataset. Int. J. Climatol., 34: 623642. doi: 10.1002/joc.3711  
##'     *extra info*: refer to [Release_Notes_CRU_TS3.23_rev231015.txt](http://www.cru.uea.ac.uk/cru/data/hrg/cru_ts_3.23/Release_Notes_CRU_TS3.23_rev231015.txt)  
##'     
##'  - **cas**: monthly mean temperature from 1500 to 2000  
##'     *download link*: [http://www1.ncdc.noaa.gov/pub/data/paleo/historical/europe/casty2007/](http://www1.ncdc.noaa.gov/pub/data/paleo/historical/europe/casty2007/)
##'     *ref*: Casty, C., et al.  2008. European Gridded Monthly Temperature, Precipitation and 500hPa Reconstructions. 
##'     IGBP PAGES/World Data Center for Paleoclimatology Data Contribution Series # 2008-023. 
##'     NOAA/NCDC Paleoclimatology Program, Boulder CO, USA.  
##'     *extra info*: refer to [readme-casty2007.txt](http://www1.ncdc.noaa.gov/pub/data/paleo/historical/europe/casty2007/readme-casty2007.txt)  
##'  
##'  - **xop**: seasonal mean temperature from 1500 to 2002  
##'     *download link*: [http://www1.ncdc.noaa.gov/pub/data/paleo/historical/europe-seasonal-files/](http://www1.ncdc.noaa.gov/pub/data/paleo/historical/europe-seasonal-files/)  
##'     *ref*: Luterbacher, J., Dietrich, D., Xoplaki, E., Grosjean, M., and Wanner, H., 2004:
##'     European seasonal and annual temperature variability, trends, and extremes since 1500,
##'     Science 303, 1499-1503 (DOI:10.1126/science.1093877).  
##'     Xoplaki, E., Luterbacher, J., Paeth, H., Dietrich, D., Steiner N., Grosjean, M., and Wanner, H., 2005:
##'     European spring and autumn temperature variability and change of extremes over the last half millennium,
##'     Geophys. Res. Lett., 32, L15713 (DOI:10.1029/2005GL023424)  
##'     *extra info*: refer to [Readme_TT_1500_2002.txt](http://www1.ncdc.noaa.gov/pub/data/paleo/historical/europe-seasonal-files/Readme_TT_1500_2002.txt)  
##' 
##' ### Higher resolution data  
##' To downscale the past climatic data from 0.5deg resolution to 30s resolution
##' we used the **worldclim monthly mean temperature**.  
##' *download link*: [http://www.worldclim.org/current](http://www.worldclim.org/current)  
##' *ref*: Hijmans, R.J., S.E. Cameron, J.L. Parra, P.G. Jones and A. Jarvis, 2005. 
##' Very high resolution interpolated climate surfaces for global land areas. 
##' International Journal of Climatology 25: 1965-1978.  
##' *extra info*: [http://www.worldclim.org/methods](http://www.worldclim.org/methods)
##' 
##' 
##' **note**: we also used the **worldclim elevation** data to correct predicted 
##'  predicted temperature according to the differences between worlclim elevation
##'  and summits observed elevatrion (we use a **-0.6deg / 100m** correction factor)
##'  

##' ## Downscale procedure
##' Here is a schematic representation of the downscale procedure:  
##'
##' ![downscaling procedure scheme](../images/downscaling_procedure.png)
##'   
##' The main downscaling procedure should be summarised in 3 main steps:
##' 
##'   1. Calculating the **&Delta; temp due to climatic source**: anomalies between worldclim and one of the past cliamtic dataset (PCD)
##'     + we extract the mean monthly temperature from WorldClim layer for one summit location
##'     + we extract the mean temperature from PCD for the matching period (same month(s) from 1950 to 2000) and compute the average value
##'     + we deduce the anomaly associated to the PCD for this summit
##'     
##'   2. Calculating the **&Delta; temp due to elevation correction**: correction of temperature 
##'   according to altitudinal difference between woldclim elevation layer and the observed elevation of our summit
##'   
##'   3. Calculate the **downscaled past temperature** of our summit: we simply add the two &Delta; to the raw past temperature extraction
##'   
##'   

##' ## Source code
##' If you want to see exactly how the downscale procedure have been proceed, you
##' should refer to the source code available here :  
##' [https://github.com/DamienGeorges/summitshub/tree/master/scripts](https://github.com/DamienGeorges/summitshub/tree/master/scripts)  
##' Scripts workflow is the following (some scripts needs outputs of others to be run):  
##'   1. [cell_extraction_and_polygons.R](https://github.com/DamienGeorges/summitshub/tree/master/scripts/cell_extraction_and_polygons.R)  
##'   2. [climatic_sources_comparison.R](https://github.com/DamienGeorges/summitshub/tree/master/scripts/climatic_sources_comparison.R)  
##'   3. [climatic_sources_mean_tmp_extraction.R](https://github.com/DamienGeorges/summitshub/tree/master/scripts/climatic_sources_mean_tmp_extraction.R)  
##'   4. [downscale_mean_temperature.R](https://github.com/DamienGeorges/summitshub/tree/master/scripts/downscale_mean_temperature.R)  
##' 
##' Optionaly:
##'  - [climatic_sources_comparison_graphs.R](https://github.com/DamienGeorges/summitshub/tree/master/scripts/climatic_sources_comparison_graphs.R)  
##'  - [check_downscaled_mean_temperature.R](https://github.com/DamienGeorges/summitshub/tree/master/scripts/check_downscaled_mean_temperature.R) (to produce this document)
##'  


##' ## Donwscaled data exploration
# setwd("/mnt/data/georgesd/_PROJECTS/SUMMITS/WORKDIR/")
rm(list = ls())

##' ### load libraries 
##+ , message = FALSE, warning = FALSE
library(dplyr)
library(tidyr)
library(ggplot2)

##' ### basics checkings
##' Downscaled data are stored within [summits_downsc_temp.csv]() file.

# tmp.dwsc <- read.csv("../OUTPUTS/summits_downsc_temp.csv")
tmp.dwsc <- read.csv("/mnt/data/georgesd/_PROJECTS/SUMMITS/OUTPUTS/summits_downsc_temp.csv")
head(tmp.dwsc)

##' In this file we have:  
##' 
##' | var name  |  var type | var description  |
##' |---|---|---|
##' | **mountain_id** | *character* | a unique id identifying the summit (unique combinasion of summit name, coordinates and altitude)  |
##' | **mountain_name** | *character* | summit name as given in the formal dataset  |
##' | **ycoord**  | *numeric* | the raw latitude of the summit (wgs84) |
##' | **xcoord**  | *numeric* | the raw longitude of the summit (wgs84)  |
##' | **mtn_altitude**  | *numeric* | the raw elevation of the summit  |
##' | **clim_source** | *character* | the data climatic value values are based on (i.e. cru, cas or xop)  |
##' | **year**  | *numeric* | the year oconsidered |
##' | **period**  | *numeric* | the period considered (i.e. 1-12: month (Jan-Dec), 13: winter, 14: spring, 15: summer, 16 fall)  |
##' | **mean_tmp_dwsc** | *numeric* | the 30s resolution downscaled temperature |
##' |   |   |   |
##' 


##' ### Time scale according to climatic data source
tmp.dwsc %>% group_by(clim_source) %>% summarise(first_year = min(year), last_year = max(year), n_year = length(unique(year)))
tmp.dwsc %>% group_by(clim_source) %>% summarise(first_period = min(period), last_period = max(period), n_period = length(unique(period)))

##' ### Number of summit considered according to climatic data source
tmp.dwsc %>% group_by(clim_source) %>% summarise(n_mnt = length(unique(mountain_id)))
tmp.dwsc %>% group_by(clim_source) %>% summarise(n_NA = sum(is.na(mean_tmp_dwsc)), pc_NA = sum(is.na(mean_tmp_dwsc)) / length(mean_tmp_dwsc))

##' **note:** some high latitude doesn't have data for Xoplakis (reduced extent)
na_sites <- function(dd){
  NA_sites = unique(dd$mountain_name[is.na(dd$mean_tmp_dwsc)])
  if(!length(NA_sites)) NA_sites <- NA
  data.frame(clim_source = unique(dd$clim_source), NA_sites = NA_sites)
} 
tmp.dwsc %>% group_by(clim_source) %>% do(na_sites(dd = .))

##' ### some graphical reperesentations

##' #### mean summer temperature accros our summits
##+ , fig.width = 12, fig.height = 40 
tmp.dwsc.win <- tmp.dwsc %>% filter(period == 13) %>% arrange(mountain_id)
tmp.dwsc.win$mountain_id <- factor(tmp.dwsc.win$mountain_id, levels = gtools::mixedsort(unique(tmp.dwsc.win$mountain_id)))
gg <- ggplot(data = tmp.dwsc.win, mapping = aes(x = year, y = mean_tmp_dwsc, colour = clim_source)) +
  geom_line(alpha = .3) + facet_wrap(~mountain_id, ncol = 10) + 
  theme(axis.text.x = element_text(angle=90))
gg

##' #### correspondance between summits id and summits names
mont_ids <- tmp.dwsc %>% select(mountain_id, mountain_name, ycoord, xcoord, mtn_altitude) %>% 
   as.data.frame %>% distinct %>% arrange(mountain_name)

##+ , results='asis'
knitr::kable(mont_ids)

##' **note:** Some sites might have been replicated because of name encoding..
