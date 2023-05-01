# Running correlations script
# Dendro Workshop
# Ellie Neifeld
# 2023-03-30

# We want input data in a 3-column dataset with 
# 1st column: year
# 2nd column: chronology
# 3rd column: climate variable (temperature, precip, pdsi, etc)

# Here I am reading in my data- but I encourage you to use your own data in this 3 column form
Jun_moving <- read.csv("data/JunT_moving_cor.csv")

#install package that we will be using
#uncomment next line assuming you don't have this package installed
#install.packages("RolWinMulCor")

#load library
library(RolWinMulCor)

#Do the moving correlation with a 31-year window
# make sure that varX and varY have the column names fo your data
# window width must be an odd number for this function because we are aligning to the center year
# rmltrd means remove linear trend -- you decide if you want this
JunT_31 <- rolwincor_1win(Jun_moving, varX="Chronology", varY="Jun", 
                         CorMethod="pearson", widthwin=31, Align="center", 
                         pvalcorectmethod="BH", rmltrd=FALSE, Scale=TRUE)

# The output of this function includes p values so we want to pull out the 
# correlation coefficients and plot them
plot(JunT_31[["Correlation_coefficients"]], type="l", xlab="Middle year of window", 
     ylab="correlation coefficient",
     main="June Temperature 31-yr moving correlations")

# now let's get the standard deviation for this moving correlation
sd_Jun31 <- sd(JunT_31[["Correlation_coefficients"]][,2])

# What is the standard deviation?
# Compare to Gershunov Table 1 : Is the fact that there is a dip in the correlation unexpected?
# What CAN we learn from this running correlation, and what are it's limitations?


JunT_11 <- rolwincor_1win(Jun_moving, varX="Chronology", varY="Jun", 
                          CorMethod="pearson", widthwin=11, Align="center", 
                          pvalcorectmethod="BH", rmltrd=FALSE, Scale=TRUE)

# The output of this function includes p values so we want to pull out the 
# correlation coefficients and plot them
plot(JunT_11[["Correlation_coefficients"]], type="l", xlab="Middle year of window", 
     ylab="correlation coefficient",
     main="June Temperature 11-yr moving correlations")

JunT_31 <- rolwincor_1win(Jun_moving, varX="Chronology", varY="Jun", 
                          CorMethod="pearson", widthwin=31, Align="center", 
                          pvalcorectmethod="BH", rmltrd=TRUE, Scale=TRUE)

# The output of this function includes p values so we want to pull out the 
# correlation coefficients and plot them
plot(JunT_31[["Correlation_coefficients"]], type="l", xlab="Middle year of window", 
     ylab="correlation coefficient",
     main="June Temperature 31-yr moving correlations")
