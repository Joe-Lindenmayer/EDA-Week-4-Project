library(ggplot2)
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

vehicles <- grepl("vehicle",SCC$SCC.Level.Two, ignore.case=TRUE)
vehiclesSCC <- SCC[vehicles,]$SCC
vehiclesNEI <- NEI[NEI$SCC %in% vehiclesSCC,]

baltimoreVehiclesNEI <- subset(vehiclesNEI,fips=="24510")
baltimoreVehiclesNEI$city <- "Baltimore City"

ggp2 <- ggplot(baltimoreVehiclesNEI,aes(factor(year),Emissions))+geom_bar(stat="identity")+theme_gray()+guides(fill=FALSE)+labs(x="Year", y="Emissions (10^5 Tons)")+labs(title="Motor Vehicle Source Emissions in Baltimore from 1999-2008")
