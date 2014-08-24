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

motor.source<-SCC[grep("motor", SCC$Short.Name, ignore.case = T),]
data<-NEI[NEI$SCC %in% motor.source$SCC,]
data<-split(x = data, f = data$fips)[["24510"]]
data.balti<-with(data = data, aggregate(x=Emissions, by = list(year), FUN=sum))

png("pngs/plot5.png", width = 720, height = 720, units = "px")
ggplot(data=data.balti, aes(x=Group.1, y=x))+geom_line()+
  ggtitle("Total emissions from Motor vehicle sources in the Baltimore City from 1999 to 2008") + 
  xlab("Years")+ ylab("Total emissions of PM2.5") + 
  theme(plot.title = element_text(lineheight=1.5, face="bold"))
dev.off()