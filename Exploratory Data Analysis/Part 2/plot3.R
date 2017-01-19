NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
baltimore<-NEI[NEI$fips=="24510",]
source_emission<-aggregate(Emissions ~ year+type, baltimore, sum)

library(ggplot2)

g<-ggplot(source_emission, aes(x = year, y = Emissions, color=type))
g<-g+geom_line(lwd=1)+ggtitle("Total Emissions in Baltimore City (1999-2008)")
print(g)

