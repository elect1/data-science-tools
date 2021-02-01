# Read XML file from URL

setwd("C:/Users/Patrick/Git/data-science-tools")

library(XML)

URL_W   <- "https://forecast.weather.gov/MapClick.php?lat=36.17&lon=-115.33&unit=0&lg=english&FcstType=dwml"
URL_NW  <- "https://forecast.weather.gov/MapClick.php?lat=36.29&lon=-115.30&unit=0&lg=english&FcstType=dwml"
URL_N   <- "https://forecast.weather.gov/MapClick.php?lat=36.27&lon=-115.17&unit=0&lg=english&FcstType=dwml"
URL_NE  <- "https://forecast.weather.gov/MapClick.php?lat=36.28&lon=-115.07&unit=0&lg=english&FcstType=dwml"
URL_E   <- "https://forecast.weather.gov/MapClick.php?lat=36.15&lon=-115.06&unit=0&lg=english&FcstType=dwml"
URL_SE  <- "https://forecast.weather.gov/MapClick.php?lat=36.05&lon=-115.05&unit=0&lg=english&FcstType=dwml"
URL_S   <- "https://forecast.weather.gov/MapClick.php?lat=36.02&lon=-115.16&unit=0&lg=english&FcstType=dwml"
URL_SW  <- "https://forecast.weather.gov/MapClick.php?lat=36.04&lon=-115.27&unit=0&lg=english&FcstType=dwml"
URL_Ctr <- "https://forecast.weather.gov/MapClick.php?lat=36.18&lon=-115.15&unit=0&lg=english&FcstType=dwml"

fileURL <- URL_West

#get_Temp(fileURL)

x <- as.list(c(URL_W,URL_NW,URL_N,URL_NE,URL_E,URL_SE,URL_S,URL_SW,URL_Ctr))
y <- lapply(x,get_Temp)
print( as.numeric(y) )

get_Temp <- function(fileURL) {
  
  conn <- url(fileURL, "r")  # open connection to web page
  on.exit(close(conn))       # close connection upon exit
  
  xData <- readLines(conn)
  xmlData <- xmlParse(xData)
  
  maxTempForecasts <- xmlValue(getNodeSet(xmlData, "//data[@type='forecast']/parameters/temperature[@type='maximum']/value"))
  
  return(as.numeric(maxTempForecasts[1]))
  
}
