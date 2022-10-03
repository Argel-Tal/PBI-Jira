## Author ::  Jack MacCormick (JMXZ78)

# supporting libraries
library(tidyverse)
library(data.table)
library(tidygraph)
library(igraph)
library(statnet)
library(network)
library(scales)
library(dbscan)
library(NZPoliceUtilities)



# data load
rawRowData <- SomeData[, c(1, 2)]



ObjectfreqTable <- as.matrix(table(rawRowData$VertexObject, rawRowData$Primary_Key))
# take the product of the frequency table - makes adjacency matrix
# one df keeps freq count of solo Object occurance (diagonals) - not true Adj matrix
Object_adjacencyMatDiag <- ObjectfreqTable %*% t(ObjectfreqTable)
Object_adjacencyMat     <- ObjectfreqTable %*% t(ObjectfreqTable)
# set diagonals to 0
diag(Object_adjacencyMat) <- 0


## classes to highlight
interestCategories <- c("Category1", "Category2")
interestObjectsInCat <- rawRowData[which(rawRowData$CategoryClass %in% interestCategories), 2]


# sense checks
# no. instances of Obj1 and Obj2 sharing Primary_Key
cat("\n", "Obj1 : Obj2 =", 
    length(intersect(rawRowData[which(rawRowData$VertexObject == "Obj1"), 1],
                     rawRowData[which(rawRowData$VertexObject == "Obj2"), 1]
    ) # end intersect()
    ) # end length()
) # end cat



#############
# NETWORK OBJ
#############
networkObj1 <- as.network(x           = Object_adjacencyMat, # the network object
                          directed    = FALSE,               # specify whether the network is directed
                          loops       = FALSE,               # do we allow self ties (should not allow them)
                          matrix.type = "adjacency"          # the type of input
                          ) # end as.network()

# weightings for line width
edge_values <- Object_adjacencyMat
set.edge.value(networkObj1,"Weight",edge_values)

# get network summary
summary.network(networkObj1,print.adj = FALSE)



#############
## IGRAPH OBJ
#############
networkObj1DF  <- network::as.data.frame.network(networkObj1)
netIG          <- graph_from_data_frame(networkObj1DF, directed = F) 
V(netIG)$color <- ifelse(V(netIG)$name %in% interestObjectsInCat, "red", "orange")



############
# PLOTTING #
#############

setwd(PATH_plots)

# annotated plot
png("TOPIC Network Plot.png", # name of plot file (need to include extension)
    width  = 3500, # width of resulting pdf in inches
    height = 2000 # height of resulting pdf in inches
) # end set up
plot.network(networkObj1, 
             labels        = networkObj1$val,
             vertex.col    = "purple", # just one color
             displaylabels = T,        # no node names
             label.pos     = 5,
             edge.lwd      = log(get.edge.value(networkObj1,"Weight")) # edge width
) # end plot
dev.off() # finishes plotting and finalizes plot object creation


## END FILE ##