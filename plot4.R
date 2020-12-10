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

#grepl function will search the dataframe for specific phrases. We can use this to find all combustion and coal related entries
combustionData <- grepl("comb",SCC$SCC.Level.One,ignore.case=TRUE)
coalData <- grepl("coal",SCC$SCC.Level.Four, ignore.case=TRUE)
coalCombustion <- (combustionData & coalData) 
combustionSCC <- SCC[coalCombustion,]$SCC
combustionNEI <- NEI[NEI$SCC %in% combustionSCC,]

ggp1 <- ggplot(combustionNEI,aes(factor(year),Emissions/10^5)) + geom_bar(stat="identity")+theme_gray()+guides(fill=FALSE)+labs(x="year", y="Emissions (10^5 Tons)")+labs(title="Coal Combustion Emissions Across the US 1999-2008")
#aes() sets the x and y axis. geom_bar sets up a barchart, facet_grid splits the plots into four based on the type category. Arguments are set to free because each plot has different ranges for x and y
