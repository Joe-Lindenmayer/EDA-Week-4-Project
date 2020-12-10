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

BaltimoreSubset <- subset(NEI, fips == "24510")
BaltimoreSums <- aggregate(Emissions~year, BaltimoreSubset, sum)

ggp <- ggplot(BaltimoreSubset,aes(factor(year),Emissions,fill=type))+geom_bar(stat="identity")+theme_gray()+guides(fill=FALSE)+facet_grid(.~type,scales="free",space="free")+labs(x="Year",y="Emissions (10^6 Tons)")+labs(title="Emissions in Baltimore 1999-2008 by Source Type")
print(ggp)
#aes() sets the x and y axis. geom_bar sets up a barchart, facet_grid splits the plots into four based on the type category. Arguments are set to free because each plot has different ranges for x and y
