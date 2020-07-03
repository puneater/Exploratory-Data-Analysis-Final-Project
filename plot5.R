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

# Q. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

# extracting SCC codes for EI.Sector carrying "Vehicle"
codes <- SCC[grepl("Vehicle", SCC$EI.Sector), 1]

# getting place (logical subset) for the extracted SCC code in NEI and for fips 24510 (Baltimore City)
place <- NEI$SCC %in% codes & NEI$fips == "24510"

# getting total emission by year for motor vehicles in Baltimore City
data2 <- tapply(NEI$Emissions[place], NEI$year[place], sum)

# plotting the graph
plot(names(data2), data2, data = data2, xlab = "Year", ylab = "Total Emissions (tons)", main = "Motor vehicles in Baltimore City", pch = 20, col = "blue")
lines(names(data2), data2, col = "red")
lines(names(data2)[c(1,4)], data2[c(1,4)], lty = "dashed", col = "grey")

# saving as png file
dev.copy(png, file = "plot5.png")
dev.off()