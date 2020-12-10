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

LAVehiclesNEI <- subset(vehiclesNEI,fips=="06037")
LAVehiclesNEI$city <- "Los Angeles County"
bothNEI <- rbind(baltimoreVehiclesNEI,LAVehiclesNEI)

#for some reason I could not get theme_gray or theme_bw to work like in previous plots, used the default theme 
ggp3 <- ggplot(bothNEI, aes(factor(year),y=Emissions, fill=city)) + geom_bar(aes(fill=year),stat="identity")+facet_grid(scales="free",space="free",.~city)+guides(fill=FALSE)+labs(x="Year", y="Total Emission (Kilo-Tons)")+labs(title="Motor Vehicle Source Emissions in Baltimore & LA in 1999-2008")
print(ggp3)
