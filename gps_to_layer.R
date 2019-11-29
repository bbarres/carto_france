##############################################################################/
##############################################################################/
#code for identifying an administrative layer based on GPS coordinates
##############################################################################/
##############################################################################/

#loading the packages necessary for the analysis
library(rgdal)
library(rgeos)
library(plotrix)
library(classInt)
library(magrittr)
library(ggplot2)
library(sf)


##############################################################################/
#loading the data and producing lighter dataset and .RData files####
##############################################################################/

#the geographical layer used here were downloaded on the french public dataset 
#https://www.data.gouv.fr/fr/datasets/admin-express/ (which used to be Geofla, 
#from IGN which is the French Institut of Geographic and forest information)

#département are an intermediate administrative division
departe<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/ADE_1-1_SHP_LAMB93_FR",
                 layer="DEPARTEMENT")
save(departe,file="output/departe.RData")
departeLight<-gSimplify(departe,1000,topologyPreserve=TRUE)
save(departeLight,file="output/departeLight.RData")
load("output/departeLight.RData")
plot(departeLight)

departe.wgs <- spTransform(departe,
                              CRS("+proj=longlat +datum=WGS84"))
plot(departe.wgs)

#régions are the largest administrative division in France
regions<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/ADE_1-1_SHP_LAMB93_FR",
                 layer="REGION")
save(regions,file="output/regions.RData")
regionsLight<-gSimplify(regions,1000,topologyPreserve=TRUE)
save(regionsLight,file="output/regionsLight.RData")
load("output/regionsLight.RData")
plot(regionsLight)

#loading the data points
ambro18<-read.table(file="data/ambroisie_result2018.txt",header=TRUE,sep="\t")


##############################################################################/
#production of coordinates table for regions and departement####
##############################################################################/

ambro18_sf<-st_as_sf(ambro18,coords=c("Longitude","Latitude"), crs=4326)
plot(departe.wgs)
plot(ambro18_sf[,-c(1,2)],add=TRUE,pch=19,cex=0.7)

temp<-st_as_sf(departe.wgs)
int<-st_intersects(ambro18_sf,temp)


##############################################################################/
#END
##############################################################################/