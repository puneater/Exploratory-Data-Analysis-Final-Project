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

# Q. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

# importing ggplot2
library(ggplot2)

# aggregating sums of emissions according to year and type
data1 <- aggregate(NEI$Emissions, NEI[,c(5,6)], sum)

# renaming columns properly
names(data1) <- c("Type", "Year", "Total_Emissions")

# plotting using qplot and geom_smooth
qplot(Year, Total_Emissions, data = data1, facets = .~Type, ylab = "Total Emissions (tons)") + geom_smooth(method = "lm", se = F)

# saving as png file
dev.copy(png, file = "plot3.png", width = 750)
dev.off()