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
data.balti<-split(x = data, f = data$fips)[["24510"]]
data.balti<-with(data = data.balti, aggregate(x=Emissions, by = list(year), FUN=sum))
data.balti$city<-rep("Baltimore City", length(data.balti))
data.la<-split(x = data, f = data$fips)[["06037"]]
data.la<-with(data = data.la, aggregate(x=Emissions, by = list(year), FUN=sum))
data.la$city<-rep("Los Angeles County", length(data.la))
datas<-rbind(data.balti, data.la)

png("pngs/plot6.png", width = 720, height = 720, units = "px")
ggplot(data=datas, aes(x=Group.1, y=x, color=city))+geom_line()+
  ggtitle("Comparison of Total emissions from Motor vehicle sources 
          between the Baltimore City and Los Angeles County from 1999 to 2008") + 
  xlab("Years")+ ylab("Total emissions of PM2.5") + 
  theme(plot.title = element_text(lineheight=1.5, face="bold"))
dev.off()