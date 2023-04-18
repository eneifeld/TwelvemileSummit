#Investigating high-frequency relationships using the residual chronology 
#and August precipitation data
#Ellie Neifeld
#2023-04-11

#steps that happened before this script:
#making_Residual_chron.R in which I high-pass filtered the chronology and August precip data

#read in residual chronology
res_crn <- read.csv("data/residual_chron.csv")

#read in high pass filtered (20 yr) JunT data
#I did this in another script
# high-pass filter means just keep the year-to year varibility and remove 
#long-term trends
HighPassP <- read.csv("data/highpass_AugP.csv")
#rename columns
colnames(HighPassP) <- c("X", "Aug")

#make 3 column dataset for running correlations
#1st column=year
#2nd column=residual chronology
#3rd column=high pass filtered august precipitation data
AugP_highFreq <- data.frame(Year=res_crn[219:339,"X"], 
                            Chronology=res_crn[219:339, "res"],
                            AugP=HighPassP[,"Aug"])


#write csv of this 3 column dataframe
write.csv(AugP_highFreq, "data/HighFreq_AugP.csv")

#load the library to do running correlations
library(RolWinMulCor)

#now we can do moving correlations
#31yr window
AugP_res_31 <- rolwincor_1win(AugP_highFreq, varX="Chronology", varY="AugP", 
                              CorMethod="pearson", widthwin=31, Align="center", 
                              pvalcorectmethod="BH", rmltrd=TRUE, Scale=TRUE)
#rmltrd=True means remove linear trend

#plot the correlation coefficients
plot(AugP_res_31[["Correlation_coefficients"]], type="l", 
     main="August precipitation high-frequency 31-yr moving correlations",
     xlab="Year", ylab="Correlation coefficient")

#wow cool a clear upward trend in the high frequency correlation to august precip

#11yr moving window correlations
AugP_res_11 <- rolwincor_1win(AugP_highFreq, varX="Chronology", varY="AugP", 
                              CorMethod="pearson", widthwin=11, Align="center", 
                              pvalcorectmethod="BH", rmltrd=TRUE, Scale=TRUE)
#rmltrd=True means remove linear trend

#plot the correlation coefficients
plot(AugP_res_11[["Correlation_coefficients"]], type="l", 
     main="August Precipitation high-frequency 11-yr moving correlations", 
     xlab="Year", ylab="Correlation coefficient")

#I want to look at the high frequency time series on the same graph
#get zscores first so each have same standard deviation and mean
zscore_crn <- (AugP_highFreq[,"Chronology"] - mean(AugP_highFreq[,"Chronology"])) / sd(AugP_highFreq[,"Chronology"])
zscore_AugP <- (AugP_highFreq[,"AugP"] - mean(AugP_highFreq[,"AugP"])) / sd(AugP_highFreq[,"AugP"])

#make simple plot of the temperature and chronology on same graph
plot(zscore_crn, type="l", main="Residual chronology and high frequency August precipitation")
lines(zscore_AugP, type="l", col="blue")

#add temperature onto this graph from another script
plot(zscore_crn, type="l", main="Residual chronology, high frequency August precipitation, and high frequency June temperature")
lines(zscore_AugP, type="l", col="blue")
lines(zscore_JunT, type="l", col="red")

#next step might be to run dcc moving correlation script with high frequency data? 
#to see how specific months change--to ask is there a change in season?