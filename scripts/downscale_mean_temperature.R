##' ----------------------------------------------------------------------------
##' @title Mean temperature downscaling procedure
##' @date 04/11/2015
##' @author damien g.
##' @project SUMMITS
##' @description Here we will downscale casty, cru and xoplakis mean temperature 
##'   data
##' @note 
##'   our summit data cover the 1802 - 20014 period => we will not consider 
##'   dates older than 1802 in this analyse
##' @licence GPL 2.
##' ----------------------------------------------------------------------------

setwd("J:/People/Damien/SUMMITS/WORKDIR")
rm(list = ls())

## load libraries --------------------------------------------------------------
library(raster)
library(rgdal)
library(dplyr)
library(tidyr)
library(ggplot2)

## laod the climatic data comparaison table ------------------------------------
dat.comp <- read.csv("comb.tab.out.csv", stringsAsFactors = FALSE)

dat.comp %>% filter(s1 == "cas", s2 == "wc") %>% group_by(fy, ly) %>%
  summarise(nfm = length(unique(fm)), nlm = length(unique(lm)))

## load the raw climatic extractions -------------------------------------------
dat.extr <- read.csv("../OUTPUTS/summits_raw_temp.csv", stringsAsFactors = FALSE)

## load the points locations ---------------------------------------------------
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

## check that sites matched
sites.in.dat <- dat.comp %>% filter(s1 == "cas", s2 == "wc") %>% select(s1Cell) %>% distinct
sites.in.dat.ref <- unique(dat.ref$casty_ref_id)
all(as.character(sites.in.dat$s1Cell) == sites.in.dat.ref)

##' add the wc delta alti info in ref data -------------------------------------
dat.ref <- dat.ref %>% mutate(delta_wc_alti = (mtn_altitude - wc_alt) * (- 0.5 / 100))

##' main downscale procedure ---------------------------------------------------

## add period column to dat table (1-12: month, 13: winter, 14: spring, 15: summer, 16: fall)
dat.comp <- dat.comp %>% mutate(period = ifelse(fm == lm, fm, ifelse(fm == -1, 13, ifelse(fm == 3, 14, ifelse(fm == 6, 15, 16)))))

## extract the delta wc table
delta.wc.dat <- dat.comp %>% select(s1Cell, s1, s2, period, delta) %>% filter(s1 == 'wc') %>%
  left_join(distinct(dat.ref[, c("unique_id", "wc_ref_id", "delta_wc_alti")]), by = c("s1Cell" = "wc_ref_id")) %>%
  mutate(delta_corrected = delta + delta_wc_alti) %>%
  mutate(clim_source = s2) %>% 
  select(unique_id, clim_source, period, delta_corrected)

## add the delta_corrected value to our extractions
tmp.dwsc <- dat.extr %>% left_join(delta.wc.dat)

## downscale the data
tmp.dwsc <- tmp.dwsc %>% 
  mutate(mean_tmp_dwsc = mean_tmp + delta_corrected)

## clean the output table
tmp.dwsc <- tmp.dwsc %>% 
  mutate(mountain_id = unique_id) %>%
  select(mountain_id, clim_source, year, period, mean_tmp_dwsc) %>%
  left_join(dat.ref %>% select(mountain_name, ycoord, xcoord, mtn_altitude, unique_id), by = c("mountain_id" = "unique_id")) %>%
  arrange(mountain_id, clim_source, year, period) %>% as.data.frame %>%
  select(mountain_id, mountain_name, ycoord, xcoord, mtn_altitude, clim_source, year, period, mean_tmp_dwsc)

## write the output table on the hard drive
dir.create("../OUTPUTS", showWarnings = FALSE, recursive = TRUE)
write.csv(tmp.dwsc, file = "../OUTPUTS/summits_downsc_temp.csv", quote = FALSE, row.names = FALSE)
