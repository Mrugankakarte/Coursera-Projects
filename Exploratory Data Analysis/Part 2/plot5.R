#NEI <- readRDS("summarySCC_PM25.rds")
#SCC <- readRDS("Source_Classification_Code.rds")

motor_SCC<-grep("motor", SCC$Short.Name, ignore.case = T)
motor.scc<-SCC[motor_SCC,]

baltimore<-NEI[NEI$fips=="24510",]

baltimore.motor<-baltimore[baltimore$SCC %in% motor.scc$SCC,]

motor_Agg<-aggregate(Emissions~year, baltimore.motor, sum)

plot(motor_Agg$year,motor_Agg$Emissions, col="red",type = "l", xlab = "Year", ylab = "Total Emissions",main = "Total Emissions from Motor Vehicle Sources")
