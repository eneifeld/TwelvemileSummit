#Investigating high-frequency relationships using the residual chronology
#Ellie Neifeld
#2023-04-03

#steps that happened before this script:
#making_Residual_chron.R in which I high-pass filtered the chronology and June temperature data

#read in residual chronology
res_crn <- read.csv("data/residual_chron.csv")

#read in high pass filtered (20 yr) JunT data
#I did this in another script
# high-pass filter means just keep the year-to year varibility and remove 
#long-term trends
HighPassT <- read.csv("data/highpass_JunT.csv")
#rename columns
colnames(HighPassT) <- c("X", "Jun")

#make 3 column dataset for running correlations
JunT_highFreq <- data.frame(Year=res_crn[219:339,"X"], 
                            Chronology=res_crn[219:339, "res"],
                            JunT=HighPassT[,"Jun"])

#write csv
write.csv(JunT_highFreq, "data/HighFreq_JunT.csv")

#load the library to do running correlations
#of you don't have this library installed, uncomment:
#install.packages("RolWinMulCor")
library(RolWinMulCor)

#now we can do moving correlations
#31yr window
JunT_res_31 <- rolwincor_1win(JunT_highFreq, varX="Chronology", varY="JunT", 
                              CorMethod="pearson", widthwin=31, Align="center", 
                              pvalcorectmethod="BH", rmltrd=TRUE, Scale=TRUE)
#rmltrd=True means remove linear trend

#plot the correlation coefficients
plot(JunT_res_31[["Correlation_coefficients"]], type="l", 
     main="June Temperature high-frequency 31-yr moving correlations",
     xlab="Year", ylab="Correlation coefficient")

#get stadnard deviation
sdT31 <- sd(JunT_res_31[["Correlation_coefficients"]][,2]) 
#0.138

#11yr moving window correlations
JunT_res_11 <- rolwincor_1win(JunT_highFreq, varX="Chronology", varY="JunT", 
                              CorMethod="pearson", widthwin=11, Align="center", 
                              pvalcorectmethod="BH", rmltrd=TRUE, Scale=TRUE)
#rmltrd=True means remove linear trend

#plot the correlation coefficients
plot(JunT_res_11[["Correlation_coefficients"]], type="l", 
     main="June Temperature high-frequency 11-yr moving correlations", 
     xlab="Year", ylab="Correlation coefficient")

#I want to look at the high frequency time series on the same graph
#get zscores first so each have same standard deviation and mean
zscore_crn <- (JunT_highFreq[,"Chronology"] - mean(JunT_highFreq[,"Chronology"])) / sd(JunT_highFreq[,"Chronology"])
zscore_JunT <- (JunT_highFreq[,"JunT"] - mean(JunT_highFreq[,"JunT"])) / sd(JunT_highFreq[,"JunT"])

#make simple plot of the temperature and chronology on same graph
plot(zscore_crn, type="l")
lines(zscore_JunT, type="l", col="red")

#now I want to make a nicer plot in ggplot so I have to make special dataframes
#make dataframe
#make year vector
Years=1901:2021
#convert Jun temperature zscore to dataframe
Jun_df <- as.data.frame(zscore_JunT)
#name the column "value"
colnames(Jun_df) <- "value"
#add a column called "variable"
Jun_df$variable <- "High-pass filtered June temperature"

#convert chronology zscore to dataframe
Crn_df <- as.data.frame(zscore_crn)
#name the column "value"
colnames(Crn_df) <- "value"
#add a column called "variable"
Crn_df$variable <- "Residual Chronology"
#bind the rows of the temperature and chronology dataframes
zdf <- rbind(Crn_df, Jun_df)
#add a column called years, which is the year vector created above
zdf$Years <- Years

#load ggplot for plotting
library(ggplot2)
#plot (zoom to see figure better)
ggplot(data=zdf, mapping=aes(x=Years, y=value, color=variable, group=variable))+
  geom_line()+
  ggtitle('High frequency June Temperature and Residual Chronology')+
  xlab('Year')+
  ylab('zscore')+
  theme(text = element_text(size = 15))+
  scale_colour_manual(name=element_blank(),values =c('red', 'black'))



#### correlate over the whole period for high frequency
wholeHighF <- cor(JunT_highFreq[,"Chronology"], JunT_highFreq[,"JunT"])
# result = 0.3649