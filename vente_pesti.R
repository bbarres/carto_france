##############################################################################/
##############################################################################/
#Example of mapping pesticide sales in France
##############################################################################/
##############################################################################/

#loading the packages necessary for the analysis
library(rgdal)
library(rgeos)
library(plotrix)
library(classInt)


##############################################################################/
#loading the data####
##############################################################################/

load("output/departe.RData")

#loading the pesticide sales figure
pesti2016<-read.table("data/pesticide2016.txt",header=TRUE,sep="\t",quote="")
pestameto<-pesti2016[pesti2016$substance=="ametoctradine",]
pestamisu<-pesti2016[pesti2016$substance=="amisulbrom",]
pestcyazo<-pesti2016[pesti2016$substance=="cyazofamid",]
pestfluop<-pesti2016[pesti2016$substance=="fluopicolide",]


##############################################################################/
#Plotting pesticide sales at the departement level####
##############################################################################/

#map for ametoctradine sells in 2016
temp<- merge(departe,pestameto,by.x="NOM_DEP", by.y="departement")
col<-findColours(classIntervals(temp$quantity, 8, style="quantile"),
                 smoothColors("tan",6,"tan4"))
#departement with 0 sells were lacking in the dataset so are considered
#as without any recorded sell
col[is.na(temp$quantity)]<-"white"
#legend
leg<-findColours(classIntervals(round(temp$quantity/1000,1),8,
                                style="quantile"),smoothColors("tan",6,"tan4"),
                 under="moins de", over="plus de",between="–",cutlabels=FALSE)

plot(departe,border="grey60",col=col,lwd=0.1,main="Ametoc 2016")
legend("right",fill=attr(leg, "palette"),
       legend=gsub("\\.", ",", names(attr(leg,"table"))),
       title = "Vente ametoc 2016 :")

#map for amisulbrom sells in 2016
temp<- merge(departe,pestamisu,by.x="NOM_DEP", by.y="departement")
col<-findColours(classIntervals(temp$quantity, 8, style="quantile"),
                 smoothColors("tan",6,"tan4"))
#departement with 0 sells were lacking in the dataset so are considered
#as without any recorded sell
col[is.na(temp$quantity)]<-"white"
#legend
leg<-findColours(classIntervals(round(temp$quantity/1000,1),8,
                                style="quantile"),smoothColors("tan",6,"tan4"),
                 under="moins de", over="plus de",between="–",cutlabels=FALSE)

plot(departe,border="grey60",col=col,lwd=0.1,main="Amisul 2016")
legend("right",fill=attr(leg, "palette"),
       legend=gsub("\\.", ",", names(attr(leg,"table"))),
       title = "Vente amisul 2016 :")

#map for cyazofamid sells in 2016
temp<- merge(departe,pestcyazo,by.x="NOM_DEP", by.y="departement")
col<-findColours(classIntervals(temp$quantity, 8, style="quantile"),
                 smoothColors("tan",6,"tan4"))
#departement with 0 sells were lacking in the dataset so are considered
#as without any recorded sell
col[is.na(temp$quantity)]<-"white"
#legend
leg<-findColours(classIntervals(round(temp$quantity/1000,1),8,
                                style="quantile"),smoothColors("tan",6,"tan4"),
                 under="moins de", over="plus de",between="–",cutlabels=FALSE)

plot(departe,border="grey60",col=col,lwd=0.1,main="Cyazo 2016")
legend("right",fill=attr(leg, "palette"),
       legend=gsub("\\.", ",", names(attr(leg,"table"))),
       title = "Vente ciazo 2016 :")

#map for fluopicolide sells in 2016
temp<- merge(departe,pestfluop,by.x="NOM_DEP", by.y="departement")
col<-findColours(classIntervals(temp$quantity, 8, style="quantile"),
                 smoothColors("tan",6,"tan4"))
#departement with 0 sells were lacking in the dataset so are considered
#as without any recorded sell
col[is.na(temp$quantity)]<-"white"
#legend
leg<-findColours(classIntervals(round(temp$quantity/1000,1),8,
                                style="quantile"),smoothColors("tan",6,"tan4"),
                 under="moins de", over="plus de",between="–",cutlabels=FALSE)

plot(departe,border="grey60",col=col,lwd=0.1,main="Fluop 2016")
legend("right",fill=attr(leg, "palette"),
       legend=gsub("\\.", ",", names(attr(leg,"table"))),
       title = "Vente fluop 2016 :")


##############################################################################/
#END
##############################################################################/