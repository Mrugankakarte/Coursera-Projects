NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
library(ggplot2)
motor_SCC<-grep("motor", SCC$Short.Name, ignore.case = T)
motor.scc<-SCC[motor_SCC,]

baltimoreLA<-NEI[NEI$fips=="24510"|NEI$fips =="06037",]

baltimoreLA.motor<-baltimoreLA[baltimoreLA$SCC %in% motor.scc$SCC,]

motor_Agg<-aggregate(Emissions~year+fips, baltimoreLA.motor, sum)
motor_Agg$fips[motor_Agg$fips=="24510"]<-"Baltimore City"
motor_Agg$fips[motor_Agg$fips=="06037"]<-"Los Angeles County"
g<-ggplot(motor_Agg, aes(year, Emissions,color=fips))
g<-g+geom_line(lwd=1)+ggtitle("motor vehicle emissions : Baltimore City vs Los Angeles County")
print(g)

png("plot6.png")