get_Temp <- function(fileURL) {
  
  conn <- url(fileURL, "r")  # open connection to web page
  on.exit(close(conn))       # close connection upon exit
  
  xData <- readLines(conn,warn=FALSE)
  xmlData <- xmlParse(xData)
  
  maxTempForecasts <- xmlValue(getNodeSet(xmlData, "//data[@type='forecast']/parameters/temperature[@type='maximum']/value"))
  
  return(as.numeric(maxTempForecasts[1]))  # return closest forecast
  
}