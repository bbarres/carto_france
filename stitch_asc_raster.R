#https://www.r-bloggers.com/2014/04/merge-asc-grids-with-r/



setwd("c:/Users/benoi/OneDrive/Rfichiers/carto_france/data/RGEALTI_MNT_5M_ASC_RGM04UTM38S_MAYO53_D976")  
library(rgdal)  
library(raster)  

# make a list of file names, perhaps like this:  
f <-list.files(pattern = ".asc")  

# turn these into a list of RasterLayer objects  
r <- lapply(f, raster)  


##Approach to follow when the asc files are not aligned  
for(i in 2:length(r)){  
  x<-merge(x=r[[1]],y=r[[i]],tolerance=5000,overlap=T)  
  r[[1]]<-x  
}  

#Write Ascii Grid  
writeRaster(r[[1]],"DTM_10K_combine.asc")  