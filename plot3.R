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
emissions.balti.type<-with(data = data, aggregate(x=Emissions, 
                           by = c(list(year),list(type)), FUN=sum))
colnames(emissions.balti.type)<-c("years", "Type", "Emissions")
#emissions.balti.type[,2]<-tolower(gsub("-", ".", emissions.balti.type[,2]))

png("pngs/plot3.png", width = 720, height = 720, units = "px")
ggplot(data=emissions.balti.type, aes(x=years, y=Emissions, color=Type))+geom_line()+
  ggtitle("Total emissions from PM2.5 decreased in the United States from 1999 to 2008, by types") + 
  xlab("Years")+ ylab("Total emissions of PM2.5") + 
  theme(plot.title = element_text(lineheight=1.5, face="bold"))
dev.off()