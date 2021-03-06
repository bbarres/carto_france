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
library(RColorBrewer)
library(raster)
library(elevatr)
library(tanaka)


##############################################################################/
#loading the data and producing lighter dataset and .RData files####
##############################################################################/

#the geographical layer used here were downloaded on the french public dataset 
#https://www.data.gouv.fr/fr/datasets/admin-express/

#the Réunion Island shapefile
ReuDep<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/Reunion/ADE_1-1_SHP_RGR92UTM40S_D974",
                layer="DEPARTEMENT")
ReuDep<-st_as_sf(ReuDep)
st_crs(ReuDep)<-2975     #or EPSG:4971?
save(ReuDep,file="output/ReuDep.RData")

#the Réunion Island commune shapefile
ReuCom<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/Reunion/ADE_1-1_SHP_RGR92UTM40S_D974",
                layer="COMMUNE")
ReuCom<-st_as_sf(ReuCom)
st_crs(ReuCom)<-2975     #or EPSG:4971?
save(ReuCom,file="output/ReuCom.RData")

#the geographical layer used here were downloaded on the french public dataset 
#http://peigeo.re/index.php/catalogue/

#the urban use shapefile
ReuUrb<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/Reunion/DenseEtaleDisperse2017",
                layer="DenseEtaleDisperse2017Polygon")
ReuUrb<-st_as_sf(ReuUrb)
st_crs(ReuUrb)<-2975     #or EPSG:4971?
ReuUrb<-st_simplify(ReuUrb,preserveTopology=FALSE,dTolerance=10)
ReuUrb<-st_buffer(ReuUrb,dist=10,joinStyle="MITRE")
ReuUrb<-st_union(ReuUrb)
save(ReuUrb,file="output/ReuUrb.RData")
plot(ReuUrb,col="red",border="red")

#the vegetation coverage shapefile
ReuVeg<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/Reunion/vegetation_onf",
                layer="vegetation_onfPolygon")
ReuVeg<-st_as_sf(ReuVeg)
st_crs(ReuVeg)<-2975     #or EPSG:4971?
ReuVeg<-st_simplify(ReuVeg,preserveTopology=FALSE,dTolerance=10)
ReuVeg<-st_buffer(ReuVeg,dist=10,joinStyle="MITRE")
ReuVeg<-st_union(ReuVeg)
save(ReuVeg,file="output/ReuVeg.RData")
plot(ReuVeg,col="darkgreen",border="darkgreen",add=TRUE)

#the agricultural use shapefile
ReuAgri<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/Reunion/bos2013_daaf",
                 layer="bos2013_daafPolygon")
ReuAgri<-st_as_sf(ReuAgri)
st_crs(ReuAgri)<-2975     #or EPSG:4971?
ReuAgri<-st_simplify(ReuAgri,preserveTopology=TRUE,dTolerance=10)
ReuAgri<-st_buffer(ReuAgri,dist=10,joinStyle="MITRE")
ReuAgri<-st_union(ReuAgri)
save(ReuAgri,file="output/ReuAgri.RData")
plot(ReuAgri,col="yellowgreen",border="yellowgreen",add=TRUE)

#Altitude data, downloaded from http://dwtkns.com/srtm/
ReuAlt2<-raster(x="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/Reunion/srtm_48_17/srtm_48_17.tif")
newproj<-"+proj=utm +zone=40 +south +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
ReuAlt2<-projectRaster(ReuAlt2,crs=newproj)
plot(ReuAlt2,col=grey(100:30/100,alpha=0.2),axes=FALSE,legend=FALSE)

#use elevatr to get elevation data
ReuAlt<-get_elev_raster(
  locations=data.frame(
    x=c(308147.6,383403.0), y = c(7696781,7626847)
  ),
  z=10,prj = "+init=epsg:2975", 
  clip="locations")
save(ReuAlt,file="output/ReuAlt.RData")

#create the isopleth layer
ReuIso<-tanaka_contour(
  x=ras, 
  breaks=seq(150,3070,200),
  mask=ReuDep$geometry)
# display the isopleth layer
plot(st_geometry(iso))
save(ReuIso,file="output/ReuIso.RData")


##############################################################################/
#loading the data and producing lighter dataset and .RData files####
##############################################################################/

#example of map with isopleth
plot(ReuDep$geometry,col=brewer.pal(11,"Spectral")[6],lwd=3)
plot(ReuUrb,col=brewer.pal(9,"RdPu")[3],
     border=brewer.pal(9,"RdPu")[3],add=TRUE)
plot(ReuVeg,col=brewer.pal(9,"BuGn")[6],
     border=brewer.pal(9,"BuGn")[6],add=TRUE)
plot(ReuAgri,col=brewer.pal(8,"Accent")[1],
     border= brewer.pal(8,"Accent")[1],add=TRUE)
plot(st_geometry(ReuIso),col=grey(15:1/15,alpha=0.3),
     axes=FALSE,legend=FALSE,add=TRUE,lwd=1)
plot(ReuDep$geometry,col="transparent",lwd=4,add=TRUE)
#export to .pdf 20 x 18 inches

#another example of map with tanaka's effect
tanaka(x=ReuAlt,breaks=seq(150,3070,200),
       col=grey(15:1/15),
       legend.pos="n",
       mask=ReuDep$geometry)
plot(ReuDep$geometry,
     col=rgb(t(as.matrix(col2rgb(brewer.pal(11,"Spectral")[6]))),
             alpha=100,maxColorValue=255),
     lwd=3,add=TRUE)
plot(ReuUrb,
     col=rgb(t(as.matrix(col2rgb(brewer.pal(9,"RdPu")[3]))),
             alpha=100,maxColorValue=255),
     border=rgb(t(as.matrix(col2rgb(brewer.pal(9,"RdPu")[3]))),
                alpha=100,maxColorValue=255),
     add=TRUE)
plot(ReuVeg,
     col=rgb(t(as.matrix(col2rgb(brewer.pal(9,"BuGn")[6]))),
             alpha=100,maxColorValue=255),
     border=rgb(t(as.matrix(col2rgb(brewer.pal(9,"BuGn")[6]))),
                alpha=100,maxColorValue=255),
     add=TRUE)
plot(ReuAgri,
     col=rgb(t(as.matrix(col2rgb(brewer.pal(8,"Accent")[1]))),
             alpha=100,maxColorValue=255),
     border=rgb(t(as.matrix(col2rgb(brewer.pal(8,"Accent")[1]))),
                alpha=100,maxColorValue=255),
     add=TRUE)
plot(ReuDep$geometry,col="transparent",lwd=4,add=TRUE)


##############################################################################/
#END
##############################################################################/