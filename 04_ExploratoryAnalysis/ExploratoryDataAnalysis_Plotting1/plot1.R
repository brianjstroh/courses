library(lubridate)

#Downloads the source data, formats the Date and Time fields, and subsets on the in-scope dates
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",destfile="household_power_consumption.zip")
unzip(zipfile = "household_power_consumption.zip")
power_consumption<-read.table(file="household_power_consumption.txt",header = TRUE,sep=";",na.strings = "?")
power_consumption$Date<-dmy(power_consumption$Date)
power_consumption$Time<-hms(power_consumption$Time)
power_consumption<-subset(power_consumption,Date>=ymd("2007-02-01")&Date<=ymd("2007-02-02"))

#Opens a png graphics device to write the plot to
png(filename = "plot1.png", width = 480, height = 480)

#Creates a frequency histogram of the Global Active Power (in kilowatts) variable
par(mfrow=c(1,1))
hist(as.numeric(power_consumption$Global_active_power), col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power",breaks=13)

#Closes the png graphics device
dev.off()
