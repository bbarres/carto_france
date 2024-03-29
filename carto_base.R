##############################################################################/
##############################################################################/
#Basic code for plotting map of France
##############################################################################/
##############################################################################/

#loading the packages necessary for the analysis
library(rgdal)
library(rgeos)
library(plotrix)
library(classInt)


##############################################################################/
#loading the data and producing lighter dataset and .RData files####
##############################################################################/

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


##############################################################################/
#production of coordinates table for regions and departement####
##############################################################################/

#table for the commune####
load("output/commu.RData")
#extract the department coordinates
ind_list<-data.frame("com_NAME"=commu$NOM_COM_M,
                     "com_ID"=commu$INSEE_COM)
coordcom<-data.frame("longitude"=commu@polygons[1][[1]]@labpt[1],
                     "latitude"=commu@polygons[1][[1]]@labpt[2])
for (i in 2:dim(ind_list)[1]){
  coordcom<-rbind(coordcom, 
                  cbind("longitude"=commu@polygons[i][[1]]@labpt[1],
                        "latitude"=commu@polygons[i][[1]]@labpt[2]))
}
coordcom<-cbind(ind_list,coordcom)
#save as .RData
save(coordcom,file="output/coordcom.RData")
#example of use
load("output/COM_SHP.RData")
plot(COM_SHP,lwd=0.1)
text(coordcom$longitude,coordcom$latitude,cex=0.1,
     labels=coordcom$com_NAME,col="darkred")
points(coordcom$longitude,coordcom$latitude,col="blue",cex=0.01,pch=19)

#table for the departements####
load("output/departe.RData")
#extract the department coordinates
ind_list<-data.frame("dep_NAME"=departe$NOM_DEP,
                     "dep_ID"=departe$INSEE_DEP)
coorddep<-data.frame("longitude"=departe@polygons[1][[1]]@labpt[1],
                     "latitude"=departe@polygons[1][[1]]@labpt[2])
for (i in 2:dim(ind_list)[1]){
  coorddep<-rbind(coorddep, 
                  cbind("longitude"=departe@polygons[i][[1]]@labpt[1],
                        "latitude"=departe@polygons[i][[1]]@labpt[2]))
}
coorddep<-cbind(ind_list,coorddep)
#save as .RData
save(coorddep,file="output/coorddep.RData")


#table for the regions####
load("output/regions.RData")
#extract the department coordinates
ind_list<-data.frame("reg_NAME"=regions$NOM_REG,
                     "reg_ID"=regions$INSEE_REG)
coordreg<-data.frame("longitude"=regions@polygons[1][[1]]@labpt[1],
                     "latitude"=regions@polygons[1][[1]]@labpt[2])
for (i in 2:dim(ind_list)[1]){
  coordreg<-rbind(coordreg, 
                  cbind("longitude"=regions@polygons[i][[1]]@labpt[1],
                        "latitude"=regions@polygons[i][[1]]@labpt[2]))
}
coordreg<-cbind(ind_list,coordreg)
coordreg<-cbind(coordreg,
                "reg_CODENAME"=c("ARA","BFC","BRE","CVL","COR","GES","HDF",
                                 "IDF","NOR","NAQ","OCC","PDL","PAC"))
#save as .RData
save(coordreg,file="output/coordreg.RData")


##############################################################################/
#some examples of geographic data manipulation####
##############################################################################/

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


##############################################################################/
#New simplified shapefile####
##############################################################################/

#the shapefiles were simplified using mapshaper (https://mapshaper.org/) with
#simplification method Visvalingam / weighted area at 1% (except for 
#COMMUNE at 5%)
REG_SHP<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/FRANCE_METRO",
                 layer="REGION")
save(REG_SHP,file="output/REG_SHP.RData")
plot(REG_SHP)

DEP_SHP<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/FRANCE_METRO",
                 layer="DEPARTEMENT")
save(DEP_SHP,file="output/DEP_SHP.RData")
plot(DEP_SHP)
DEP_SHP.wgs<-spTransform(DEP_SHP,
                         CRS("+proj=longlat +datum=WGS84"))
plot(DEP_SHP.wgs)

ARR_SHP<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/FRANCE_METRO",
                 layer="ARRONDISSEMENT_DEPARTEMENTAL")
save(ARR_SHP,file="output/ARR_SHP.RData")
plot(ARR_SHP)

EPC_SHP<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/FRANCE_METRO",
                 layer="EPCI")
save(EPC_SHP,file="output/EPC_SHP.RData")
plot(EPC_SHP)

COM_SHP<-readOGR(dsn="C:/Users/benoi/OneDrive/Rfichiers/carto_france/data/FRANCE_METRO",
                 layer="COMMUNE")
save(COM_SHP,file="output/COM_SHP.RData")
plot(COM_SHP,lwd=0.2)


##############################################################################/
#Writing info session for reproducibility####
##############################################################################/

sink("session_info.txt")
print(sessioninfo::session_info())
sink()
#inspired by an R gist of François Briatte: 
#https://gist.github.com/briatte/14e47fb0cfb8801f25c889edea3fcd9b


##############################################################################/
#END
##############################################################################/