if(!"data" %in% list.files()){
  dir.create("data")
  fileurl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileurl, destfile = "data/exdata_data_NEI_data.zip")
  unzip("data/exdata_data_NEI_data.zip", exdir = "data")
}

if(!"pngs" %in% list.files()){
  dir.create("pngs")
}

if (!"NEI" %in% ls()){
  NEI<-readRDS("data/summarySCC_PM25.rds")
}
if(!"SCC" %in% ls()){
  SCC <- readRDS("data/Source_Classification_Code.rds")
}


data<-split(x = NEI, f = NEI$fips)[["24510"]]
emissions.balti<-with(data = data, aggregate(x=Emissions, by = list(year), FUN=sum))
png("pngs/plot2.png", width = 720, height = 720, units = "px")
plot(x=emissions.balti$Group.1, y=emissions.balti$x, 
     main="Total emissions from PM2.5 decreased in the Baltimore City, Maryland from 1999 to 2008",
     xlab="Years", ylab="Emissions", type="l")
dev.off()