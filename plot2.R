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

#subset data to only have Baltimore entries
BaltimoreSubset <- subset(NEI, fips == "24510")
#Sum the data like in the previous question, but specifically for Baltimore City
BaltimoreSums <- aggregate(Emissions~year, BaltimoreSubset, sum)
barplot((BaltimoreSums$Emissions/10^6),names.arg=BaltimoreSums$year,xlab="Year",ylab="Emissions (Tons)",main="Total Annual Emissions From Baltimore")
