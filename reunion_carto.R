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


##############################################################################/
#loading the data and producing lighter dataset and .RData files####
##############################################################################/

#the geographical layer used here were downloaded on the french public dataset 
#https://www.data.gouv.fr/fr/datasets/admin-express/

#the Réunion Island shapefile
ReuDep<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/Reunion/ADE_1-1_SHP_RGR92UTM40S_D974",
                layer="DEPARTEMENT")
ReuDep<-st_as_sf(ReuDep)
save(ReuDep,file="output/ReuDep.RData")

#the Réunion Island commune shapefile
ReuCom<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/Reunion/ADE_1-1_SHP_RGR92UTM40S_D974",
                layer="COMMUNE")
ReuCom<-st_as_sf(ReuCom)
save(ReuCom,file="output/ReuCom.RData")

#the geographical layer used here were downloaded on the french public dataset 
#http://peigeo.re/index.php/catalogue/

#the urban use shapefile
ReuUrb<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/Reunion/DenseEtaleDisperse2017",
                layer="DenseEtaleDisperse2017Polygon")
ReuUrb<-st_as_sf(ReuUrb)
ReuUrb<-st_simplify(ReuUrb,preserveTopology=FALSE,dTolerance=10)
ReuUrb<-st_buffer(ReuUrb,dist=10,joinStyle="MITRE")
ReuUrb<-st_union(ReuUrb)
save(ReuUrb,file="output/ReuUrb.RData")
plot(ReuUrb,col="red",border="red")

#the vegetation coverage shapefile
ReuVeg<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/Reunion/vegetation_onf",
                layer="vegetation_onfPolygon")
ReuVeg<-st_as_sf(ReuVeg)
ReuVeg<-st_simplify(ReuVeg,preserveTopology=FALSE,dTolerance=10)
ReuVeg<-st_buffer(ReuVeg,dist=10,joinStyle="MITRE")
ReuVeg<-st_union(ReuVeg)
save(ReuVeg,file="output/ReuVeg.RData")
plot(ReuVeg,col="darkgreen",border="darkgreen",add=TRUE)

#the agricultural use shapefile
ReuAgri<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/Reunion/bos2013_daaf",
                 layer="bos2013_daafPolygon")
ReuAgri<-st_as_sf(ReuAgri)
ReuAgri<-st_simplify(ReuAgri,preserveTopology=TRUE,dTolerance=10)
ReuAgri<-st_buffer(ReuAgri,dist=10,joinStyle="MITRE")
ReuAgri<-st_union(ReuAgri)
save(ReuAgri,file="output/ReuAgri.RData")
plot(ReuAgri,col="yellowgreen",border="yellowgreen",add=TRUE)

#example of map
plot(ReuDep$geometry,col=brewer.pal(11,"Spectral")[6],lwd=3)
plot(ReuUrb,col=brewer.pal(9,"RdPu")[3],
     border=brewer.pal(9,"RdPu")[3],add=TRUE)
plot(ReuVeg,col=brewer.pal(9,"BuGn")[6],
     border=brewer.pal(9,"BuGn")[6],add=TRUE)
plot(ReuAgri,col=brewer.pal(8,"Accent")[1],
     border= brewer.pal(8,"Accent")[1],add=TRUE)
plot(ReuDep$geometry,col="transparent",lwd=3,add=TRUE)

#export to .pdf 20 x 18 inches


##############################################################################/
#END
##############################################################################/