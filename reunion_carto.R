##############################################################################/
##############################################################################/
#Basic code for plotting map of la Réunion
##############################################################################/
##############################################################################/

#loading the packages necessary for the analysis
library(rgdal)
library(rgeos)
library(maptools)
library(plotrix)
library(classInt)
library(sf)


##############################################################################/
#loading the data and producing lighter dataset and .RData files####
##############################################################################/

#the geographical layer used here were downloaded on the french public dataset 
#http://peigeo.re/index.php/catalogue/

#the agricultural use shapefile
ReuAgri<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/Reunion/bos2013_daaf",
               layer="bos2013_daafPolygon")
ReuAgri<-st_as_sf(ReuAgri)
ReuAgri<-st_union(ReuAgri)
temp<-st_simplify(ReuAgri,preserveTopology=FALSE,dTolerance=200)
save(ReuAgri,file="output/ReuAgri.RData")
plot(ReuAgri,col="yellowgreen",border="yellowgreen")


#the urban use shapefile
ReuUrb<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/Reunion/DenseEtaleDisperse2017",
                 layer="DenseEtaleDisperse2017Polygon")
ReuUrb<-st_as_sf(ReuUrb)
ReuUrb<-st_union(ReuUrb)
plot(ReuUrb,col="red",border="red",add=TRUE)
save(ReuUrb,file="output/ReuUrb.RData")




##############################################################################/
#END
##############################################################################/