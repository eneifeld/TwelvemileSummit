#
# Here are a few lines of code to explore generation of time-series based upon different
# ARIMA models, and to understand a bit better the resulting properties and characteristics
# of the time-series models.
#
# written by David Frank February 2023

#Load dplR package
require(dplR)

#Make a function called "plotredfit" to help us plot the redfit spectrum from dplR
#This is a very simple modification of code written by Andy Bunn and helps
# ease plotting later on.

plotredfit <- function(redf.x){ 
plot(redf.x[["freq"]], redf.x[["gxxc"]],
     ylim = range(redf.x[["ci99"]], redf.x[["gxxc"]]),
     type = "n", ylab = "Spectrum", xlab = "Frequency (1/yr)",
     axes = FALSE)
grid()
lines(redf.x[["freq"]], redf.x[["gxxc"]], col = "#1B9E77")
lines(redf.x[["freq"]], redf.x[["ci99"]], col = "#D95F02")
lines(redf.x[["freq"]], redf.x[["ci95"]], col = "#7570B3")
lines(redf.x[["freq"]], redf.x[["ci90"]], col = "#E7298A")
freqs <- pretty(redf.x[["freq"]])
pers <- round(1 / freqs, 2)
axis(1, at = freqs, labels = TRUE)
axis(3, at = freqs, labels = pers)
mtext(text = "Period (yr)", side = 3, line = 1.1)
axis(2); axis(4)
legend("topright", c("x", "CI99", "CI95", "CI90"), lwd = 2,
       col = c("#1B9E77", "#D95F02", "#7570B3", "#E7298A"),
       bg = "white")
   }    
       
       
       
# Generate an ARIMA model using the function arima.sim
# The below default code
ts.sim <- arima.sim(list(order = c(1,0,1),ar = 0.8,ma=0.0), n = 200)

# Plot the output
ts.plot(ts.sim)

# Look at the autocorrelation function
acf(ts.sim)

# Look at the partial autocorrelation function
pacf(ts.sim)

# Look at the spectral characteristics via a periodogram
spectrum(ts.sim)

# Compute the spectral characteristics using the dplR function redfit
# and look at the output via our shamelessly lifted (yet attributed) code
red.out <- redfit(ts.sim)
plotredfit(red.out)


# It is possible to specify the innovation/random shock/ error in arima.sim
# The below example simply creates a simple dataset for viewing/learning
# This can be easily modified to input your own data 
mydata <-c(1,0,1,1,1,2,30,0,1,2)
ts.sim2 <- arima.sim(list(order = c(1,0,0), ar = .5), innov=mydata,n=10)
ts.plot(ts.sim2)



#read in TWM signal free spline chronology
SFspline <- read.csv("data/ssfCrn_spline.csv")

#### test 1: ar 0.5, no ma
ts.sim3 <- arima.sim(list(order = c(1,0,0), ar= .5), innov = SFspline[,2], n=338)
ts.plot(ts.sim3)

# Look at the autocorrelation function
acf(ts.sim3)

# Look at the partial autocorrelation function
pacf(ts.sim3)

# Look at the spectral characteristics via a periodogram
spectrum(ts.sim3)

# Compute the spectral characteristics using the dplR function redfit
# and look at the output via our shamelessly lifted (yet attributed) code
red.out3 <- redfit(ts.sim3)
plotredfit(red.out3)


###test 2, ar=0.2, no ma
ts.sim4 <- arima.sim(list(order = c(1,0,0), ar= .2), innov = SFspline[,2], n=338)
ts.plot(ts.sim4)

# Look at the autocorrelation function
acf(ts.sim4)

# Look at the partial autocorrelation function
pacf(ts.sim4)

# Look at the spectral characteristics via a periodogram
spectrum(ts.sim4)

# Compute the spectral characteristics using the dplR function redfit
# and look at the output via our shamelessly lifted (yet attributed) code
red.out4 <- redfit(ts.sim4)
plotredfit(red.out4)



###test 3, ar=0.2, yes ma
ts.sim5 <- arima.sim(list(order = c(1,0,1), ar= .2, ma=0.3), innov = SFspline[,2], n=338)
ts.plot(ts.sim5)

# Look at the autocorrelation function
acf(ts.sim5)

# Look at the partial autocorrelation function
pacf(ts.sim5)

# Look at the spectral characteristics via a periodogram
spectrum(ts.sim5)

# Compute the spectral characteristics using the dplR function redfit
# and look at the output via our shamelessly lifted (yet attributed) code
red.out5 <- redfit(ts.sim5)
plotredfit(red.out5)




#trying out ARIMA without the simulation part
ts.sim4 <- arima(SFspline[,2], order=c(1,0,1))
ts.plot(ts.sim4$residuals)
lines(ts.sim3, col="red")

ts.sim5 <- arima.sim(ts.sim4$model, n=338)
ts.plot(ts.sim5)
lines(ts.sim3, col="red")







#
#
# EXERCISE and QUESTIONS
#
#
# Spend some time modifying and expanding upon the above code with different 
# AR, I, and MA models and terms. Change the data. Develop an applied understanding
# of how ARIMA times-series are generated. And so on. 
#
#
#
# How do your choices impact how the time-series look?
#ar=0.5 looks more smoothed in timeseries, ar=0.2 more jagged
#
# How do your choices impact the spectral characteristics?
#Ar=0.5 steep decrease in raw periodogram,  ar=0.2 less steep decrease
#more autocorrelation showing in the ar=0.2 model, broader spectra in ar=0.2 model
#
# Describe a key difference in the acf of a AR versus and MA model?
#
#
#


       