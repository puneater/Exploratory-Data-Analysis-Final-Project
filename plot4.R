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

# Q. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

# extracting SCC codes for EI.Sector carrying "Comb" and "Coal"
codes <- SCC[grepl("Comb(.*)Coal", SCC$EI.Sector),1]

# getting place (logical subset) for the extracted SCC code in NEI
place <- NEI$SCC %in% codes

# getting total emission by year for coal combustion activities
data2 <- tapply(NEI$Emissions[place], NEI$year[place], sum)

# plotting the graph
plot(names(data2), data2, data = data2, xlab = "Year", ylab = "Total Emissions (tons)", main = "Coal Combustion activities", pch = 20)
lines(names(data2), data2)
lines(names(data2)[c(1,4)], data2[c(1,4)], lty = "dashed", col = "grey")

# saving as png file
dev.copy(png, file = "plot4.png")
dev.off()