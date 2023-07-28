#' @author Jack MacCormick (JMXZ78)

# supporting libraries
library(dplyr)
library(tidyr)
library(stringr)
library(tidyverse)
library(NZPoliceUtilities)

# paths
pathIn <- "YOUR PATH HERE"

#####################################################################
#' Turning 1:N data across multiple rows into one row per primary key
#####################################################################

# data load
networkData <- read.csv("SOME CSV FILE")
# cut down cols
a <- networkData[, c("UNIQUE_KEY", "COUNTED_OBJECT", "OTHER_VARS")]


# duplicate source data - for validation
b <- a
# merge cols so they can be "unpivot-ed"
b$UNIQUE_KEY <- str_c(b$UNIQUE_KEY, "-", b$OTHER_VARS)
# cut down the cols to only 2 cols, the thing that has multiple instances per keyvar, and keyvar
b <- b[,c(1,2)]

# group and then compress to one row item per pax
# essentially an "unpivot"
c <- b %>% 
  group_by(UNIQUE_KEY) %>% 
  summarise(COUNTED_OBJECT = paste(COUNTED_OBJECT, collapse = ":"))
# resplit keyvar col into two cols
c <- tidyr::separate(data = c, col = UNIQUE_KEY, into = c("UNIQUE_KEY", "OTHER_VARS"), sep = "-")

