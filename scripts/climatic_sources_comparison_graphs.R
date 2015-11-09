##' ----------------------------------------------------------------------------
##' @title Plot the different climatic data available
##' @date 04/11/2015
##' @author damien g.
##' @project SUMMITS
##' @description Here we will compare the following data source:
##'     - worldclim
##'     - cru TS 3.23
##'     - casty 2007
##'     - Xoplakis 
##'   Comparisons will be conduc t considering our summits location and comparable
##'   area and time periods
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

## load the comparaison dataset ------------------------------------------------
dat <- read.csv("comb.tab.out.csv", stringsAsFactors = FALSE)

## define couple of plots ------------------------------------------------------

## define an empty plot
##  => this is jus a trick to fill some cells with an empty graph on wich we will be able
##    to add some text.
empty <- ggplot() + 
  geom_point(aes(1, 1), colour = "white") + 
  xlim(0,100) + ylim(0,100) +
  theme(plot.background = element_blank(), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.border = element_blank(), panel.background = element_blank(), axis.title.x = element_blank(), 
        axis.title.y = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), 
        axis.ticks = element_blank(), legend.position="none")

## delta temp with worldclim
gg_wc <- dat %>% select(s1, s2, fy, ly, fm, lm, delta) %>%
  filter(s2 == "wc") %>% 
  ggplot(aes(x = s1, y = delta)) + geom_boxplot() 
gg_wc

## delta temp with xoplakis
gg_xop <- dat %>% select(s1, s2, fy, ly, fm, lm, delta) %>%
  filter(s2 == "xop", s1 != "wc", fy == ly) %>% na.omit %>%
  ggplot(aes(x = as.factor(fy), y = delta, colour = as.factor(fm))) + 
  geom_boxplot() +
gg_xop
