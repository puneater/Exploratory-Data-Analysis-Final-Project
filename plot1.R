###########################################

# Loading Data


# Downloading data
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, destfile = "data.zip")
rm(url)

# Unzipping data.zip
unzip("data.zip")

# Reading the data
NEI <- readRDS("summarySCC_PM25.rds")  # take a few seconds
SCC <- readRDS("Source_Classification_Code.rds")

##########################################

# Q. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

# calculating sum of emissions year wise
data <- tapply(NEI$Emissions, NEI$year, sum)

# making scatterplot of total emissions vs year
plot(names(data), data, xlim = c(1998, 2009), ylab = "Total emissions (tons)", xlab = "Year", col = names(data), main = "Total emissions vs Year")

# adding a lines to plot to refer the trend
lines(names(data)[c(1,4)], data[c(1,4)], lty = "dashed")
lines(names(data), data)

# adding legend for year plotted
legend("topright", col = names(data), legend = names(data), pch = 1)

# saving as png file
dev.copy(png, file = "plot1.png")
dev.off()