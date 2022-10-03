# Author  ::  Jack MacCormick

library(stringr)
library(plyr)

#################################
# REPLACE THIS WITH SOMETHING:
#   YOUR_FUNCTION_HERE
# number of columns in dataset
#   nCols
# Column names
#   colList
################################

# number of columns for the dataset on export
nCols <- 3
colList <- c("Hi", "Hello", "Howdy")


#' defines batch indices
#' @param : NULL
#' @return  : 2D array of batch indices; [start index : end index]
#' Methodology
#'   Creates empty dataframe for indices, length is divisor + plus one (slot for remainders)
#'   First row is between first element and divisor
#' From there, we loop up in jumps of [divisor], until we hit the maximum multiple before [file count]
#'   If there are no more items (no remainder), then the excess row is removed
#'   Else if there are remainders, those excess are added into the remainder index row
MakeBatchIndices <- function(){
  # set up array for batch indices to go into, with slot for remainder indices
  BatchIndexes <- data.frame(matrix(NA, nrow = divisor + 1, ncol = 2))
  ## determine indexes
  # first set of indicies
  BatchIndexes[1, 1] <- 1
  BatchIndexes[1, 2] <- nfiles %/% divisor
  # rest of the indicies
  for (i in c(2:divisor)){ # take slices [1 :  1st whole multiple], [1 + 1st whole multiple : 2nd whole multiple] ...
    BatchIndexes[i, 1] <- ((i - 1) * (nfiles %/% divisor)) + 1
    BatchIndexes[i, 2] <- i * (nfiles %/% divisor)
  } # end for
  if (BatchIndexes[i, 2] == nfiles) { # if there is a remainder, fill the last slot with values between last whole multiple index and final element
    BatchIndexes <- BatchIndexes[-(divisor + 1), ] # remove placeholder slot for remainder indices  
  } else {
    BatchIndexes[divisor + 1, 1] <- BatchIndexes[divisor, 2] + 1
    BatchIndexes[divisor + 1, 2] <- nfiles
  } # end else
  return(BatchIndexes)
} # end MakeBatchIndices()


#' open files from batches
#' @param file_vector_in   : vector of names of all files in dir of interest
#' @param BatchIndexes_in  : start:end indicies for all batches
#' @param pathBatches : file path to read batched files from, and to write output to
#' @return : array of all files, processed
#' Methodology
#'  Defines empty array
#'   for the number of batches needed, iterate through each batch
#'     make an empty dataset for each batch
#'     make dataframe from the result of applying the file-reading function to each file in a batch
#'     save batch's dataframe in-case of process failure/dropout
#'  Export the whole array
BatchWriterLApply <- function(file_vector_in, BatchIndexes_in, pathBatches){
  nBatches <- dim(MakeBatchIndices())[1]
  j = 1 # batch index var
  for (j in c(1:nBatches)){
    midput <- as.data.frame(matrix(ncol = nCols, nrow = BatchIndexes_in[j, 2] - BatchIndexes_in[j, 1]))
    toRead <- (file_vector_in[BatchIndexes_in[j, 1]:BatchIndexes_in[j, 2]])
    # begin reading of files in that batch
    for (fileX in seq(1, length(toRead))){
      ################################
      ## INSERT YOUR FUNCTION BELOW ##
      ################################
      midput[fileX, ] <- YOUR_FUNCTION_HERE(toRead[fileX])
    } # end for
    colnames(midput) <- colList
    midput[is.na(midput)] <- ""
    
    # iterative save so if it dies it's partially there, with batch no. so you know when it died
    write.csv(midput, stringr::str_c(pathBatches, "/", j, ".csv"), row.names = FALSE)
    cat("\n", j, "of", nBatches) # progress "bar"
  } # end outer for
  # return main array
  # return(output)
} # end function
