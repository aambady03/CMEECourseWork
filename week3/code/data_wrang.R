##Author: Anaga Ambady (aa6725@ic.ac.uk)
##Version: 1.0.0
##Date: Oct 2025
##Description: Exploring a dataset through data wrangling
################################################################
################## Wrangling the Pound Hill Dataset ############
################################################################

############# Load the dataset ###############
# header = false because the raw data don't have real headers
library(dplyr)
library(tidyverse)

MyData <- as.matrix(read.csv("../data/PoundHillData.csv", header = FALSE))

# header = true because we do have metadata headers
MyMetaData <- read.csv("../data/PoundHillMetaData.csv", header = TRUE, sep = ";")

############# Inspect the dataset ###############
head(MyData)
dim(MyData)
str(MyData)
fix(MyData) #you can also do this
fix(MyMetaData)

############# Transpose ###############
# To get those species into columns and treatments into rows 
MyData <- t(MyData) 
head(MyData)
dim(MyData)

############# Replace species absences with zeros ###############
MyData[MyData == ""] = 0

############# Convert raw matrix to data frame ###############

TempData <- as.data.frame(MyData[-1,],stringsAsFactors = F) #stringsAsFactors = F is important!
colnames(TempData) <- MyData[1,] # assign column names from original data

############# Convert from wide to long format  ###############
require(reshape2) # load the reshape2 package

?melt #check out the melt function

MyWrangledData <- melt(TempData, id=c("Cultivation", "Block", "Plot", "Quadrat"), variable.name = "Species", value.name = "Count")

MyWrangledData[, "Cultivation"] <- as.factor(MyWrangledData[, "Cultivation"])
MyWrangledData[, "Block"] <- as.factor(MyWrangledData[, "Block"])
MyWrangledData[, "Plot"] <- as.factor(MyWrangledData[, "Plot"])
MyWrangledData[, "Quadrat"] <- as.factor(MyWrangledData[, "Quadrat"])
MyWrangledData[, "Count"] <- as.integer(MyWrangledData[, "Count"])

str(MyWrangledData)
head(MyWrangledData)
dim(MyWrangledData)

############# Exploring the data (extend the script below)  ###############

MyWrangledData <- dplyr::as_tibble(MyWrangledData) 
MyWrangledData

MyWrangledData <- as_tibble(MyWrangledData) 
glimpse(MyWrangledData) #like str(), but nicer!
#utils::View(MyWrangledData) #same as fix()

filter(MyWrangledData, Count>100) 

slice(MyWrangledData, 10:15)

MyWrangledData %>%
    group_by(Species) %>%
        summarise(avg = mean(Count))

aggregate(MyWrangledData$Count, list(MyWrangledData$Species), FUN=mean) 
