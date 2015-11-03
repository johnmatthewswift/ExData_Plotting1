###########################################################################
##
## This script creates "plot4.png" as part of the Exploratory Data Analysis
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
  filename = 'plot4.png',
  width = 480,
  height = 480
)

# Set 2x2 grid for plots
par(mfrow = c(2,2))

# Plot 1 - top left
plot(
  x = subData$Date + subData$Time,
  y = subData$Global_active_power,
  type = 'l',
  xlab = '',
  ylab = 'Global Active Power'
)

# Plot 2 - top right
plot(
  x = subData$Date + subData$Time,
  y = subData$Voltage,
  type = 'l',
  xlab = 'datetime',
  ylab = 'Voltage'
)

# Plot 3 - bottom left

plot(
  x = subData$Date + subData$Time,
  y = subData$Sub_metering_1,
  type = 'l',
  xlab = '',
  ylab = 'Energy sub metering'
)

lines(
  x = subData$Date + subData$Time,
  y = subData$Sub_metering_2, 
  col = 'red'
)

lines(
  x = subData$Date + subData$Time,
  y = subData$Sub_metering_3, 
  col = 'blue'
)

legend(
  'topright', 
  c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), 
  col = c('black', 'red', 'blue'),
  lty = 1,
  bty = 'n'
)

# Plot 4 - bottom right

plot(
  x = subData$Date + subData$Time,
  y = subData$Global_reactive_power,
  type = 'l',
  xlab = 'datetime',
  ylab = 'Global_reactive_power'
)

#  Close device
dev.off()