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

# Q. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

# extracting SCC codes for EI.Sector carrying "Vehicle"
codes <- SCC[grepl("Vehicle", SCC$EI.Sector), 1]

# getting place (logical subset) for the extracted SCC code in NEI, for fips 24510 (Baltimore City) and 06037 (Los Angeles County)
place <- NEI$SCC %in% codes & NEI$fips %in% c("24510", "06037")

# getting total emission by year for vehicles in LA County and Baltimore City
data2 <- aggregate(NEI$Emissions[place], NEI[place, c(1,6)], sum)

# making a data frame for changes in emissions
data3 <- data.frame("fips" = c(rep("06037", 3), rep("24510", 3)), "year" = c(1, 2, 3, 1.05, 2.05, 3.05))
change <- data2$x[data2$fips == "06037" & data2$year != "2008"] - data2$x[data2$fips == "06037" & data2$year != "1999"]
change <- append(change, data2$x[data2$fips == "24510" & data2$year != "2008"] - data2$x[data2$fips == "24510" & data2$year != "1999"])
change <- abs(change)
data3 <- cbind(data3, data.frame("change" = change))

# plotting two graps

# first for total emissions
par(mfcol = c(1,2))
plot(data2$year, data2$x, xlab = "Year", ylab = "Emissions (in tons) of Motor vehicles", main = "Los Angeles county vs Baltimore City", type = "n")
lines(data2$year[data2$fips == "24510"], data2$x[data2$fips == "24510"], col = "blue")
lines(data2$year[data2$fips == "06037"], data2$x[data2$fips == "06037"], col = "green")
legend("center", col = c("green", "blue"), legend = c("LA County", "Baltimore City"), lty = 1)

# second for change in emissions
plot(data3$year, data3$change, col = data3$fips, type = "n", xlab = "1: 1999-2002, 2: 2002-2005,\n3: 2005-2008", ylab = "Change in Emissions (tons)")
lines(data3$year[data3$fips == "06037"], data3$change[data3$fips == "06037"], col = "green", type = "h")
lines(data3$year[data3$fips == "24510"], data3$change[data3$fips == "24510"], col = "blue", type = "h")

# saving as png file
dev.copy(png, file = "plot6.png", width = 800, height = 600)
dev.off()