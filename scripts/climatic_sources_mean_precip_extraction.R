##' ----------------------------------------------------------------------------
##' @title Mean precipitation extraction procedure
##' @date 10/12/2015
##' @author damien g.
##' @project SUMMITS
##' @description Here we will downscale cru mean precipitation
##' @note 
##'   our summit data cover the 1802 - 20014 period => we will not consider 
##'   dates older than 1802 in this analyse
##' @licence GPL 2.
##' ----------------------------------------------------------------------------

# setwd("J:/People/Damien/SUMMITS/WORKDIR")
setwd("~/SUMMITS/WORKDIR/")
rm(list = ls())

## load libraries --------------------------------------------------------------
library(raster)
library(rgdal)
library(dplyr)
library(tidyr)
library(ggplot2)

## laod the reference table ----------------------------------------------------
dat.ref <- read.csv("../DATA/summits/summits_coordinates_all_and_cells.csv",
                    stringsAsFactors = FALSE)
head(dat.ref)

## add the wc ref cell id
dat.ref <- dat.ref %>% group_by(wc_cells) %>% mutate(wc_ref_id = first(unique_id))
## add the casty ref cell id
dat.ref <- dat.ref %>% group_by(casty_cells) %>% mutate(casty_ref_id = first(unique_id))
## add the cru ref cell id
dat.ref <- dat.ref %>% group_by(cru_cells) %>% mutate(cru_ref_id = first(unique_id))
## add the xoplakis ref cell id
dat.ref <- dat.ref %>% group_by(xoplakis_cells) %>% mutate(xoplakis_ref_id = first(unique_id))

## load all climatic data we want to downscale ---------------------------------
cru.dat <- stack("../DATA/climate/cru/cru_ts4.00.1901.2015.pre.dat.nc/cru_ts4.00.1901.2015.pre.dat.nc")
names(cru.dat) <- sub(".[[:digit:]]+$", "", names(cru.dat))

cas.files <- list.files("../DATA/climate/casty/indiv_raster_prec", "*.grd$", full.names = TRUE)
cas.dat <- stack(cas.files)
names(cas.dat) <- sub(".grd$", "", basename(cas.files))

## extract the summits climatic data from rasters ------------------------------
cru.extr <- raster::extract(cru.dat, as.data.frame(dat.ref[, c("xcoord", "ycoord")]),
                            method='simple', df = TRUE)
cas.extr <- raster::extract(cas.dat, as.data.frame(dat.ref[, c("xcoord", "ycoord")]),
                            method='simple', df = TRUE)

## reshape extractions ---------------------------------------------------------
cru.extr.resh <- cru.extr %>% select(-ID) %>% bind_cols(dat.ref[, c("unique_id", "cru_ref_id")]) %>%
  mutate(clim_source = "cru", clim_source_ref_id = cru_ref_id) %>%
  select(-cru_ref_id) %>%
  gather(key = date_str, value = mean_pre, -c(unique_id, clim_source, clim_source_ref_id)) %>%
  mutate(year = as.numeric(sub("^X", "", sub(".[[:digit:]]{2}$", "", date_str))),
         period = as.numeric(sub("^X[[:digit:]]{4}.", "", date_str))) %>% 
  select(unique_id, clim_source, clim_source_ref_id, year, period, mean_pre)

cas.extr.resh <- cas.extr %>% dplyr::select(-ID) %>% bind_cols(dat.ref[, c("unique_id", "casty_ref_id")]) %>%
  mutate(clim_source = "cas", clim_source_ref_id = casty_ref_id) %>%
  dplyr::select(-casty_ref_id) %>%
  gather(key = date_str, value = mean_pre, -c(unique_id, clim_source, clim_source_ref_id)) %>%
  mutate(year = as.numeric(sub("cas_", "", sub("([[:digit:]]{2})$", "", date_str))),
         period = as.numeric(sub("cas_[[:digit:]]{4}", "", date_str))) %>% 
  dplyr::select(unique_id, clim_source, clim_source_ref_id, year, period, mean_pre)

## save a copy of workspace
save.image("workspace_backup.RData")
load("workspace_backup.RData")

## add the seasonal mean precipitation for casty and cru dataset -----------------

## TEST
# dsc <- cas.extr.resh %>% 
#   filter(is.element(unique_id, "sds1")) %>% 
#   group_by(unique_id, clim_source, clim_source_ref_id)

calc_season_mean <- function(dsc){
  years_ <- sort(unique(dsc$year))
  out.tab <- dsc %>% select(unique_id, clim_source, clim_source_ref_id, year) %>% as.data.frame %>% distinct
  out.tab$winter_mean_pre <- out.tab$spring_mean_pre <- out.tab$summer_mean_pre <- out.tab$fall_mean_pre <- NA
  for(y_ in years_){
    out.tab$winter_mean_pre[out.tab$year == y_] <- mean(c(dsc$mean_pre[dsc$year == (y_ - 1) & dsc$period == 12],
                                                          dsc$mean_pre[dsc$year == y_ & is.element(dsc$period, 1:2)]))
    out.tab$spring_mean_pre[out.tab$year == y_] <- mean(dsc$mean_pre[dsc$year == y_ & is.element(dsc$period, 3:5)])
    out.tab$summer_mean_pre[out.tab$year == y_] <- mean(dsc$mean_pre[dsc$year == y_ & is.element(dsc$period, 6:8)])
    out.tab$fall_mean_pre[out.tab$year == y_] <- mean(dsc$mean_pre[dsc$year == y_ & is.element(dsc$period, 9:11)])
  }
  out.tab <- out.tab %>% gather(key = "period_str", value = "mean_pre", c(winter_mean_pre, spring_mean_pre, summer_mean_pre, fall_mean_pre)) %>%
    mutate(period = ifelse(period_str == "winter_mean_pre", 13, ifelse(period_str == "spring_mean_pre", 14, ifelse(period_str == "summer_mean_pre", 15, 16)))) %>%
    select(unique_id, clim_source, clim_source_ref_id, year, period, mean_pre)
  return(out.tab)
}

cru.extr.resh.season <- cru.extr.resh %>%
  group_by(unique_id, clim_source, clim_source_ref_id) %>%
  do(calc_season_mean(dsc = .))

cas.extr.resh.season <- cas.extr.resh %>%
  group_by(unique_id, clim_source, clim_source_ref_id) %>%
  do(calc_season_mean(dsc = .))

## merge all the climatic extractions ------------------------------------------
clim.exrt <- bind_rows(cru.extr.resh, cru.extr.resh.season, cas.extr.resh, cas.extr.resh.season)

## write the climatic extractions on the harddrive -----------------------------
write.csv(clim.exrt, file = "../OUTPUTS/summits_raw_prec.csv", quote = FALSE, row.names = FALSE)

## end of script ---------------------------------------------------------------

  