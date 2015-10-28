##' ----------------------------------------------------------------------------
##' @title Extract cells and cells polygons for our summits
##' @date 28/10/2015
##' @author damien g.
##' @project SUMMITS
##' @description Here we will exract the grid cells associated polygons for all
##'   the SUMMIT project sites. We will do this operation for all the data sources
##'   we plan to use:
##'     - worldclim
##'     - cru TS 3.23
##'     - casty 2007
##'     - Xoplakis 
##' @licence GPL 2.
##' ----------------------------------------------------------------------------

setwd("J:/People/Damien/SUMMITS/WORKDIR")
rm(list = ls())

## load libraries --------------------------------------------------------------
library(raster)
library(rgdal)
library(dplyr)
library(tidyr)


## merge all summits location data ---------------------------------------------

##' @note cause several people are interested in the past downscalled data we 
##'   will apply the downscalling procedure to Signe (sUMMITDiv project), Manuel
##'   and Aino summits locations

s.dat.signe <- read.csv("../DATA/summits/summits_coordinates_signe.csv",
                        stringsAsFactors = FALSE, sep = ";", quote = '"',
                        dec = ",")
head(s.dat.signe)
s.dat.manuel <- read.csv("../DATA/summits/summits_coordinates_manuel.csv",
                         stringsAsFactors = FALSE, sep = ",", quote = '"', 
                         row.names = 1)
head(s.dat.manuel)
s.dat.aino <- read.csv("../DATA/summits/summits_coordinates_aino.csv",
                         stringsAsFactors = FALSE, sep = ",", quote = '')
head(s.dat.aino)

##' @note Signe's data didn't have the year of sampling info. Lets extract it 
##'   from the species linked dataset

spe.dat.signe <- read.csv("../DATA/summits/species_signe.csv",
                          stringsAsFactors = FALSE, sep = ";", quote = '"',
                          dec = ",")
head(spe.dat.signe)
## keep only needed info
s.dat.signe.year <- spe.dat.signe %>%
  select(mountain_name, year_of_record) %>%
  group_by(mountain_name) %>%
  summarise(first_year_of_record = min(year_of_record, na.rm = TRUE),
            last_year_of_record = max(year_of_record, na.rm = TRUE)) %>%
  ungroup
head(s.dat.signe.year) 
## merge this table with Signe original one
s.dat.signe <- s.dat.signe %>% 
  left_join(s.dat.signe.year) %>%
  select(mountain_name, first_year_of_record, last_year_of_record,
         ycoord, xcoord, mtn_altitude)

## rearrange Manuel and Aino datasets
s.dat.manuel <- s.dat.manuel %>%
  group_by(mountain_name, ycoord, xcoord, mtn_altitude) %>%
  summarise(first_year_of_record = min(year_of_record, na.rm = TRUE),
            last_year_of_record = max(year_of_record, na.rm = TRUE)) %>%
  ungroup %>%
  select(mountain_name, first_year_of_record, last_year_of_record,
         ycoord, xcoord, mtn_altitude)

s.dat.aino <- s.dat.aino %>%
  group_by(mountain_name, ycoord, xcoord, mtn_altitude) %>%
  summarise(first_year_of_record = min(year_of_record, na.rm = TRUE),
            last_year_of_record = max(year_of_record, na.rm = TRUE)) %>%
  ungroup %>%
  select(mountain_name, first_year_of_record, last_year_of_record,
         ycoord, xcoord, mtn_altitude)

## merge all datasets
s.dat.all <- s.dat.signe %>% bind_rows(s.dat.manuel) %>% bind_rows(s.dat.aino) %>%
  group_by(mountain_name, ycoord, xcoord, mtn_altitude) %>%
  summarise(first_year_of_record = min(first_year_of_record, na.rm = TRUE),
            last_year_of_record = max(last_year_of_record, na.rm = TRUE)) %>%
  ungroup %>% distinct %>% as.data.frame

head(s.dat.all)
dupl.sites <- unique(s.dat.all$mountain_name[duplicated(s.dat.all$mountain_name)])
s.dat.all[is.element(s.dat.all[, 'mountain_name'], dupl.sites), ] %>% arrange(mountain_name)
## 12 sites are duplicated (same name but diff in x, y or alti)

s.dat.all <- s.dat.all %>% arrange(mountain_name) %>% mutate(unique_id = paste0("sds", 1:nrow(s.dat.all)))


## save the merged summits table on hard drive 
write.csv(s.dat.all, file = "../DATA/summits/summits_coordinates_all.csv", row.names = FALSE)


## laod the merged version of summits locations --------------------------------
s.dat.all <- read.csv("../DATA/summits/summits_coordinates_all.csv",
                        stringsAsFactors = FALSE) 

## define a function to create pixels polygons ---------------------------------
xy.pix.to.poly <- function(xy, res, proj4string = CRS("NA")){
  lapply(1:nrow(xy), function(i){
    x_ <- xy[i, 1] + c(-res, res, res, -res, -res)
    y_ <- xy[i, 2] + c(res, res, -res, -res, res)
    xy_ <- data.frame(x = x_, y = y_)
    SpatialPolygons(list(Polygons(list(Polygon(xy_)), "poly")), proj4string = proj4string)
  })
}

## worldclim data --------------------------------------------------------------
wc.dat <- raster("../DATA/climate/worldclim/alt.bil")
wc.dat.cells <- raster::extract(wc.dat, s.dat.all[, c('xcoord', 'ycoord')], 
                       cellnumbers = TRUE, df = TRUE)
wc.dat.extr <- cbind(wc.dat.cells, xyFromCell(wc.dat, wc.dat.cells$cells))
wc.dat.extr <- wc.dat.extr %>% select(-1)
colnames(wc.dat.extr) <- paste0("wc_", colnames(wc.dat.extr))
## extract wc polygons
wc.poly <- xy.pix.to.poly(xy = wc.dat.extr[, c("wc_x", "wc_y")], 
                          res = res(wc.dat)[1],
                          proj4string = CRS(projection(wc.dat)))
names(wc.poly) <- s.dat.all$unique_id
save(wc.poly, file = "wc.poly.RData")

## cru data --------------------------------------------------------------------
cru.dat <- raster("../DATA/climate/cru/cru_ts3.23.1901.2014.tmp.dat.nc")
cru.dat.cells <- raster::extract(cru.dat, s.dat.all[, c('xcoord', 'ycoord')], 
                                cellnumbers = TRUE, df = TRUE)
cru.dat.extr <- cbind(cru.dat.cells, xyFromCell(cru.dat, cru.dat.cells$cells))
cru.dat.extr <- cru.dat.extr %>% select(-1)
colnames(cru.dat.extr) <- paste0("cru_", colnames(cru.dat.extr))
## extract cru polygons
cru.poly <- xy.pix.to.poly(xy = cru.dat.extr[, c("cru_x", "cru_y")], 
                          res = res(cru.dat)[1],
                          proj4string = CRS(projection(cru.dat)))
names(cru.poly) <- s.dat.all$unique_id
save(cru.poly, file = "cru.poly.RData")

## casty data ------------------------------------------------------------------
casty.dat <- raster(xmn = -50, xmx = 40, ymn = 30, ymx = 80, res = 0.5,
                    crs = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"),
                    vals = 0)
## save this reference grid on the hard drive
writeRaster(casty.dat, filename = "../DATA/climate/casty/casty_tmp_grid.grd",
            overwrite = TRUE)
casty.dat.cells <- raster::extract(casty.dat, s.dat.all[, c('xcoord', 'ycoord')], 
                                 cellnumbers = TRUE, df = TRUE)
casty.dat.extr <- cbind(casty.dat.cells, xyFromCell(casty.dat, casty.dat.cells$cells))
casty.dat.extr <- casty.dat.extr %>% select(-1)
colnames(casty.dat.extr) <- paste0("casty_", colnames(casty.dat.extr))
## extract casty polygons
casty.poly <- xy.pix.to.poly(xy = casty.dat.extr[, c("casty_x", "casty_y")], 
                           res = res(casty.dat)[1],
                           proj4string = CRS(projection(casty.dat)))
names(casty.poly) <- s.dat.all$unique_id
save(casty.poly, file = "casty.poly.RData")

## xoplakis data ------------------------------------------------------------------
xoplakis.dat <- raster(xmn = -25, xmx = 40, ymn = 30, ymx = 70, res = 0.5,
                    crs = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"),
                    vals = 0)
## save this reference grid on the hard drive
writeRaster(xoplakis.dat, filename = "../DATA/climate/xoplakis/xoplakis_tmp_grid.grd",
            overwrite = TRUE)
xoplakis.dat.cells <- raster::extract(xoplakis.dat, s.dat.all[, c('xcoord', 'ycoord')], 
                                   cellnumbers = TRUE, df = TRUE)
xoplakis.dat.extr <- cbind(xoplakis.dat.cells, xyFromCell(xoplakis.dat, xoplakis.dat.cells$cells))
xoplakis.dat.extr <- xoplakis.dat.extr %>% select(-1)
colnames(xoplakis.dat.extr) <- paste0("xoplakis_", colnames(xoplakis.dat.extr))
## extract xoplakis polygons
xoplakis.poly <- xy.pix.to.poly(xy = xoplakis.dat.extr[, c("xoplakis_x", "xoplakis_y")], 
                             res = res(xoplakis.dat)[1],
                             proj4string = CRS(projection(xoplakis.dat)))
names(xoplakis.poly) <- s.dat.all$unique_id
save(xoplakis.poly, file = "xoplakis.poly.RData")

## merge all cell references in our data.set -----------------------------------
s.dat.all.cells <- cbind(s.dat.all, wc.dat.extr, cru.dat.extr[, -2], 
                         casty.dat.extr[, -2], xoplakis.dat.extr[, -2])
## save this table (will be use as reference!!)
write.csv(s.dat.all.cells, file = "../DATA/summits/summits_coordinates_all_and_cells.csv",
          row.names = FALSE)
