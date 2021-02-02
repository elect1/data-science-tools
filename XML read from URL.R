# Read XML file from URL

rm(list = ls())  # clear prior environment

source("get_Temp.R")  # load Temp parsing function from URL

library(XML)
library(rJava)
library(XLConnect)  # replaces (& incompatible with) package:xlsx

cwd <- getwd()  # current working directory
Excelfile <- paste(cwd,"/LV Data.xlsx",sep="")

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
URLs <- as.list(URLs)  # create list of the URLs (for lapply looping)

y <- lapply(URLs,get_Temp)  # returns list of forecasts

today <- "2/2/2021"  # dummy character date placeholder
df <- data.frame(today,y)  # puts today and y into a data frame
row.names(df) <- "maxTemp"
print( str(df) )

# The following is unsuccessful because "append = TRUE" refers to
# the ability to add a new worksheet, not adding new data to an
# existing worksheet.  According to Marc Schwarz on
# https://stat.ethz.ch/pipermail/r-help/2016-January/435394.html, try
# using the package XLConnect.  Unsuccessful attempt:
# write.xlsx(df, Excelfile, 
#            col.names = FALSE, row.names = FALSE, append = TRUE)

wb <- loadWorkbook(Excelfile)  # load Excel workbook
startRow <- nrow(readWorksheet(wb,sheet="maxTemp",header=FALSE))+1  # to append
writeWorksheet(wb,df,sheet="maxTemp",startRow=startRow,startCol=1,header=FALSE)
saveWorkbook(wb,Excelfile)

