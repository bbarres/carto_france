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

#the urban use shapefile
ReuUrb<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/Reunion/DenseEtaleDisperse2017",
                layer="DenseEtaleDisperse2017Polygon")
ReuUrb<-st_as_sf(ReuUrb)
ReuUrb<-st_simplify(ReuUrb,preserveTopology=FALSE,dTolerance=15)
ReuUrb<-st_buffer(ReuUrb,dist=30,joinStyle="MITRE")
ReuUrb<-st_union(ReuUrb)
save(ReuUrb,file="output/ReuUrb.RData")
plot(ReuUrb,col="red",border="red")

#the agricultural use shapefile
ReuAgri<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/Reunion/bos2013_daaf",
                 layer="bos2013_daafPolygon")
ReuAgri<-st_as_sf(ReuAgri)
ReuAgri<-st_simplify(ReuAgri,preserveTopology=FALSE,dTolerance=15)
ReuAgri<-st_buffer(ReuAgri,dist=30,joinStyle="MITRE")
ReuAgri<-st_union(ReuAgri)
save(ReuAgri,file="output/ReuAgri.RData")
plot(ReuAgri,col="yellowgreen",border="yellowgreen",add=TRUE)

#the vegetation coverage shapefile
ReuVeg<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/Reunion/vegetation_onf",
                layer="vegetation_onfPolygon")
ReuVeg<-st_as_sf(ReuVeg)
ReuVeg<-st_simplify(ReuVeg,preserveTopology=FALSE,dTolerance=10)
ReuVeg<-st_buffer(ReuVeg,dist=10,joinStyle="MITRE")
ReuVeg<-st_union(ReuVeg)
save(ReuVeg,file="output/ReuVeg.RData")
plot(ReuVeg,col="darkgreen",border="darkgreen",add=TRUE)


##############################################################################/
#END
##############################################################################/