# Global Active Power (kilowatts) on Thu, Fri, Sat

graph_file = "plot2.png"

# init dat from data set file, or use current one from environment - reset with rm(dat)
if (!exists("dat")) {
  fname = "exdata-data-household_power_consumption.zip"
  furl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  
  # download file if it doesn't exist, & unzip - re-initialise by deleting local copy of zip file
  if(!file.exists(fname)) {
    download.file(furl, fname)
  }
  
  tmpd = tempdir() # don't pollute the user's drive with files
  fh = file(unzip(fname, exdir=tmpd)) # extract the zip
  
  # open file and read data frame, filtering by date range, and including headers in regex
  dat <- read.table(text = grep("^([1,2]/2/2007|Date;Time;)", readLines(fh), value = TRUE), sep = ";", header = TRUE)
  close(fh)
  
  unlink(tmpd, TRUE) # clean up the temp directory
  
  # clean up the dates
  dat$Time <- strptime(paste(dat$Date, dat$Time), "%d/%m/%Y %H:%M:%S")
  dat$Date <- as.Date(dat$Date, "%d/%m/%Y")
}

# create plot
png(filename=graph_file, width = 480 ,height = 480) # file name & dimensions - to create a transparent bg, add bg = "transparent"
plot(dat$Time, dat$Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)", xlab = "")
dev.off() # write to file - the file is created in the current working directory

if (!file.exists(graph_file)) stop(paste("graph file", graph_file, "not found in", getwd()))
print(paste("success: graph file", graph_file, "generated in", getwd()))
