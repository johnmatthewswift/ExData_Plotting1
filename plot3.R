###########################################################################
##
## This script creates "plot3.png" as part of the Exploratory Data Analysis
## course on Coursera.
##
## Author(s): John Swift
##
## Last update: 2015-11-02
##
###########################################################################


# Libraries ----------------------------------------------------------
library(lubridate)

# Obtain data --------------------------------------------------------

# If not already available in working directory download and extract
if(!file.exists('rawData.RDS')) {
  
  # Create temporary file
  tmp <- tempfile()
  
  # Download data to temporary file
  download.file(
    'https://d396qusza40orc.cloudfront.net/
    exdata%2Fdata%2Fhousehold_power_consumption.zip',
    tmp
  )
  
  # Read data
  rawData <- read.table(
    unz(tmp, 'household_power_consumption.txt'),
    header = TRUE,
    sep = ';'
  )
  
  # Unlink temporary file
  unlink(tmp)
  
  # Save data to avoid need to download and extract again
  saveRDS(rawData, 'rawData.rds')
  
} else {
  
  # If data has already been downloaded then load RDS file
  rawData <- readRDS('rawData.rds')
  
}


# Set correct formats ------------------------------------------------

rawData$Date <- dmy(rawData$Date)
rawData$Time <- hms(rawData$Time)
rawData$Global_active_power <- 
  as.numeric(as.character(rawData$Global_active_power))
rawData$Global_reactive_power <- 
  as.numeric(as.character(rawData$Global_reactive_power))
rawData$Voltage <- 
  as.numeric(as.character(rawData$Voltage))
rawData$Global_intensity <- 
  as.numeric(as.character(rawData$Global_intensity))
rawData$Sub_metering_1 <- 
  as.numeric(as.character(rawData$Sub_metering_1))
rawData$Sub_metering_2 <- 
  as.numeric(as.character(rawData$Sub_metering_2))
rawData$Sub_metering_3 <- 
  as.numeric(as.character(rawData$Sub_metering_3))


# Subset dates of interest -------------------------------------------

subData <- rbind(
  rawData[rawData$Date == "2007-02-01",],
  rawData[rawData$Date == "2007-02-02",]
)


# Create plot --------------------------------------------------------

# Open png device
png(
  filename = 'plot3.png',
  width = 480,
  height = 480
)

# Plot line graph of Sub_metering_1
plot(
  x = subData$Date + subData$Time,
  y = subData$Sub_metering_1,
  type = 'l',
  xlab = '',
  ylab = 'Energy sub metering'
)

# Add line graph of Sub_metering_2 in red
lines(
  x = subData$Date + subData$Time,
  y = subData$Sub_metering_2, 
  col = 'red'
)

# Add line graph of Sub_metering_3 in blue
lines(
  x = subData$Date + subData$Time,
  y = subData$Sub_metering_3, 
  col = 'blue'
)

# Add a legend
legend(
  'topright', 
  c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), 
  col = c('black', 'red', 'blue'),
  lty = 1
  )

#  Close device
dev.off()