df<-read.table("household_power_consumption.txt",header = T,sep = ";")
new_df <- df[df$Date %in% c("1/2/2007","2/2/2007") ,]

png("plot2.png",height = 480, width = 480)
Global_active_power<-as.numeric(new_df$Global_active_power)
datetime<-strptime(paste(new_df$Date,new_df$Time,sep = " "),"%d/%m/%Y %H:%M:%S")
plot(datetime,Global_active_power,type="l", ylab = "Global active power (Kilowatts)", xlab = "")
dev.off()
