##' ----------------------------------------------------------------------------
##' @title Check downscaled data reliability
##' @date 04/11/2015
##' @author damien g.
##' @project SUMMITS
##' @description Here we will perform some checking on the downscaled data
##'   to try to chack that everithing is ok
##' @note 
##'   our summit data cover the 1802 - 20014 period => we will not consider 
##'   dates older than 1802 in this analyse
##' @licence GPL 2.
##' ----------------------------------------------------------------------------

setwd("J:/People/Damien/SUMMITS/WORKDIR")
rm(list = ls())

##' load libraries -------------------------------------------------------------
##+ , echo = FALSE
library(raster)
library(rgdal)
library(dplyr)
library(tidyr)

##' ## basics checkings
##' Downscaled data are stored within [summits_downsc_temp.csv]() file.

# tmp.dwsc <- read.csv("../OUTPUTS/summits_downsc_temp.csv")
tmp.dwsc <- read.csv("J:/People/Damien/SUMMITS/OUTPUTS/summits_downsc_temp.csv")
head(tmp.dwsc)

##' In this file we have:
##' 
##' | var name   | var type    | var description   |
##' |---|---|---|
##' | mountain_id  | character  | a unique id identifying the summit (unique combinasion of summit name, coordinates and altitude)  |
##' | mountain_name  | character   | summit name as given in the formal dataset   |
##' | ycoord  | numeric  |  the raw latitude of the summit (wgs84) |
##' | xcoord  | numeric  |  the raw longitude of the summit (wgs84) |
##' | mtn_altitude  | numeric  |  the raw elevation of the summit |
##' | clim_source  | character   |  the data climatic value values are based on (i.e. cru, cas or xop) |
##' | year  | numeric  |  the year oconsidered |
##' | period  | numeric  |  the period considered (i.e. 1-12: month (Jan-Dec), 13: winter, 14: spring, 15: summer, 16 fall) |
##' | mean_tmp_dwsc  | numeric   |  the 30s resolution downscaled temperature |

##' ### Time scale according to climatic data source
tmp.dwsc %>% group_by(clim_source) %>% summarise(fy = min(year), ly = max(year), ny = length(unique(year)))
tmp.dwsc %>% group_by(clim_source) %>% summarise(fp = min(period), lp = max(period), np = length(unique(period)))

##' ### Number of summit considered according to climatic data source
tmp.dwsc %>% group_by(clim_source) %>% summarise(nmnt = length(unique(mountain_id)))
tmp.dwsc %>% group_by(clim_source) %>% summarise(nNA = sum(is.na(mean_tmp_dwsc)), pcNA = sum(is.na(mean_tmp_dwsc)) / length(mean_tmp_dwsc))

##' note: some high latitude doesn't have data for Xoplakis (reduced extent)
na_sites <- function(dd){
  NA_sites = unique(dd$mountain_name[is.na(dd$mean_tmp_dwsc)])
  if(!length(NA_sites)) NA_sites <- NA
  data.frame(clim_source = unique(dd$clim_source), NA_sites = NA_sites)
} 
tmp.dwsc %>% group_by(clim_source) %>% do(na_sites(dd = .))

##' ## some graphical checkings

##+ , echo = FALSE  
library(ggplot2)

##' ### mean summer temperature accros our summits
##+ , fig.width = 12, fig.height = 40 
tmp.dwsc.win <- tmp.dwsc %>% filter(period == 13) %>% arrange(mountain_name)
gg <- ggplot(data = tmp.dwsc.win, mapping = aes(x = year, y = mean_tmp_dwsc, colour = clim_source)) +
  geom_line() + facet_wrap(~mountain_id, ncol = 10) + 
  theme(axis.text.x = element_text(angle=90))
gg
