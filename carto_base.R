###############################################################################
###############################################################################
#Basic code for plotting map of France
###############################################################################
###############################################################################

#loading the packages necessary for the analysis
library(rgdal)
library(plotrix)
library(classInt)

#Setting the right working directory
setwd("~/work/Rfichiers/Githuber/carto_france")


###############################################################################
#loading the data
###############################################################################

#the geographical layer used here were downloaded on the IGN website (Geofla), 
#which is the French Institut of Geographic and forest information

communes<-readOGR(dsn="C:/Users/Benoit/Documents/Work/Rfichiers/Githuber/geo_data/COMMUNE",layer="COMMUNE")
plot(communes,border="grey70",lwd=0.1)








