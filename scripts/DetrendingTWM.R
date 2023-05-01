# 2023-01-25
# Detrending TWM_TMS
# Subtraction method
# Later in script is fall 2022 detrending (don't use)
# set working directory to Projects folder

library(dplR)
library(tidyverse)

# read in TWM_TMS raw ring widths
TWM <- read.rwl('data/TWM_TMS.rwl')
# plotting rwl spagetti plot
plot(TWM, plot.type="spag")


## Autoregressive detrending
#start writing to pdf
pdf(file="output/TWM_Ar.pdf", useDingbats = FALSE)
# detrending with autoregressive
TWM_Ar.rwi <- detrend(rwl = TWM, method = "Ar", make.plot = TRUE, difference=TRUE)
#stop writing to pdf
dev.off()

# power transform
pt <- powt(rwl=TWM)

# detrending power-tranformed data with autoregressive
pdf(file="output/TWM_Ar_pt.pdf", useDingbats = FALSE)
TWM_Ar_pt.rwi <- detrend(rwl = pt, method = "Ar", make.plot = TRUE, 
                         difference=TRUE)
#stop writing to pdf
dev.off()

#detrending raw data with spline
pdf(file="output/TWM_spline.pdf", useDingbats = FALSE)
# detrending with spline
TWM_spline.rwi <- detrend(rwl = TWM, method = "Spline", f=0.3, make.plot = TRUE, 
                          difference = TRUE)
#stop writing to pdf
dev.off()


# detrending power-tranformed data with spline
pdf(file="output/TWM_spline_pt.pdf", useDingbats = FALSE)
TWM_spline_pt.rwi <- detrend(rwl = pt, method = "Spline", make.plot = TRUE, 
                         difference=TRUE)
#stop writing to pdf
dev.off()

# detrending power-tranformed data with negative exponential
pdf(file="output/TWM_NE_pt.pdf", useDingbats = FALSE)
TWM_NE_pt.rwi <- detrend(rwl = pt, method = "ModNegExp", make.plot = TRUE, 
                             difference=TRUE)
#stop writing to pdf
dev.off()

# Detrending with Negative exponential, no power transform
pdf(file="output/TWM_NE.pdf", useDingbats = FALSE)
TWM_NE.rwi <- detrend(rwl=TWM, method= "ModNegExp", make.plot = TRUE, 
                      difference =TRUE)
dev.off()


# Detrending with Age-dependent spline
TWM_ADS.rwi <- detrend(rwl = TWM, method = "AgeDepSpline", difference=TRUE)

# Detrending power-transformed data with age dep spline
TWM_ADS_pt.rwi <- detrend(rwl = pt, method = "AgeDepSpline", 
                          difference=TRUE)

#########

# Building chronology with Ar method
chron_Ar <- chron(TWM_Ar.rwi)
# make into time series object
chron_Ar.ts <- ts(chron_Ar[,1],1600)
#plot Ar chronology
ts.plot(chron_Ar.ts, xlab="Years",ylab="Tree-Ring Indicies", 
        main = "Chronology: Ar not power transformed")
#cut off sample depth at >4
ArTrunc <- subset(chron_Ar, samp.depth>4)
plot(ArTrunc, add.spline=T,nyrs=30, main = "Truncated Chronology: Ar")

# Building chronology with Ar method from power transformed data
chron_Ar_pt <- chron(TWM_Ar_pt.rwi)
# make into time series object
chron_Ar_pt.ts <- ts(chron_Ar_pt[,1],1600)
#plot Ar chronology
ts.plot(chron_Ar_pt.ts, xlab="Years",ylab="Tree-Ring Indicies", 
        main = "Chronology: Ar power transformed")
#another way to plot
plot(chron_Ar_pt,add.spline=T,nyrs=30, main = "Chronology: Ar power transformed")

## cutting off Ar_pt chronology at sample depth >4
TWM_ArTrunc <- subset(chron_Ar_pt, samp.depth > 4)
plot(TWM_ArTrunc,add.spline=T,nyrs=30, main = "Truncated Chronology: Ar power transformed")


# Building chronology with Spline method
chron_sp <- chron(TWM_spline.rwi)
# make into time series object
#chron_sp.ts <- ts(chron_sp[,1],1600)
#plot Ar chronology
#ts.plot(chron_sp.ts, xlab="Years",ylab="Tree-Ring Indicies", 
#        main = "Chronology: Spline detrended, not power transformed")
plot(chron_sp, add.spline=T, nyrs=30, ylab="Tree-Ring Indicies",
     main = "Chronology: Spline detrended, not power transformed")
#cut off at sample depth >4
TWM_spTrunc <- subset(chron_sp, samp.depth > 4)
plot(TWM_spTrunc,add.spline=T,nyrs=30, main = "Truncated Chronology: Spline detrended, not power transformed")


# Building chronology with Spline method with power transformed data
chron_sp_pt <- chron(TWM_spline_pt.rwi)
# make into time series object
#chron_sp_pt.ts <- ts(chron_sp_pt[,1],1600)
#plot Ar chronology
#ts.plot(chron_sp_pt.ts, xlab="Years",ylab="Tree-Ring Indicies",
#        main = "Chronology: Spline detrended, power transformed")
plot(chron_sp_pt, add.spline=T, nyrs=30, ylab="Tree-Ring Indicies",
     main = "Chronology: Spline detrended, power transformed")
## cutting off chronology at sample depth >4
TWM_sp_ptTrunc <- subset(chron_sp_pt, samp.depth > 4)
plot(TWM_sp_ptTrunc,add.spline=T,nyrs=30, 
     main = "Truncated Chronology: Spline detrended, power transformed")


# Building chronology with Negative exponenential power transformed data
chron_ne_pt <- chron(TWM_NE_pt.rwi)
plot(chron_ne_pt, add.spline=T, nyrs=30, ylab="Tree-Ring Indicies",
     main = "Chronology: Negative exponential or straight line detrended, power transformed")
#truncate at >4 samples
ne_ptTrunc <- subset(chron_ne_pt, samp.depth>4)
plot(ne_ptTrunc, add.spline=T,nyrs=30, 
     main = "Truncated Chronology: Neg Exp detrended, power transformed")


# Building chronology with Neg Exp, no power transform
chron_ne <- chron(TWM_NE.rwi)
plot(chron_ne, add.spline=T, nyrs=30, ylab="Tree-Ring Indicies",
     main = "Chronology: Negative exponential or straight line detrended, not power transformed")
#truncate
ne_Trunc <- subset(chron_ne, samp.depth>4)
plot(ne_Trunc, add.spline=T,nyrs=30, 
     main = "Truncated Chronology: Neg Exp detrended")

# Chronology Age dep spline, no power transform
chron_ads <- chron(TWM_ADS.rwi)
#truncate
ads_trunc <- subset(chron_ads, samp.depth>4)
plot(ads_trunc,add.spline=T,nyrs=30, 
     main = "Truncated Chronology: Age dependent spline detrended")

# Chronology Age dep spline, with power transform
chron_ads_pt <- chron(TWM_ADS_pt.rwi)
#truncate
ads_pt_trunc <- subset(chron_ads_pt, samp.depth>4)
plot(ads_pt_trunc,add.spline=T,nyrs=30, 
     main = "Truncated Chronology: Age dependent spline, power transformed")


##########
# Fall 2022 detrending TWM
# Detrended using division instead of subtraction
# also I messed with the f=0.5, which now I know should stay at 0.5


#start writing to pdf
pdf(file="TWM_agedep.pdf", useDingbats = FALSE)
# detrending with age-dependent spline
TWM_agedep.rwi <- detrend(rwl = TWM, method="AgeDepSpline", f=0.3, make.plot = TRUE)
#stop writing to pdf
dev.off()

#start writing to pdf
pdf(file="TWM_NE.pdf", useDingbats = FALSE)
# detrending with negative exponential
TWM_NE.rwi <- detrend(rwl = TWM, method = "ModNegExp", make.plot = TRUE)
#stop writing to pdf
dev.off()

#start writing to pdf
pdf(file="TWM_spline.pdf", useDingbats = FALSE)
# detrending with spline
TWM_spline.rwi <- detrend(rwl = TWM, method = "Spline", f=0.3, make.plot = TRUE)
#stop writing to pdf
dev.off()

#start writing to pdf
pdf(file="TWM_Mean.pdf", useDingbats = FALSE)
# detrending with mean
TWM_mean.rwi <- detrend(rwl = TWM, method = "Mean", make.plot = TRUE)
#stop writing to pdf
dev.off()

#start writing to pdf
pdf(file="TWM_Ar.pdf", useDingbats = FALSE)
# detrending with autoregressive
TWM_Ar.rwi <- detrend(rwl = TWM, method = "Ar", make.plot = TRUE)
#stop writing to pdf
dev.off()

#start writing to pdf
pdf(file="TWM_F.pdf", useDingbats = FALSE)
# detrending with Friedman's super smoother
TWM_F.rwi <- detrend(rwl = TWM, method = "Friedman", make.plot = TRUE)
#stop writing to pdf
dev.off()

#start writing to pdf
pdf(file="TWM_Huger.pdf", useDingbats = FALSE)
# detrending with Hugershoff
TWM_Huger.rwi <- detrend(rwl = TWM, method = "ModHugershoff", make.plot = TRUE)
#stop writing to pdf
dev.off()

#detrending with RCS
#can't do this until i have po- pith offset file.
#pdf(file="TWM_rcs", useDingbats = FALSE)
#TWM_rcs.rwi <- rcs(TWM,po, make.plot=TRUE)
#dev.off()


##building chronology
TWMCrn_NE <- chron(TWM_NE.rwi)

##plot chronology
plot(TWMCrn_NE, add.spline=TRUE, nyrs=30)

## residual chronology
TWMCrnResid <- chron(TWM_NE.rwi, prewhiten = TRUE)

#plot residual chronology
plot(TWMCrnResid)

## cutting off chrnology at sample depth >4
TWMCrnTrunc <- subset(TWMCrn_NE, samp.depth > 4)
plot(TWMCrnTrunc,add.spline=T,nyrs=30)

# ARSTAN chrnology
TWMarsCrn_NE <- chron.ars(TWM_NE.rwi)
plot(TWMarsCrn_NE, add.spline=TRUE, nyrs=30)
