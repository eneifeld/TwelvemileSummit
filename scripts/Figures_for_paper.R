# Figures for divergence term paper spring 2023 
#the climate system
# Ellie Neifeld
# 2023-04-18

#load ggplot for plotting
library(ggplot2)


# Residual chronology and high-pass filtered june temperature
#read in residual chronology
res_crn <- read.csv("data/residual_chron.csv")

JunT_highFreq <- read.csv("data/HighFreq_JunT.csv")
#remove first column
JunT_highFreq <- JunT_highFreq[,-1]

#I want to look at the high frequency time series on the same graph
#get zscores first so each have same standard deviation and mean
zscore_crn <- (JunT_highFreq[,"Chronology"] - mean(JunT_highFreq[,"Chronology"])) / sd(JunT_highFreq[,"Chronology"])
zscore_JunT <- (JunT_highFreq[,"JunT"] - mean(JunT_highFreq[,"JunT"])) / sd(JunT_highFreq[,"JunT"])

#now I want to make a nicer plot in ggplot so I have to make special dataframes
#make dataframe
#make year vector
Years=1901:2021
#convert Jun temperature zscore to dataframe
Jun_df <- as.data.frame(zscore_JunT)
#name the column "value"
colnames(Jun_df) <- "value"
#add a column called "variable"
Jun_df$variable <- "High-pass Filtered June Temperature"

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

#plot (zoom to see figure better)
Fig1b <- ggplot(data=zdf, mapping=aes(x=Years, y=value, color=variable, group=variable))+
  geom_line()+
  xlab('Year')+
  ylab('zscore')+
  theme(legend.position = "right") +
  scale_colour_manual(name=element_blank(),values =c('red', 'black'))

### regular SF chronology and regular june temps
tmp_crn <- read.csv("data/tmp_union.csv")

# find the zscores of the chronology and June temperature
zscore_crn <- (tmp_crn[219:339,"Chronology"] - mean(tmp_crn[219:339,"Chronology"])) / sd(tmp_crn[219:339,"Chronology"])
zscore_Jun <- (tmp_crn[219:339,"Jun"] - mean(tmp_crn[219:339,"Jun"], na.rm=TRUE)) / sd(tmp_crn[219:339,"Jun"], na.rm = TRUE)
#make year vector
Years = 1901:2021

#make data frame 
zscores <- data.frame(Years=Years, Chronology=zscore_crn, June=zscore_Jun)

#june temperatures
Fig1a <- ggplot()+
  geom_line(data=zscores, aes(Years, June, color='red'))+
  geom_line(data=zscores, aes(Years, Chronology, color='black'))+
  xlab('Year')+
  ylab('zscore')+
  theme(legend.position = "right") +
  scale_colour_manual(name=element_blank(),values =c('black'='black','red'= 'red'),
                      labels = c('Signal-Free Chronology','June Temperature'))
#load library
library(cowplot)
##combine onto same panel
#Figure 1a and b
#plot_grid(Fig1a, Fig1b, 
#          labels = c("A", "B"),
#          ncol = 1, nrow = 2)

#This worked to get the x axes to align
##Figure 1 final ###
gA <- ggplotGrob(Fig1a)
gB <- ggplotGrob(Fig1b)
grid::grid.newpage()
grid::grid.draw(rbind(gA, gB))

###Figure 2
#moving correlations 31 yr window june t
library(RolWinMulCor) # running correlation package
#31yr window
JunT_res_31 <- rolwincor_1win(JunT_highFreq, varX="Chronology", varY="JunT", 
                              CorMethod="pearson", widthwin=31, Align="center", 
                              pvalcorectmethod="BH", rmltrd=TRUE, Scale=TRUE)
#rmltrd=True means remove linear trend

#plot the correlation coefficients
Fig2a <- plot(JunT_res_31[["Correlation_coefficients"]], type="l", 
     main="June Temperature high-frequency 31-yr moving correlations",
     xlab="Year", ylab="Correlation coefficient")

#moving cor with precip 31 yr window
#read in hig frequency precip data
AugP_highFreq <- read.csv("data/HighFreq_AugP.csv")
#remove 1st column
AugP_highFreq <- AugP_highFreq[,-1]

#31yr window
AugP_res_31 <- rolwincor_1win(AugP_highFreq, varX="Chronology", varY="AugP", 
                              CorMethod="pearson", widthwin=31, Align="center", 
                              pvalcorectmethod="BH", rmltrd=TRUE, Scale=TRUE)

#plot the correlation coefficients
Fig2b <- plot(AugP_res_31[["Correlation_coefficients"]], type="l", 
     main="August precipitation high-frequency 31-yr moving correlations",
     xlab="Year", ylab="Correlation coefficient")

plot_grid(Fig2a, Fig2b, 
          labels = c("A", "B"),
          ncol = 2, nrow = 1)

par(mfrow=c(1,2))
plot(JunT_res_31[["Correlation_coefficients"]], type="l", 
     main="June Temperature",
     xlab="Middle year of window", ylab="Correlation coefficient")
plot(AugP_res_31[["Correlation_coefficients"]], type="l", 
     main="August Precipitation",
     xlab="Middle year of window", ylab="Correlation coefficient")
