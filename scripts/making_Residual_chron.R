#Making residual chronology
#Ellie Neifeld
#2023-04-03

library(dplR)

#read in rwl
TWM <- read.rwl('data/TWM_TMS.rwl')

#cut of sample depth to greater than 4
sampDepth <- rowSums(!is.na(TWM))
datTrunc <- TWM[sampDepth > 4,]


#make normal spline-detrended chronology, because it can't deal with signal free
spline <- detrend(datTrunc, method=c("Spline"))


res_crn <- chron(spline, prewhiten = TRUE)

plot(res_crn[,"res"], type="l")
plot(res_crn[,"std"], type="l")

#writing residual chronology to csv
write.csv(res_crn, "data/residual_chron.csv")


###### high-pass filtering June temperature climate data
#read in temp data
tmp <- read.csv("data/TMS_tmp.csv")

#get rid of first column
tmp <- subset(tmp, select=-c(1))

#name columns
#assign column names for the dataset
colnames(tmp) <- c("Year","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sept","Oct","Nov","Dec")

#pull out jun temperature and high-pass filter it
#using a period of 20yrs for filter
HighPass_JunT <- pass.filt(tmp[,"Jun"], W=20, type=c("high"))

plot(HighPass_JunT, type="l")

write.csv(HighPass_JunT, "data/highpass_JunT.csv")


######high pass filtered August precipitation data
#read in precipitation data
pre <- read.csv("data/TMS_pre.csv")

#get rid of first column
pre <- subset(pre, select=-c(1))

#name columns
#assign column names for the dataset
colnames(pre) <- c("Year","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sept","Oct","Nov","Dec")

#pull out august precipitation and high-pass filter it
#using a period of 20yrs for filter
HighPass_AugP <- pass.filt(pre[,"Aug"], W=20, type=c("high"))

#plot to look at data
plot(HighPass_AugP, type="l")

#write csv of data
write.csv(HighPass_AugP, "data/highpass_AugP.csv")
