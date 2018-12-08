###############################################################################
###############################################################################
#Basic code for plotting map of France
###############################################################################
###############################################################################

#loading the packages necessary for the analysis
library(rgdal)
library(rgeos)
library(plotrix)
library(classInt)


###############################################################################
#loading the data and producing lighter dataset
###############################################################################

#the geographical layer used here were downloaded on the french public dataset 
#https://www.data.gouv.fr/fr/datasets/admin-express/ (which used to be Geofla, 
#from IGN which is the French Institut of Geographic and forest information)

#the smallest administrative unit in France: communes
commu<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/ADE_1-1_SHP_LAMB93_FR",
               layer="COMMUNE")
save(commu,file="output/commu.RData")
commuLight<-gSimplify(commu,1000,topologyPreserve=TRUE)
save(commuLight,file="output/commuLight.RData")
load("output/commuLight.RData")
plot(commuLight)

#EPCI means "Etablissements Publics de Coopération Intercommunale"
EPCI<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/ADE_1-1_SHP_LAMB93_FR",
              layer="EPCI")
save(EPCI,file="output/EPCI.RData")
EPCILight<-gSimplify(EPCI,1000,topologyPreserve=TRUE)
save(EPCILight,file="output/EPCILight.RData")
load("output/EPCILight.RData")
plot(EPCILight)

#arrondissement are an intermediate administrative division
arrond<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/ADE_1-1_SHP_LAMB93_FR",
                layer="ARRONDISSEMENT_DEPARTEMENTAL")
save(arrond,file="output/arrond.RData")
arrondLight<-gSimplify(arrond,1000,topologyPreserve=TRUE)
save(arrondLight,file="output/arrondLight.RData")
load("output/arrondLight.RData")
plot(arrondLight)

#département are an intermediate administrative division
departe<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/ADE_1-1_SHP_LAMB93_FR",
                 layer="DEPARTEMENT")
save(departe,file="output/departe.RData")
departeLight<-gSimplify(departe,1000,topologyPreserve=TRUE)
save(departeLight,file="output/departeLight.RData")
load("output/departeLight.RData")
plot(departeLight)

#régions are the largest administrative division in France
regions<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/ADE_1-1_SHP_LAMB93_FR",
                 layer="REGION")
save(regions,file="output/regions.RData")
regionsLight<-gSimplify(regions,1000,topologyPreserve=TRUE)
save(regionsLight,file="output/regionsLight.RData")
load("output/regionsLight.RData")
plot(regionsLight)


###############################################################################
#some example of geographic data manipulation
###############################################################################

#some information on the data structure of the geodata
class(commu)
slotNames(commu)
summary(commu@data)

#some plotting examples
op<-par(mar=c(0,0,0,0),mfrow=c(2,2))
plot(EPCI,border="grey60",lwd=0.1)
plot(departe,add=TRUE,border="darkred",lwd=0.5)
plot(regions,add=TRUE,lwd=1.5)

plot(arrond,border="grey60",lwd=0.1)
plot(departe,add=TRUE,border="darkred",lwd=0.5)
plot(regions,add=TRUE,lwd=1.5)
plot(arrond[c(23,27,45,122),],add=TRUE,col="blue")

plot(departe,border="darkred",lwd=0.5)
plot(regions,add=TRUE,lwd=1.5)
plot(departe[departe$INSEE_DEP=="01",],add=TRUE,col="blue")
par(op)

#selecting a commune or a list of commune with INSEE ID
commu[commu$INSEE_COM=="63453",]
commu[commu$INSEE_COM %in% c("43033","63453"),]

#the path to access to the barycentre of the commune
commu@polygons[1][[1]]@labpt

#coordinates of the barycentre of the departement
departe@polygons[1][[1]]@labpt

#isolate the information in the spatial data on the communes
db_commu<-commu@data
summary(db_commu)
db_arrond<-arrond@data
db_arrond$DEPARR<-paste(db_arrond$INSEE_DEP,db_arrond$INSEE_ARR,sep="-")
summary(db_arrond)
db_arrond

#extract the coordinates of the department
ind_list<-departe$INSEE_DEP
coorddep<-data.frame("longitude"=departe@polygons[1][[1]]@labpt[1],
                     "latitude"=departe@polygons[1][[1]]@labpt[2])
for (i in 2:length(ind_list)){
  coorddep<-rbind(coorddep, 
                  cbind("longitude"=departe@polygons[i][[1]]@labpt[1],
                        "latitude"=departe@polygons[i][[1]]@labpt[2]))
}
coorddep<-cbind(ind_list,coorddep)
#example of use
NomDepSP<-SpatialPoints(coorddep[,2:3])
NomDepSP$depID<-coorddep[,1]
plot(departeLight)
text(NomDepSP,labels=NomDepSP$depID)


###############################################################################
#END
###############################################################################