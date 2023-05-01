#Detrending TWM_TMS
# Comparing chronologies using ratios vs residuals
# normalizing variance
# plotting on same graph
#Ellie Neifeld
# 2023-02-08

library(dplR)
library(tidyverse)

# read in TWM_TMS raw ring widths
TWM <- read.rwl('data/TWM_TMS.rwl')

# power transform
pt <- powt(rwl=TWM)

#### Chronology 1

# Detrending with Age-dependent spline using residuals
TWM_ADSresidual.rwi <- detrend(rwl = TWM, method = "AgeDepSpline", difference=TRUE)

# Chronology Age dep spline, no power transform, residuals
chron_ads_residual <- chron(TWM_ADSresidual.rwi)
#truncate
ads_trunc_residual <- subset(chron_ads_residual, samp.depth>4)
plot(ads_trunc_residual,add.spline=T,nyrs=30, 
     main = "Age dependent spline. residuals")

##### Chronology 2

# Detrending with Age-dependent spline using ratios
TWM_ADSratio.rwi <- detrend(rwl = TWM, method = "AgeDepSpline", difference=FALSE)

# Chronology Age dep spline, no power transform, ratios
chron_ads_ratio <- chron(TWM_ADSratio.rwi)
#truncate
ads_trunc_ratio <- subset(chron_ads_ratio, samp.depth>4)
plot(ads_trunc_ratio,add.spline=T,nyrs=30, 
     main = "Age dependent spline, ratios")

###### Chronology 3

# Detrending power-transformed data with age dep spline using residuals
TWM_ADS_residual_pt.rwi <- detrend(rwl = pt, method = "AgeDepSpline", 
                          difference=TRUE)

# Chronology Age dep spline, no power transform, ratios
chron_ads_residual_pt <- chron(TWM_ADS_residual_pt.rwi)
#truncate
ads_trunc_residual_pt <- subset(chron_ads_residual_pt, samp.depth>4)
plot(ads_trunc_residual_pt,add.spline=T,nyrs=30, 
     main = "Age dependent spline, residuals, power transformed")

##### Chronology 4

# Detrending power-transformed data with age dep spline using ratios
TWM_ADS_ratio_pt.rwi <- detrend(rwl = pt, method = "AgeDepSpline", 
                                   difference=FALSE)

# Chronology Age dep spline, no power transform, ratios
chron_ads_ratio_pt <- chron(TWM_ADS_ratio_pt.rwi)
#truncate
ads_trunc_ratio_pt <- subset(chron_ads_ratio_pt, samp.depth>4)
plot(ads_trunc_ratio_pt,add.spline=T,nyrs=30, 
     main = "Age dependent spline, ratio, power transformed")



### Signal Free chronology, age dependent spline

dat <- TWM

#cut of sample depth to greater than 4
sampDepth <- rowSums(!is.na(dat))
datTrunc <- dat[sampDepth > 4,]

#build SF chronology with default age-dependent spline
ssfCrn <- ssf(rwl = datTrunc)

plot(ssfCrn,add.spline=TRUE,nyrs=30, main="Signal Free, age dependent spline")



##### SF Chronology 2
#power transform before SF
ptTrunc <- powt(rwl=datTrunc)

#build SF chronology with default age-dependent spline
ssfCrn_pt <- ssf(rwl = ptTrunc)

plot(ssfCrn_pt,add.spline=TRUE,nyrs=30, main="Signal Free, age dependent spline, power transformed")


#import ggplot
library(ggplot2)


#getting standard deviation (7th column) and mean (6th column)
stats<- rwl.stats(ssfCrn)
stats2 <- rwl.stats(ssfCrn_pt)

#divide chronology by its standard deviation, which is the 1st row, 7th column of stats
# so the chronologies plot with the same amplitude
#Make a data frame where the first column is the chronology minus its mean (1st row 6th column), 
#divided by its standard deviation (normalizing)
# second column is the sample depth, then assign names to the rows and columns
norm <- data.frame((ssfCrn[,1]-stats[1,5])/0.296, ssfCrn[,2], row.names = 1683:2021)
norm <- setNames(norm, c("sfc","samp.depth"))
norm2 <- data.frame((ssfCrn_pt[,1]-stats2[1,5])/stats2[1,7], ssfCrn_pt[,2], row.names = 1683:2021)
norm2 <- setNames(norm2, c("sfc","samp.depth"))


### plotting chronologies on same graph


#plotting using ggplot, trying to get both on same graph with same axis
ggplot() +
  geom_line(data = ssfCrn, aes(x=1683:2021, y=sfc), color="red") +
  geom_line(data = ssfCrn_pt, aes(x=1683:2021, y=sfc),color="blue")

#Plotting normalized chronologies (divided by their standard deviation)
#Comparing the power transformed vs non power transformed versions of signal free chronologies--they are the same when normalized. phew
ggplot() +
  geom_line(data = norm, aes(x=1683:2021, y=sfc), color="red") +
  geom_line(data = norm2, aes(x=1683:2021, y=sfc),color="grey", linetype =2)+
  xlab('Year') +
  ylab('RWI')


# Now I want to compare the age-dependent spline detrended chronologies (non-SF) to the
# Age dependent spline chronologies that are Signal Free
# I've got two age-dep spline chrons, one ratio and one residuals, and then both of those are power transformed
# ads_trunc_residual
# ads_trunc_ratio
# ads_trunc_residual_pt
# ads_trunc_ratio_pt

# First let's try plotting the ratio chron with the SF chron
ggplot()+
  geom_line(data = ssfCrn, aes(x=1683:2021, y=sfc), color="red") +
  geom_line(data = ads_trunc_ratio, aes(x=1683:2021, y=std),color="blue")

# Now let's plot the residual chronology with the ratio chronology
ggplot()+
  geom_line(data = ads_trunc_residual, aes(x=1683:2021, y=std), color="red") +
  geom_line(data = ads_trunc_ratio, aes(x=1683:2021, y=std),color="blue")

# Okay, that put them on different axes, as we would expect, so let's find their standard deviations
# so we can normalize the chronologies
stats3<- rwl.stats(ads_trunc_residual)
stats4<- rwl.stats(ads_trunc_ratio)

#Make a data frame where the first column is the chronology divided by its standard deviation (normalizing)
# second column is the sample depth, then assign names to the rows and columns
#SD is the 1st row, 7th column so let's normalize
norm3 <- data.frame((ads_trunc_residual[,1]-stats3[1,5])/stats3[1,7], ads_trunc_residual[,2], row.names = 1683:2021)
norm3 <- setNames(norm3, c("std","samp.depth"))

norm4 <- data.frame((ads_trunc_ratio[,1]-stats4[1,5])/stats4[1,7], ads_trunc_ratio[,2], row.names = 1683:2021)
norm4 <- setNames(norm4, c("std","samp.depth"))

# Now we can plot these on the same axis to check if they are the same
ggplot()+
  geom_line(data = norm3, aes(x=1683:2021, y=std), color="red") +
  geom_line(data = norm4, aes(x=1683:2021, y=std),color="blue") +
  xlab('Year') +
  ylab('RWI') +
  ggtitle("Normalized Residuals (red) vs Ratios (blue), Age-dep spline detrended")

# This is interesting, the residual choice, red line, shows much greater variability in the 1900s
# What is the implication of this?

# Now let's compare these ADS ratio/residual methods of detrending to the SF ADS chronology
ggplot()+
  geom_line(data = norm, aes(x=1683:2021, y=sfc, color="green"), color="green" ) +
  geom_line(data = norm3, aes(x=1683:2021, y=std, color="red"), color="red") +
  geom_line(data = norm4, aes(x=1683:2021, y=std,color="blue"),color="blue") +
  scale_colour_manual(name='Chronology type',
                      breaks=c('Signal Free', 'Residuals', 'Ratios'),
                      values=c('Signal Free'='green', 'Residuals'='red', 'Ratios'='blue'))+
  theme(legend.position="bottom") +
  xlab('Year') +
  ylab('RWI') +
  ggtitle("Comparing normalized age-dependent spline chronologies: ratios(blue), residuals(red), and signal-free(green") 

# Not sure why my legend isn't working

#Now I want to get them on the same axis, so I'm going to find the mean of each chronology and subtract it
# so they center around 0
mean_SF <- mean(norm[,1])
mean_ratio <- mean(norm4[,1])
mean_residual <- mean(norm3[,1])

#Make a data frame where the first column is the normalized chronology minus the mean of the chronology
# second column is the sample depth, then assign names to the rows and columns
norm_SF <- data.frame(norm[,1] - mean_SF, norm[,2], row.names = 1683:2021)
norm_SF <- setNames(norm_SF, c("sfc","samp.depth"))

norm_ratio <- data.frame(norm4[,1] - mean_ratio, norm4[,2], row.names = 1683:2021)
norm_ratio <- setNames(norm_ratio, c("std","samp.depth"))

norm_residual <- data.frame(norm3[,1] - mean_residual, norm3[,2], row.names = 1683:2021)
norm_residual <- setNames(norm_residual, c("std","samp.depth"))


# So now they should be centered around 0 because I subtracted the means of each...
# now, plot on same graph again
ggplot()+
  geom_line(data = norm_ratio, aes(x=1683:2021, y=std,color="blue"),color="blue") +
  geom_line(data = norm_residual, aes(x=1683:2021, y=std, color="red"), color="red") +
  geom_line(data = norm_SF, aes(x=1683:2021, y=sfc, color="green"), color="green" ) +
  xlab('Year') +
  ylab('RWI') +
  ggtitle("Comparing normalized, mean subtracted, age-dependent spline chronologies: ratios(blue), residuals(red), and signal-free(green)")







##### Now we want to do the same thing for spline-detrended chronologies
# forgetting about power transforms because it doesn't seem like it matters

#### Chronology 1

# Detrending with 0.67 spline using residuals
#using already-truncated data
TWM_Splineresidual.rwi <- detrend(rwl = datTrunc, method = "Spline", difference=TRUE)

# Chronology spline, residuals
chron_spline_residual <- chron(TWM_Splineresidual.rwi)

plot(chron_spline_residual, main = "Spline-detrended, residuals")

##### Chronology 2

# Detrending with 0.67 spline using ratios
#using already-truncated data
TWM_Splineratio.rwi <- detrend(rwl = datTrunc, method = "Spline", difference=FALSE)

# Chronology spline, ratios
chron_spline_ratio <- chron(TWM_Splineratio.rwi)

plot(chron_spline_ratio, main = "Spline-detrended, ratios")



##### Chronology 3
#Signal Free chronology
ssfCrn_spline <- ssf(rwl = datTrunc, method="Spline")

plot(ssfCrn_spline,main="Signal Free, spline")

#save chronology to file
write.csv(ssfCrn_spline, "data/ssfCrn_spline.csv")


### Chronology 4
## Chronology spline, residuals, power transform
TWM_Splineresidual_pt.rwi <- detrend(rwl = ptTrunc, method = "Spline", difference=TRUE)

#Build chronology
chron_spline_residual_pt <- chron(TWM_Splineresidual_pt.rwi)


## Plot all three on same graph
ggplot()+
  geom_line(data = chron_spline_ratio, aes(x=1683:2021, y=std,color="blue"),color="blue") +
  geom_line(data = chron_spline_residual, aes(x=1683:2021, y=std, color="red"), color="red") +
  geom_line(data = ssfCrn_spline, aes(x=1683:2021, y=sfc, color="green"), color="green" ) +
  xlab('Year') +
  ylab('RWI') +
  ggtitle("Comparing 0.67 spline chronologies: ratios(blue), residuals(red), and signal-free(green)")


#Now we want to normalize variance
#so first find variance
stats5_res<- rwl.stats(chron_spline_residual)
stats6_rat<- rwl.stats(chron_spline_ratio)
stats7_sf <- rwl.stats(ssfCrn_spline)


#normalize by creating a new data frame where first column is chronology minus its mean, divided by its Standard deviation (normalized)
# 2nd column is sample depth, then assign names to rows and columns
norm5_res <- data.frame((chron_spline_residual[,1]-stats5_res[1,5])/stats5_res[1,7], chron_spline_residual[,2], row.names = 1683:2021)
norm5_res <- setNames(norm5_res, c("std","samp.depth"))

norm6_rat <- data.frame((chron_spline_ratio[,1]-stats6_rat[1,5])/stats6_rat[1,7], chron_spline_ratio[,2], row.names = 1683:2021)
norm6_rat <- setNames(norm6_rat, c("std","samp.depth"))

norm7_sf <- data.frame((ssfCrn_spline[,1]-stats7_sf[1,5])/stats7_sf[1,7], ssfCrn_spline[,2], row.names = 1683:2021)
norm7_sf <- setNames(norm7_sf, c("sfc","samp.depth"))

#now plot on same graph
ggplot()+
  geom_line(data = norm6_rat, aes(x=1683:2021, y=std,color="blue"),color="blue") +
  geom_line(data = norm5_res, aes(x=1683:2021, y=std, color="red"), color="red") +
  geom_line(data = norm7_sf, aes(x=1683:2021, y=sfc, color="green"), color="green" ) +
  xlab('Year') +
  ylab('RWI') +
  ggtitle("Comparing normalized, mean subtracted, 0.67 spline chronologies: ratios(blue), residuals(red), and signal-free(green)")







#### Compare spline residual chronlogy power transformed vs not
# for chron_spline_residual we already have the stats as stats5_res, and normalized chronology norm5_res

#let's get the stats for chron_spline_residual_pt to normalize it
stats8_res_pt<-rwl.stats(chron_spline_residual_pt)

#the mean is already 0 so we don't have to subtract the mean. So only divide by Standard deviation
norm8_res_pt<- data.frame((chron_spline_residual_pt[,1]-stats8_res_pt[1,5])/stats8_res_pt[1,7], chron_spline_residual_pt[,2], row.names = 1683:2021)
norm8_res_pt <- setNames(norm8_res_pt, c("std","samp.depth"))

colors = c("ratio" = "blue", "Signal free"="green", "Residual power transform" = "turquoise3", "Residuals"="red")
#now plot on same graph
ggplot()+
  geom_line(data = norm5_res, aes(x=1683:2021, y=std,color="Residuals")) +
  geom_line(data = norm8_res_pt, aes(x=1683:2021, y=std, color="Residual power transform")) +
  labs(title="Comparing Power transform vs not on chronology calculated with residuals",
       x="Year", y="RWI",color="legend")+
  scale_color_manual(values = colors)


# Okay, so that's good news that the power transform brought down some of the high amplitudes in the 20th century
# now let's compare the pt residual chronology to the ssf and ratio chronologyies


#now plot on same graph
ggplot()+
  geom_line(data = norm6_rat, aes(x=1683:2021, y=std,color="ratio")) +
  geom_line(data = norm8_res_pt, aes(x=1683:2021, y=std, color="Residual power transform")) +
  geom_line(data = norm7_sf, aes(x=1683:2021, y=sfc, color="Signal free") ) +
  labs(title="Comparing normalized, mean subtracted, 0.67 spline chronologies: ratios, residuals power transformed, and signal-free",
       x="Year", y="RWI",color="legend")+
  scale_color_manual(values = colors)
