library(shiny)
library(shinydashboard)
library(highcharter)
library(dplyr)
library(tidyr)
library(rdrop2)
library(lubridate)
library(RCurl)
library(plotly)

datafinal <- read.csv('arrests.csv')
datafinal1 <- read.csv('arrestees.csv')

###added 12/04/2016 by Chuck####
totaldata<-read.csv('totaldata.csv')

totaldata$monthYear <- as.Date(as.yearmon(totaldata$DATE_OF_ARREST,"%m/%d/%Y"))
totaldata$quarterYear <- as.Date(as.yearqtr(totaldata$DATE_OF_ARREST,"%m/%d/%Y"))

totaldata$RACE_DESCRIPTION<-as.character(totaldata$RACE_DESCRIPTION)
totaldata$RACE_DESCRIPTION[totaldata$RACE_DESCRIPTION=="UNKNOWN"]<-"OTHER"
totaldata$RACE_DESCRIPTION[totaldata$RACE_DESCRIPTION=="ASIAN/PACIFIC ISLAND"]<-"OTHER"
totaldata$RACE_DESCRIPTION[totaldata$RACE_DESCRIPTION=="."]<-"OTHER"
totaldata$RACE_DESCRIPTION[totaldata$RACE_DESCRIPTION=="AMERICAN INDIAN/ALASKAN"]<-"OTHER"
totaldata$RACE_DESCRIPTION[totaldata$RACE_DESCRIPTION=="HISPANIC"]<-"HISPANIC/LATINO"


datablack<-totaldata[totaldata$RACE_DESCRIPTION=="BLACK",]
datawhite<-totaldata[totaldata$RACE_DESCRIPTION=="WHITE",]
dataother<-totaldata[totaldata$RACE_DESCRIPTION=="OTHER",]
datahipanic<-totaldata[totaldata$RACE_DESCRIPTION=="HISPANIC/LATINO",]
dataasian<-totaldata[totaldata$RACE_DESCRIPTION=="ASIAN",]

datamonth<-as.data.frame(table(totaldata$monthYear))
dataquarter<-as.data.frame(table(totaldata$quarterYear))
names(datamonth)[1]<-paste("date")
names(datamonth)[2]<-paste("total")
names(dataquarter)[1]<-paste("date")
names(dataquarter)[2]<-paste("total")

datawhitemonth<-as.data.frame(table(datawhite$monthYear))
datawhitequarter<-as.data.frame(table(datawhite$quarterYear))
names(datawhitemonth)[1]<-paste("date")
names(datawhitemonth)[2]<-paste("white")
names(datawhitequarter)[1]<-paste("date")
names(datawhitequarter)[2]<-paste("white")

datablackmonth<-as.data.frame(table(datablack$monthYear))
datablackquarter<-as.data.frame(table(datablack$quarterYear))
names(datablackmonth)[1]<-paste("date")
names(datablackmonth)[2]<-paste("black")
names(datablackquarter)[1]<-paste("date")
names(datablackquarter)[2]<-paste("black")

dataothermonth<-as.data.frame(table(dataother$monthYear))
dataotherquarter<-as.data.frame(table(dataother$quarterYear))
names(dataothermonth)[1]<-paste("date")
names(dataothermonth)[2]<-paste("other")
names(dataotherquarter)[1]<-paste("date")
names(dataotherquarter)[2]<-paste("other")

datahipanicmonth<-as.data.frame(table(datahipanic$monthYear))
datahipanicquarter<-as.data.frame(table(datahipanic$quarterYear))
names(datahipanicmonth)[1]<-paste("date")
names(datahipanicmonth)[2]<-paste("hispanic")
names(datahipanicquarter)[1]<-paste("date")
names(datahipanicquarter)[2]<-paste("hispanic")

dataasianmonth<-as.data.frame(table(dataasian$monthYear))
dataasianquarter<-as.data.frame(table(dataasian$quarterYear))
names(dataasianmonth)[1]<-paste("date")
names(dataasianmonth)[2]<-paste("asian")
names(dataasianquarter)[1]<-paste("date")
names(dataasianquarter)[2]<-paste("asian")

finaldata<-merge(x = datamonth, y = datawhitemonth, by = "date", all.x = TRUE)
finaldata<-merge(x = finaldata, y = datablackmonth, by = "date", all.x = TRUE)
finaldata<-merge(x = finaldata, y = datahipanicmonth, by = "date", all.x = TRUE)
finaldata<-merge(x = finaldata, y = dataasianmonth, by = "date", all.x = TRUE)
finaldata<-merge(x = finaldata, y = dataothermonth, by = "date", all.x = TRUE)

finaldatamonth<-finaldata

finaldata<-merge(x = dataquarter, y = datawhitequarter, by = "date", all.x = TRUE)
finaldata<-merge(x = finaldata, y = datablackquarter, by = "date", all.x = TRUE)
finaldata<-merge(x = finaldata, y = datahipanicquarter, by = "date", all.x = TRUE)
finaldata<-merge(x = finaldata, y = dataasianquarter, by = "date", all.x = TRUE)
finaldata<-merge(x = finaldata, y = dataotherquarter, by = "date", all.x = TRUE)
finaldataquarter<-finaldata


data1 <- finaldataquarter

change.data4<-as.data.frame(table(totaldata$PD))
colnames(change.data4 ) <- c("Jurisdiction", "Number of arrests")

#######################################
########chuck previous#################
data1$date <- as.Date(data1$date, format="%Y-%m-%d")
y.limit <- max(data1$total)
output.table <- data

population1<- as.data.frame(c("White","Black","Hispanic","Asian","Other"))
population2<-c(0.703*208861,0.131*208861,0.057*208861,0.106*208861,0.3*208861*0.01)

change.data <- cbind.data.frame(population1, population2)
colnames(change.data ) <- c("Race", "Number of population")

lval <- dim(data1)[1]
lval <- lval * -1
data.sorted <- data1[order(-1:lval),] 

###################################################


change.data1<- as.data.frame(table(totaldata$RACE_DESCRIPTION))
colnames(change.data1) <- c("Race", "Numbers of Total Arrests")

change.data2<- as.data.frame(table(totaldata$RACE_DESCRIPTION))
colnames(change.data2) <- c("Race", "Numbers of Total Arrests")

#########################################################

dataw <-datafinal1[datafinal1$RACE_DESCRIPTION=="WHITE",]
datab <-datafinal1[datafinal1$RACE_DESCRIPTION=="BLACK",]
datan<-datafinal1[datafinal1$RACE_DESCRIPTION=="AMERICAN INDIAN/ALASKAN",]
datah <-datafinal1[datafinal1$RACE_DESCRIPTION=="HISPANIC",]
dataa <-datafinal1[datafinal1$RACE_DESCRIPTION=="ASIAN/PACIFIC ISLAND",]
datana<-datafinal1[datafinal1$RACE_DESCRIPTION=="UNKNOWN",]
datana1<-datafinal1[datafinal1$RACE_DESCRIPTION==".",]
datana<- rbind(datana,datana1)

age = datafinal1$AGE_AT_ARREST
aget = data.frame(table(datafinal1$AGE_AT_ARREST))
ageb = data.frame(table(datab$AGE_AT_ARREST))
agew = data.frame(table(dataw$AGE_AT_ARREST))
agen = data.frame(table(datan$AGE_AT_ARREST))
ageh = data.frame(table(datah$AGE_AT_ARREST))
agea = data.frame(table(dataa$AGE_AT_ARREST))
agena = data.frame(table(datana$AGE_AT_ARREST))

agem1 <- merge.data.frame(aget,ageb,by.x="Var1", by.y="Var1", all = TRUE)
agem2 <- merge.data.frame(agem1,agew,by.x="Var1", by.y="Var1", all = TRUE)
agem3 <- merge.data.frame(agem2,agen,by.x="Var1", by.y="Var1", all = TRUE)
agem4 <- merge.data.frame(agem3,ageh,by.x="Var1", by.y="Var1", all = TRUE)
agem5 <- merge.data.frame(agem4,agea,by.x="Var1", by.y="Var1", all = TRUE)
agem6 <- merge.data.frame(agem5,agena,by.x="Var1", by.y="Var1", all = TRUE)
colnames(agem6) <-c("Age","Total","Black", "White","Native American", "Hispanics","Asian","Unknown")

#subsetting the data for <18
datat.18 = subset(datafinal1,datafinal1$AGE_AT_ARREST<18)
dataw.18 = subset(dataw,dataw$AGE_AT_ARREST<18)
datab.18 = subset(datab,datab$AGE_AT_ARREST<18)
datan.18 = subset(datan,datan$AGE_AT_ARREST<18)
datah.18 = subset(datah,datah$AGE_AT_ARREST<18)
dataa.18 = subset(dataa,dataa$AGE_AT_ARREST<18)
datana.18 = subset(datana,datana$AGE_AT_ARREST<18)

dataw.18.freq <- data.frame(table(dataw.18$CRIME_CODE_CATEGORY_DESCRIPTION))
datab.18.freq <- data.frame(table(datab.18$CRIME_CODE_CATEGORY_DESCRIPTION))
datat.18.freq <- data.frame(table(datat.18$CRIME_CODE_CATEGORY_DESCRIPTION))
databw.18.freq<- merge.data.frame(dataw.18.freq,datab.18.freq,by.x="Var1", by.y="Var1", all = TRUE)
databwt.18.freq<- merge.data.frame(databw.18.freq,datat.18.freq,by.x="Var1", by.y="Var1", all = TRUE)
colnames(databwt.18.freq) <-c("Crime Category", "White","Black","Total")
daatbwt.18.freq <- databwt.18.freq[order(databwt.18.freq$Total,decreasing=T),]
freq18 <-head(daatbwt.18.freq,10)

change.data3<-as.data.frame(table(datat.18$RACE_DESCRIPTION))
change.data3<-change.data3[3:9,]
colnames(change.data3)<-c("Race","Percentage for arrestees under 18")

#########################################################
arrestdata <- read.csv('arrests.csv', header=T)
arrestdata <- subset(arrestdata,arrestdata$RACE_DESCRIPTION != ".")
arrestdata <- subset(arrestdata,arrestdata$RACE_DESCRIPTION != "")
choices <-as.character(unique(arrestdata$CRIME_CODE_CATEGORY_DESCRIPTION))
choices <- c(choices,"All Crime Types")
selectdata <- arrestdata

####################### UPDATED VERSION##################################
data = read.csv('arrests.csv')    
data$Date = as.Date(data$DATE_OF_ARREST, format="%m/%d/%Y")
data$Year = lubridate::year(data$Date)

data$Race=as.character(data$RACE_DESCRIPTION)
data$Employment=as.character(data$EMPLOYMENT_CODE)
data=subset(data,!data$Race==".")
data=subset(data,!data$Race=="")
data=subset(data,!data$Employment=="")
data=subset(data,!data$Employment==".")
data=subset(data,!data$Employment=="M")
data=subset(data,!data$Employment=="I")
data=subset(data,!data$Employment=="O")
data=subset(data,!data$Employment=="X")
data=subset(data,!data$Employment=="P")
data=subset(data,!data$Employment=="A")
data=subset(data,!data$Employment=="T")
data=subset(data,!data$Employment=="Q")
data=subset(data,!data$Employment=="G")
data=subset(data,!data$Employment=="W")
data=subset(data,!data$Employment=="0")
data=subset(data,!data$Employment=="U")

Employment_unique = unique(data$Employment)
race_unique = unique(data$Race)

white= aggregate(data$Race == "WHITE", list(data$Employment), sum)
black =  aggregate(data$Race == "BLACK", list(data$Employment), sum)
asian =  aggregate(data$Race == "ASIAN", list(data$Employment), sum)
pacific= aggregate(data$Race == "ASIAN/PACIFIC ISLAND", list(data$Employment), sum)
hispanic= aggregate(data$Race == "HISPANIC", list(data$Employment), sum)
indian=aggregate(data$Race == "AMERICAN INDIAN/ALASKAN", list(data$Employment), sum)
data$Race[data$Race == "AMERICAN INDIAN/ALASKAN"] <- "OTHER"
data$Race[data$Race == "ASIAN/PACIFIC ISLAND"] <- "OTHER"
data$Race[data$Race == "UNKNOWN"] <- "OTHER"
data$Race[is.na(data$Race)] <- "OTHER"
other <- aggregate(data$Race == "OTHER", list(as.character(data$Employment)),sum)
alldata=cbind(white$x,black$x,asian$x,hispanic$x,other$x)

Unemployed= aggregate(data$Employment == "N", list(data$Race), sum)
Employed = aggregate(data$Employment == "Y", list(data$Race), sum)
Unemployed$Group.1=c("Asian","Black","Hispanic","Other","White")
Employed$Group.1=c("Asian","Black","Hispanic","Other","White")
colnames(Unemployed)=c("Race","Number")
colnames(Employed)=c("Race","Number")
employment_xlabel=c ("University Students","University Staffs","Unemployed","Students","Employed")
#Student = aggregate(data$Employment == "S", list(data$Race), sum)
#University_staff= aggregate(data$Employment == "F", list(data$Race), sum)
#University_student=aggregate(data$Employment == "D", list(data$Race), sum)

rownames(alldata)=c("University_Students","University_Staffs","Unemployed","Students","Employed")
colnames(alldata)=c("White","Black","Asian","Hispanic","Other")
alldata=as.data.frame(alldata)
