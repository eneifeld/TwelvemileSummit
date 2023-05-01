#Signal-Free detrending
library(dplR)
library(tidyverse)
library(cowplot)
library(ggExtra)
library(PNWColors)

TWM <- read.rwl("TWM.rwl")
dat <- TWM

# truncating sample depth to a minimum of 5 chronologies
sampDepth <- rowSums(!is.na(dat))
datTrunc <- dat[sampDepth > 4,]

#setting up variables
yrs <- time(datTrunc)
medianSegLength <- floor(median(rwl.stats(datTrunc)$year))
sampDepth <- rowSums(!is.na(datTrunc))
normalizedSampleDepth <- sqrt(sampDepth-1)/sqrt(max(sampDepth-1))

# get some color palettes from Jake L's PNWColors
seriesColors <- pnw_palette(name="Starfish",n=dim(datTrunc)[2])
divColors <- pnw_palette("Moth",5)

rawRW <- data.frame(yrs = yrs, datTrunc) %>% 
  pivot_longer(!yrs,names_to = "series", values_to = "msmt") 

##plotting the raw ring widths
#start writing to pdf
pdf(file="TWM_SFtest.pdf", useDingbats = FALSE)
ggplot(data=rawRW,mapping = aes(x=yrs,y=msmt,color=series)) +
  geom_line(alpha=0.5) +
  scale_color_manual(values = seriesColors) +
  labs(y="mm",x="Years",caption = "Raw Measurements") +
  theme_cowplot() +
  theme(legend.position = "none")
#stop writing to pdf
dev.off()

#simple SF chronology
ssfCrn <- ssf(rwl = datTrunc)

##plotting first version of sf
pdf(file="TWM_SF.pdf", useDingbats = FALSE)
plot(ssfCrn,add.spline=TRUE,nyrs=50,
     crn.line.col=divColors[3],spline.line.col=divColors[1],
     crn.lwd=1.5,spline.lwd=2)
dev.off()

## changing options, making sf2
ssfCrn2 <- ssf(rwl = datTrunc,method="Spline",nyrs=medianSegLength)

##plotting sf2
pdf(file="TWM_SF2.pdf", useDingbats = FALSE)
plot(ssfCrn2,add.spline=TRUE,nyrs=50,
     crn.line.col=divColors[3],spline.line.col=divColors[1],
     crn.lwd=1.5,spline.lwd=2)
dev.off()