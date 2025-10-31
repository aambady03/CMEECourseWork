rm(list=ls()) #clear workspace

load("../data/KeyWestAnnualMeanTemperature.RData") #load data

ls() #check for file

class(ats) #check for class

head(ats) #load first few lines of data




plot(ats) #load scatter plot


cor(KeyWestAnnualMeanTemperature$Year,KeyWestAnnualMeanTemperature$Temp, use ="pairwise")