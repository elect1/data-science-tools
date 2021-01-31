# Read XML file from URL

setwd("C:/Users/Patrick/Git/data-science-tools")

library(XML)

URL_West <- "https://forecast.weather.gov/MapClick.php?lat=36.17&lon=-115.33&unit=0&lg=english&FcstType=dwml"

fileURL <- URL_West

con <- url(fileURL, "r")  # open connection to web page
xData <- readLines(con)
xmlData <- xmlParse(xData)

record_id <- xmlValue(getNodeSet(xmlData, "//data[@type='forecast']/location/area-description"))
maxTemp <- xmlValue(getNodeSet(xmlData, "//data[@type='forecast']/parameters/temperature[@type='maximum']/value"))

#rootNode <- xmlRoot(xmlData)
#rootNode[1]