NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

coal_SCC<-grep("coal", SCC$Short.Name, ignore.case = T)
coal.scc<-SCC[coal_SCC,]

NEI.coal<-NEI[NEI$SCC %in% coal.scc$SCC,]

coal_Agg<-aggregate(Emissions~year, NEI.coal, sum)

plot(coal_Agg$year,coal_Agg$Emissions, type = "l", xlab = "Year", ylab = "Total Emissions",main = "Emissions and Total Coal Combustion for the United States")
