plot4 <- function() {
  
  ## If the required dataframe does not exist, the code will 
  ## read and save file to RData so as not to 
  ## have to do it each time. First check if the Rdata file exists,
  
  
  if (!file.exists("powerdata.Rdata")){
    
    ## check to see if the source data already exists, 
    ## If not, then download and unzip file from source 
    ## Using http instead of https and mode = "wb" 
    ## to eliminate download issues in Win
    
    datafile <- "household_power_consumption.txt"
    if (!file.exists(datafile)){
      download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                    destfile = "PowerConsumption.zip", mode = "wb")
      unzip("PowerConsumption.zip")
      file.remove("PowerConsumption.zip")
    }
    
    ## Read table from source data, subset for required dates and save
    ## as Rdata so it is available for all the scripts that need this data
    
    readfile <- read.table("household_power_consumption.txt", header = TRUE, na.string="?", sep =";")
    dates <- c("1/2/2007", "2/2/2007")
    readfile <- subset(readfile, Date %in% dates)
    save(readfile, file = "powerdata.Rdata")
  }  
  
  else load ("powerdata.Rdata")
  
  ## Convert Data and Time into a new Date/Time column using paste and strptime
  readfile$DateTime <- paste(readfile$Date, readfile$Time)
  readfile$DateTime <- strptime(readfile$DateTime, format = "%d/%m/%Y %H:%M:%S")
  
  as.numeric(as.character(readfile$Sub_metering_1))
  as.numeric(as.character(readfile$Sub_metering_2))
  as.numeric(as.character(readfile$Sub_metering_3))
  
  ## Plot to png
  
   png("plot4.png", width=480, height=480)
   par(mfrow = c(2,2))
   
  ## 1st plot
   plot(readfile$DateTime, readfile$Global_active_power, 
       ylab = "Global Active Power (kilowatts)", xlab = "", type = "l")
  
  ## 2nd plot 
  
    plot(readfile$DateTime, readfile$Voltage, 
      ylab = "Voltage", xlab = "datetime", type = "l")
  
  ## 3rd plot
   plot(readfile$DateTime, readfile$Sub_metering_1, ylab = "Energy sub metering", xlab = "", type = "l")
   lines(readfile$DateTime, readfile$Sub_metering_2, type = "l", col="red")
   lines(readfile$DateTime, readfile$Sub_metering_3, type = "l", col="blue")
   legend("topright", c("Sub_Metering_1","Sub_Metering_2", "Sub_Metering_3"), lty = c(1,1,1), col=c("black","blue","red"))
  
  ## 4th plot
     
     plot(readfile$DateTime, readfile$Global_reactive_power, 
       ylab = "Global_reactive_power", xlab = "datetime", type = "l")
  
  dev.off()
}