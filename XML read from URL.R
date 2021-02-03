# Read XML file from URL and append data to an existing XLSX worksheet

rm(list = ls())  # clear prior environment

library(XML)
library(openxlsx)
source("get_Temp.R")  # load Temp parsing function from URL

# Inputs

Excelfile <- paste(getwd(),"/LV Data.xlsx",sep="")

PointNames <- c(    "W",   "NW",    "N",   "NE",    "E",   "SE",    "S",   "SW",  "Ctr")
Longitudes <- c(-115.33,-115.30,-115.17,-115.07,-115.06,-115.05,-115.16,-115.27,-115.15)
Latitudes  <- c(  36.17,  36.29,  36.27,  36.28,  36.15,  36.05,  36.02,  36.04,  36.18)

# Initializations

string_head <- "https://forecast.weather.gov/MapClick.php?lat="
string_midd <- "&lon="
string_tail <- "&unit=0&lg=english&FcstType=dwml"

URLs <- vector(mode="character")  # init as zero-length character array

for (i in seq_along(Longitudes)) {
  URLs <- c( URLs, paste(string_head,as.character(Latitudes[i]),
                         string_midd,as.character(Longitudes[i]),
                         string_tail,sep="") )
}

# Get forecasts list

names(URLs) <- PointNames
URLs <- as.list(URLs)  # create list of the URLs (for lapply looping)

y <- lapply(URLs,get_Temp)  # returns list of forecasts

# Form data frame for XLSX writing

today <- "2/3/2021"  # dummy character date placeholder
df <- data.frame(today,y)  # puts today and y into a data frame
row.names(df) <- "maxTemp"
print( str(df) )

# Append to Excelfile workbook

wb <- loadWorkbook(Excelfile)
tmp0 <-readWorkbook(wb,sheet="maxTemp",colNames=FALSE,skipEmptyRows=FALSE,skipEmptyCols=FALSE)
startRow <- nrow(tmp0) + 1  # to append
writeData(wb,"maxTemp",df,startRow=startRow,colNames=FALSE)
flag <- saveWorkbook(wb,Excelfile,overwrite=TRUE,returnValue=TRUE)
if (is.logical(flag)) {
    print( paste("Workbook ",Excelfile," successfully updated.",sep=""))
  } else {
    print(flag)
  }
