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

#the smallest administrative unit in France: communes
commu<-readOGR(dsn="C:/Users/Benoit/Documents/Work/Rfichiers/Githuber/geo_data/ADE_1-1_SHP_LAMB93_FR",
               layer="COMMUNE")
plot(commu)

#EPCI means "Etablissements Publics de Coopération Intercommunale"
EPCI<-readOGR(dsn="C:/Users/Benoit/Documents/Work/Rfichiers/Githuber/geo_data/ADE_1-1_SHP_LAMB93_FR",
              layer="EPCI")
plot(EPCI)

#arrondissement are an intermediate
arrond<-readOGR(dsn="C:/Users/Benoit/Documents/Work/Rfichiers/Githuber/geo_data/ADE_1-1_SHP_LAMB93_FR",
                layer="ARRONDISSEMENT_DEPARTEMENTAL")
plot(arrond)

departe<-readOGR(dsn="C:/Users/Benoit/Documents/Work/Rfichiers/Githuber/geo_data/ADE_1-1_SHP_LAMB93_FR",
                 layer="DEPARTEMENT")
plot(departe)


regions<-readOGR(dsn="C:/Users/Benoit/Documents/Work/Rfichiers/Githuber/geo_data/ADE_1-1_SHP_LAMB93_FR",
                 layer="REGION")
plot(regions)

op<-par(mar=c(0,0,0,0))
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





