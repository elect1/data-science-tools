# Read XML file from URL

rm(list = ls())  # clear prior environment

setwd("C:/Users/Patrick/Git/data-science-tools")
source("get_Temp.R")  # load Temp function parsing the URL

library(XML)

string_head <- "https://forecast.weather.gov/MapClick.php?lat="
string_midd <- "&lon="
string_tail <- "&unit=0&lg=english&FcstType=dwml"

PointNames <- c(    "W",   "NW",    "N",   "NE",    "E",   "SE",    "S",   "SW",  "Ctr")
Longitudes <- c(-115.33,-115.30,-115.17,-115.07,-115.06,-115.05,-115.16,-115.27,-115.15)
Latitudes  <- c(  36.17,  36.29,  36.27,  36.28,  36.15,  36.05,  36.02,  36.04,  36.18)

URLs <- vector(mode="character")  # init as zero-length character array

for (i in seq_along(Longitudes)) {
  URLs <- c( URLs, paste(string_head,as.character(Latitudes[i]),
                         string_midd,as.character(Longitudes[i]),
                         string_tail,sep="") )
}

names(URLs) <- PointNames
URLs <- as.list(URLs)

#print( get_Temp(URLs$W) )

y <- lapply(URLs,get_Temp)  # returns list of forecasts
print( as.numeric(y) )
print( str(y) )


