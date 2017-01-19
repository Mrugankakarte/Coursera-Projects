df<-read.table("household_power_consumption.txt",header = T,sep = ";",stringsAsFactors = F)
new_df <- df[df$Date %in% c("1/2/2007","2/2/2007") ,]

datetime <- strptime(paste(new_df$Date, new_df$Time, sep=" "), "%d/%m/%Y %H:%M:%S") 
Sub_metering_1 <- as.numeric(new_df$Sub_metering_1)
Sub_metering_2 <- as.numeric(new_df$Sub_metering_2)
Sub_metering_3 <- as.numeric(new_df$Sub_metering_3)

png("plot3.png", width = 480, height = 480)
plot(datetime, new_df$Sub_metering_1, type="l", ylab="Energy Submetering", xlab="")
lines(datetime, new_df$Sub_metering_2, type="l", col="red")
lines(datetime, new_df$Sub_metering_3, type="l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, col=c("black", "red", "blue"))
dev.off()