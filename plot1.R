archiveFile <- "exdata_data_NEI_data.zip"

if(!file.exists(archiveFile)) {
  
  archiveURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  
  download.file(url=archiveURL,destfile=archiveFile)
}

if(!(file.exists("summarySCC_PM25.rds") && file.exists("Source_Classification_Code.rds"))) { 
  unzip(archiveFile) 
}

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#sum of total emissions, plotted for comparison
AnnualSums <- aggregate(Emissions ~ year, NEI, sum)
View(AnnualSums)
barplot((AnnualSums$Emissions/10^6),names.arg=AnnualSums$year,xlab="Year",ylab="Emissions (10^6 Tons)", main="Total Annual Emissions From All US Sources")
