#' @author Jack MacCormick  ::  JMXZ78
#' This file reads in all .csv files from a folder, and puts them into one big dataframe

library(tidyverse)
library(plyr)
library(lubridate)
# library(stringr)

####################################
# REPLACE THIS WITH YOUR PATH OBJECT
A_PATH_OBJECT <- getwd()
# Set this to the number of columns
nCols <- 5
####################################

# Get all the files in the working directory/path
allPathFiles <- list.files()
# Get only the .csv's
allPathFiles_CSV <- allPathFiles[which(str_detect(allPathFiles,"csv"))]

## Removing encoding inconsistency character
# found this "ï.."
# fix is standardising text format: https://stackoverflow.com/questions/24568056/rs-read-csv-prepending-1st-column-name-with-junk-text


output <- ldply(allPathFiles_CSV, .fun = function(x){
  as.data.frame(read.csv(str_c(A_PATH_OBJECT, "/", x), fileEncoding="UTF-8-BOM", colClasses=c(rep("character", nCols))), 
                header = TRUE
                ) # end as.data.frame
  } # end ldply function def
) # end file read 

