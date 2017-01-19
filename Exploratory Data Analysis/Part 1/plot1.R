df<-read.table("household_power_consumption.txt",header = T,sep = ";")
new_df <- df[df$Date %in% c("1/2/2007","2/2/2007") ,]

png("plot1.png",height = 480, width = 480)
new_df$Global_active_power<-as.numeric(new_df$Global_active_power)
hist(new_df$Global_active_power, col = "red", xlab = "Global active power (Kilowatts)", main = "Global active power")
dev.off()
