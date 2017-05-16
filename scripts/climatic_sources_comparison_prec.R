##' ----------------------------------------------------------------------------
##' @title Compare the different climatic data available
##' @date 29/10/2015
##' @author damien g.
##' @project SUMMITS
##' @description Here we will compare the following data source:
##'     - worldclim
##'     - cru TS 3.23
##'   Comparisons will be conduc t considering our summits location and comparable
##'   area and time periods
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

## dataset loading -------------------------------------------------------------

## worldclim
##' @note worldlim: mean monthly temperature over 1950-2000 period (30s)
wc.dat <- stack(paste0("../DATA/climate/worldclim/wc2.0_30s_prec/wc2.0_30s_prec_", sprintf("%02d", 1:12) , ".tif"))

## cru
##' @note cru: mean monthly temperature for each year from 1901 to 2015 (0.5 deg)
cru.dat <- stack("../DATA/climate/cru/cru_ts4.00.1901.2015.pre.dat.nc/cru_ts4.00.1901.2015.pre.dat.nc")
names(cru.dat) <- sub(".[[:digit:]]+$", "", names(cru.dat))

## casty
##' @note casty: monthly mean temperature for each year from 1765 to 2000 (0.5 deg)

# ## produce individual rasters
# cas.tab <- readLines("../DATA/climate/casty/precip-mon.txt", skipNul = TRUE)
# cas.tab <- cas.tab[-c(1:14)]
# cas.tab <- cas.tab[nchar(cas.tab) > 0]
# cas.tab.header <- strsplit(cas.tab[1], "\t")
# cas.tab.dat <- strsplit(cas.tab[-1], "[[:space:]]+")
# cas.tab.dat <- lapply(cas.tab.dat, as.numeric)
# cas.tab <- do.call(rbind, cas.tab.dat)
# rownames(cas.tab) <- cas.tab[, 1]
# cas.tab <- cas.tab[, -1]
# 
# cas.grd <- raster("../DATA/climate/casty/casty_tmp_grid.grd")
# ## create raster files of all casty files of interest
# cas.out.dir <- "../DATA/climate/casty/indiv_raster_prec"
# dir.create(cas.out.dir, showWarnings = FALSE, recursive = TRUE)
# year.to.consider <- 1766:2000
# month.to.consider <- sprintf("%02d", 1:12)
# row.to.consider <- apply(expand.grid(year.to.consider, month.to.consider), 1, paste0, collapse = "")
# row.to.consider <- as.character(sort(row.to.consider))
# ll <- lapply(row.to.consider[-length(row.to.consider)], function(x){
#   cat("\n>", x)
#   writeRaster(setValues(cas.grd, as.numeric(cas.tab[x, ])),
#               filename = file.path(cas.out.dir, paste0("cas_", x, ".grd")),
#               overwrite = TRUE)
# })
# cas.dat <- stack(file.path(cas.out.dir, paste0("cas_", row.to.consider[-length(row.to.consider)], ".grd")))
# names(cas.dat) <- paste0("cas_", row.to.consider[-length(row.to.consider)])
# rm(cas.tab, cas.grd)

cas.files <- list.files("../DATA/climate/casty/indiv_raster_prec", "*.grd$", full.names = TRUE)
cas.dat <- stack(cas.files)
names(cas.dat) <- sub(".grd$", "", basename(cas.files))


## read summit data locations --------------------------------------------------
s.dat.all.cells <- read.csv("../DATA/summits/summits_coordinates_all_and_cells.csv",
                      stringsAsFactors = FALSE) 
f.year <- min(s.dat.all.cells$first_year_of_record, na.rm = TRUE)
l.year <- max(s.dat.all.cells$last_year_of_record, na.rm = TRUE)

## laod polygons associated to locations ---------------------------------------
wc.poly.list <- get(load("../WORKDIR/wc.poly.RData"))
cru.poly.list <- get(load("../WORKDIR/cru.poly.RData"))
cas.poly.list <- get(load("../WORKDIR/casty.poly.RData"))


## build the comparison table skeletom -----------------------------------------
s1 <- s2 <- c("wc", "cru", "cas")
## sources info
comp.tab <- expand.grid(s1 = s1, s2 = s2, stringsAsFactors = FALSE)
comp.tab <- comp.tab[comp.tab$s1 != comp.tab$s2, ]
## identificate unique cells
unique.wc.id <- s.dat.all.cells$unique_id[which(!duplicated(s.dat.all.cells$wc_cells))]
unique.cru.id <- s.dat.all.cells$unique_id[which(!duplicated(s.dat.all.cells$cru_cells))]
unique.cas.id <- s.dat.all.cells$unique_id[which(!duplicated(s.dat.all.cells$casty_cells))]
## time comp info
comp.tab.time.fct <- function(s1, s2){
  cat("\ns1 =", s1, ", s2 =", s2)
  out.tab.yr <- out.tab.mth <- NULL
  ## determine year intersections
  if(is.element("wc", c(s1, s2))){
    out.tab.yr$fy <- 1970
    out.tab.yr$ly <- 2000
  } else if(is.element("cru", c(s1, s2))){
    out.tab.yr$fy <- 1901:ifelse(is.element("xop", c(s1, s2)), 2002, 2000)
    out.tab.yr$ly <- out.tab.yr$fy
  } else {
    out.tab.yr$fy <- out.tab.yr$ly <- 1766:2000
  }
  out.tab.yr <- as.data.frame(out.tab.yr)
  ## determine month interesections
  out.tab.mth$fm <- c(-1, 3, 6, 9)
  out.tab.mth$lm <- c(2, 5, 8, 11)
  if(!is.element("xop", c(s1, s2))) {
    out.tab.mth$fm <- c(out.tab.mth$fm, 1:12)
    out.tab.mth$lm <- c(out.tab.mth$lm, 1:12)
  }
  out.tab.mth <- as.data.frame(out.tab.mth)
  ## merge the year and month intersections
  out.tab.time.merge.id <- expand.grid(id1 = 1:nrow(out.tab.yr),
                                       id2 = 1:nrow(out.tab.mth))
  out.tab.time <- bind_cols(out.tab.yr[out.tab.time.merge.id$id1, ],
                            out.tab.mth[out.tab.time.merge.id$id2, ])
  ## add source information
  out.tab.time$s1 <- s1
  out.tab.time$s2 <- s2
  ## add cell ref name info
  if(s1 == "wc"){
    cell.ref.names <- unique.wc.id
  } else if(s1 == "cru"){
    cell.ref.names <- unique.cru.id
  } else if(s1 == "cas"){
    cell.ref.names <- unique.cas.id
  } else if(s1 == "xop"){
    cell.ref.names <- unique.xop.id
  }
  out.tab.time.merge.id <- expand.grid(id1 = 1:length(cell.ref.names),
                                       id2 = 1:nrow(out.tab.time))
  
  out.tab.time <- bind_cols(data.frame(s1Cell = cell.ref.names[out.tab.time.merge.id$id1]),
                            out.tab.time[out.tab.time.merge.id$id2, ])
  
  return(out.tab.time)
}

comp.tab <- comp.tab %>% rowwise %>% 
  do(comp.tab.time.fct(s1 = .$s1, s2 = .$s2)) %>%
  as.data.frame

## define a function that return the names of layers to extract from stacks
get.layer.to.extr.name <- function(s, fy, ly, fm, lm){
  if(s == "wc"){
    if(fm == -1 & lm == 2){ ## winter
      str.out <- paste0("wc2.0_30s_prec_", c(12, 1, 2))
    } else {
      str.out <- paste0("wc2.0_30s_prec_", fm:lm)
    }
  }
  else if(s == "cru"){
    if(fm == -1 & lm == 2){ ## winter
      str.out <- sapply(fy:ly, function(yr_){
        c(paste0("X", yr_ - 1, ".12"), paste0("X", yr_, ".", sprintf("%02d", 1:2)))
        }) 
    } else {
      str.out <- sapply(fy:ly, function(yr_){
        paste0("X", yr_, ".", sprintf("%02d", fm:lm))
      })
    }
  }
  else if(s == "xop"){
    str.out <- paste0("xop_", fy:ly, ifelse(fm == -1, "13", ifelse(fm == 3, "14", ifelse(fm == 6, "15", 16))))
  }
  else if(s == "cas"){
    if(fm == -1 & lm == 2){ ## winter
      str.out <- sapply(fy:ly, function(yr_){
        c(paste0("cas_", yr_ - 1, "12"), paste0("cas_", yr_, sprintf("%02d", 1:2)))
      }) 
    } else {
      str.out <- sapply(fy:ly, function(yr_){
        paste0("cas_", yr_, sprintf("%02d", fm:lm))
      })
    }
  }
  return(as.character(str.out))
}

## prepare the new columns in our output data.frame
comp.tab$s1.ncell <- comp.tab$s2.ncell <- comp.tab$s1.mean <-comp.tab$s2.mean <- 
  comp.tab$s1.sd <- comp.tab$s2.sd <- comp.tab$delta <- NA

## parallel version
# library(foreach)
# library(doParallel)
# cl <- makeCluster(4)
# registerDoParallel(cl)
library(doSNOW)
cl <- makeCluster(8)
registerDoSNOW(cl)
iterations <- nrow(comp.tab)
pb <- txtProgressBar(max = iterations, style = 3)
progress <- function(n) setTxtProgressBar(pb, n)
opts <- list(progress = progress)

s.name <- c("cru", "wc", "cas")
to.export <- c(paste0(s.name, ".dat"), paste0(s.name, ".poly.list"))
comb.tab.out <- foreach(k = 1:iterations, .packages = c('raster'), .export = to.export, .options.snow = opts) %dopar% {
  s1 <- comp.tab[k, "s1"]
  s2 <- comp.tab[k, "s2"]
  s1Cell <- comp.tab[k, "s1Cell"]
  s1.dat <- get(paste0(s1, ".dat"))
  s2.dat <- get(paste0(s2, ".dat"))
  s1.poly <- get(paste0(s1, ".poly.list"))[[s1Cell]]
  s1.subset.str <- get.layer.to.extr.name(s = s1, 
                                          fy = comp.tab[k, "fy"], 
                                          ly = comp.tab[k, "ly"],
                                          fm = comp.tab[k, "fm"],
                                          lm = comp.tab[k, "lm"])
  s2.subset.str <- get.layer.to.extr.name(s = s2, 
                                          fy = comp.tab[k, "fy"], 
                                          ly = comp.tab[k, "ly"],
                                          fm = comp.tab[k, "fm"],
                                          lm = comp.tab[k, "lm"])
  s1.extr <- try(raster::extract(raster::subset(s1.dat, s1.subset.str), s1.poly, df = TRUE))
  s2.extr <- try(raster::extract(raster::subset(s2.dat, s2.subset.str), s1.poly, df = TRUE))
  if(inherits(s1.extr, "try-error")) s1.extr <- data.frame()
  if(inherits(s2.extr, "try-error")) s2.extr <- data.frame()
  s1.ncell <- nrow(na.omit(s1.extr))
  s2.ncell <- nrow(na.omit(s2.extr))
  s1.extr.mean <- rowMeans(s1.extr[, -1, drop = FALSE])
  s2.extr.mean <- rowMeans(s2.extr[, -1, drop = FALSE])
  if(s1 == "wc") s1.extr.mean <- s1.extr.mean 
  if(s2 == "wc") s2.extr.mean <- s2.extr.mean 
  s1.extr.sd <- sd(s1.extr.mean, na.rm = TRUE)
  s2.extr.sd <- sd(s2.extr.mean, na.rm = TRUE)
  s1.extr.full.mean <- mean(s1.extr.mean, na.rm = TRUE)
  s2.extr.full.mean <- mean(s2.extr.mean, na.rm = TRUE)
  ## put the results in our output.table
  comp.tab[k, "s1.ncell"] <- s1.ncell
  comp.tab[k, "s2.ncell"] <- s2.ncell
  comp.tab[k, "s1.mean"] <- s1.extr.full.mean
  comp.tab[k, "s2.mean"] <- s2.extr.full.mean
  comp.tab[k, "s1.sd"] <- s1.extr.sd
  comp.tab[k, "s2.sd"] <- s2.extr.sd
  comp.tab[k, "delta"] <- s1.extr.full.mean - s2.extr.full.mean
  return(comp.tab[k, ,drop = FALSE])
}

## save the output
save(comb.tab.out, file = "comb.tab.out.prec.RData")
comb.tab.out.df <- bind_rows(comb.tab.out)
write.csv(comb.tab.out.df, file = "comb.tab.out.prec.csv", row.names = FALSE)

## end of script