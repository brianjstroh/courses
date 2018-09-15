library(lubridate)

#Downloads the source data, creates a date_time variable for time series representation, and then subsets on the in-scope dates
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",destfile="household_power_consumption.zip")
unzip(zipfile = "household_power_consumption.zip")
power_consumption<-read.table(file="household_power_consumption.txt",header = TRUE,sep=";",na.strings = "?")
power_consumption$date_time<-dmy_hms(paste(power_consumption$Date,power_consumption$Time))
power_consumption<-subset(power_consumption,date_time>=ymd("2007-02-01")&date_time<ymd("2007-02-03"))

#Opens a png graphics device to write the plot to
png(filename = "plot2.png", width = 480, height = 480)
par(mfrow=c(1,1), mar=c(2,4,1,1))

#Plots Global Active Power (in kilowatts) against the date_time index
plot(power_consumption$date_time,as.numeric(power_consumption$Global_active_power), ylab = "Global Active Power (kilowatts)",type="n")
lines(power_consumption$date_time,as.numeric(power_consumption$Global_active_power))

#Closes the png graphics device
dev.off()
