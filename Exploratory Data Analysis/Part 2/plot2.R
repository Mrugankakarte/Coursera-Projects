NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

baltimore<-NEI[NEI$fips=="24510",]

b_aggregate<-aggregate(Emissions ~ year, baltimore, sum)
barplot(height = b_aggregate$Emissions,xlab = "Year", ylim = c(0,5000),ylab = "total PM2.5 Emission", main = "Total Pm2.5 emission in Baltimore",names.arg = b_aggregate$year)
png("plot2.png")