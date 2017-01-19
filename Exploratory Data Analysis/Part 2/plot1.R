NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

total_PM2.5_emission<-aggregate(Emissions ~ year, NEI ,sum)

plot(total_PM2.5_emission$year, total_PM2.5_emission$Emissions,type = "l", xlab = "Year", ylab = "total PM2.5 emission", main = "Total PM2.5 emission from 1999 - 2008")
png("plot1.png")