library(lubridate)

#Downloads the source data, creates a date_time variable for time series representation, and then subsets on the in-scope dates
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",destfile="household_power_consumption.zip")
unzip(zipfile = "household_power_consumption.zip")
power_consumption<-read.table(file="household_power_consumption.txt",header = TRUE,sep=";",na.strings = "?")
power_consumption$date_time<-dmy_hms(paste(power_consumption$Date,power_consumption$Time))
power_consumption<-subset(power_consumption,date_time>=ymd("2007-02-01")&date_time<ymd("2007-02-03"))

#Opens a png graphics device to write the plot to
png(filename = "plot4.png", width = 480, height = 480)
par(mfcol=c(2,2), mar=c(4,4,1,1))

#1st plot is the same as plot2.png
plot(power_consumption$date_time,as.numeric(power_consumption$Global_active_power), xlab = "", ylab = "Global Active Power",type="n")
lines(power_consumption$date_time,as.numeric(power_consumption$Global_active_power))

#Second plot is the same as plot3.png
plot(power_consumption$date_time,as.numeric(power_consumption$Sub_metering_1),xlab = "", ylab = "Energy sub metering",type="n")
lines(power_consumption$date_time,as.numeric(power_consumption$Sub_metering_1))
lines(power_consumption$date_time,as.numeric(power_consumption$Sub_metering_2),col="red")
lines(power_consumption$date_time,as.numeric(power_consumption$Sub_metering_3),col="blue")
legend("topright",legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","red","blue"), lwd=1, seg.len=2, bty="n")

#New 3rd plot shows Voltage vs. datetime
plot(power_consumption$date_time,as.numeric(power_consumption$Voltage),xlab = "datetime", ylab = "Voltage",type="n")
lines(power_consumption$date_time,as.numeric(power_consumption$Voltage))

#New 4th plot shows Global Reactive Power vs. datetime
plot(power_consumption$date_time,as.numeric(power_consumption$Global_reactive_power),xlab = "datetime", ylab = "Global_reactive_power",type="n", yaxs="i")
lines(power_consumption$date_time,as.numeric(power_consumption$Global_reactive_power))

#Closes the png graphics device
dev.off()
