#Signal Free detrending of TWM_TMS.rwl
# 2023-02-01
# Ellie Neifeld
# Going through andy bunn's simple signal free tutorial with TWM_TMS data

library(dplR)
library(tidyverse)
library(cowplot)
library(ggExtra)
library(PNWColors)

TWM <- read.rwl('data/TWM_TMS.rwl')
dat <- TWM

sampDepth <- rowSums(!is.na(dat))
datTrunc <- dat[sampDepth > 4,]

yrs <- time(datTrunc)
medianSegLength <- floor(median(rwl.stats(datTrunc)$year))
sampDepth <- rowSums(!is.na(datTrunc))
normalizedSampleDepth <- sqrt(sampDepth-1)/sqrt(max(sampDepth-1))

# get some color palettes from Jake L's PNWColors
seriesColors <- pnw_palette(name="Starfish",n=dim(datTrunc)[2])
divColors <- pnw_palette("Moth",5)

rawRW <- data.frame(yrs = yrs, datTrunc) %>% 
  pivot_longer(!yrs,names_to = "series", values_to = "msmt") 

ggplot(data=rawRW,mapping = aes(x=yrs,y=msmt,color=series)) +
  geom_line(alpha=0.5) +
  scale_color_manual(values = seriesColors) +
  labs(y="mm",x="Years",caption = "Raw Measurements") +
  theme_cowplot() +
  theme(legend.position = "none")

#making the chronology, ues default of age-dependent spline for detrending
ssfCrn <- ssf(rwl = datTrunc)

#plot
plot(ssfCrn,add.spline=TRUE,nyrs=50,
     crn.line.col=divColors[3],spline.line.col=divColors[1],
     crn.lwd=1.5,spline.lwd=2)

#changing detrending method to spline, creating 2nd version of chronology
ssfCrn2 <- ssf(rwl = datTrunc,method="Spline",nyrs=medianSegLength)

plot(ssfCrn2,add.spline=TRUE,nyrs=50,
     crn.line.col=divColors[3],spline.line.col=divColors[1],
     crn.lwd=1.5,spline.lwd=2)
