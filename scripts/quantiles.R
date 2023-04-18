# quantiles

#read in data
tmp <- read.csv("data/TMS_tmp.csv")

#get rid of first column
tmp <- subset(tmp, select=-c(1))

#name columns
#assign column names for the dataset
colnames(tmp) <- c("Year","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sept","Oct","Nov","Dec")

#pull out June temperature in a dataframe with years
Jun <- data.frame(Year=tmp[,'Year'], Jun=tmp[,'Jun'])

#Get the quantiles of june temperature data
Q <- quantile(Jun[,'Jun'])
print(Q)

# 25th: 10.0, 50th: 10.9, 75th: 11.7

#warmest temps are above 75th percentile which is the 4th index in quantiles
warmest <- Jun[,'Jun']>Q[4]

#warm temps are between 50th and 75th percentile
warm <- Jun[,'Jun']>=Q[3] & Jun[,'Jun']<=Q[4]

#cold temps are between 25th and 75th percentile
cold <- Jun[,'Jun']>=Q[2] & Jun[,'Jun']<=Q[3]

#coldest temps are below 25th percentile
coldest <- Jun[,'Jun']<Q[2]

#values with coldest temps
Jun[,'Jun'][coldest]

#years with coldest temps
ColdestYears <- Jun[,'Year'][coldest]

#years with cold temps
ColdYears <- Jun[,'Year'][cold]

#warm years
WarmYears <- Jun[,'Year'][warm]

#warmest years
WarmestYears <- Jun[,'Year'][warmest]

#pull out the indicies of the coldest and warmest years
#make a vector of the indicies
r <- c(1:121)
#pull out the indicies of the years corresponding to the True/False of the coldest, warmest, etc
coldestIdx <- r[coldest]
coldIdx <- r[cold]
warmIdx <- r[warm]
warmestIdx <- r[warmest]

#make dataframes with the coldest and warmest years and actual temps
coldest_df <- Jun[coldestIdx,]
cold_df <- Jun[coldIdx,]
warm_df <- Jun[warmIdx,]
warmest_df <- Jun[warmestIdx,]

#read in residual chronology
res_crn <- read.csv("data/residual_chron.csv")

#crop residual chronology to 1901-2021 and put in its own dataframe with years
res <- data.frame(Years=res_crn[219:339,"X"], ResidualCrn=res_crn[219:339,"res"])

#add a column for the years of the residual chronology with the indices of the coldest/warmest etc
coldest_df$ResidualCrn <- res[coldestIdx,"ResidualCrn"]
cold_df$ResidualCrn <- res[coldIdx,"ResidualCrn"]
warm_df$ResidualCrn <- res[warmIdx,"ResidualCrn"]
warmest_df$ResidualCrn <- res[warmestIdx,"ResidualCrn"]

#correlation the June tempreature and residual chronology
coldest_cor <- cor(x=coldest_df[,"Jun"], y=coldest_df[,"ResidualCrn"])
# result = 0.43

cold_cor <- cor(x=cold_df[,"Jun"], y=cold_df[,"ResidualCrn"])
# result = 0.12

warm_cor <- cor(x=warm_df[,"Jun"], y=warm_df[,"ResidualCrn"])
#result = -0.36

warmest_cor <- cor(x=warmest_df[,"Jun"], y=warmest_df[,"ResidualCrn"])
#result = -0.0937

#make a dataframe with the correaltions
cor_plot <- data.frame(Name = c("Coldest", "Cold", "Warm", "Warmest"),
                       Value= c(coldest_cor, cold_cor, warm_cor, warmest_cor))

#put correlations into a vector
cor <- c(coldest_cor, cold_cor, warm_cor, warmest_cor)

#plot in bar plot
barplot(cor)

library(RColorBrewer)
coul <- brewer.pal(4, "Dark2") 
barplot(height=cor_plot$Value, names=cor_plot$Name, col=coul, ylab="Correlation Coefficient",
        main="Correlation of Quantiles, residual chronology and June temperatures")



###### Now do the same correlations with the ssf spline chronology instead of the residual chronology
#read in chronology
ssf_crn <- read.csv("data/ssfCrn_spline.csv")

#crop residual chronology to 1901-2021 and put in its own dataframe with years
sf <- data.frame(Years=ssf_crn[219:339,"X"], ssfCrn=ssf_crn[219:339,"sfc"])

#add a column for the years of the residual chronology with the indices of the coldest/warmest etc
coldest_df$ssfCrn <- sf[coldestIdx,"ssfCrn"]
cold_df$ssfCrn <- sf[coldIdx,"ssfCrn"]
warm_df$ssfCrn <- sf[warmIdx,"ssfCrn"]
warmest_df$ssfCrn <- sf[warmestIdx,"ssfCrn"]

#correlation the June temperature and residual chronology
coldest_cor_sf <- cor(x=coldest_df[,"Jun"], y=coldest_df[,"ssfCrn"])
# result = 0.29

cold_cor_sf <- cor(x=cold_df[,"Jun"], y=cold_df[,"ssfCrn"])
# result = -0.09

warm_cor_sf <- cor(x=warm_df[,"Jun"], y=warm_df[,"ssfCrn"])
#result = -0.039

warmest_cor_sf <- cor(x=warmest_df[,"Jun"], y=warmest_df[,"ssfCrn"])
#result = 0.04

#make a dataframe with the correaltions
cor_plot_sf <- data.frame(Name = c("Coldest", "Cold", "Warm", "Warmest"),
                       Value= c(coldest_cor_sf, cold_cor_sf, warm_cor_sf, warmest_cor_sf))

library(RColorBrewer)
coul <- brewer.pal(4, "Dark2") 
barplot(height=cor_plot_sf$Value, names=cor_plot_sf$Name, col=coul, ylab="Correlation Coefficient",
        main="Correlation of Quantiles, Signal-Free Chronology and June temperatures")



####### now do the same thing with the spline-detrended chronology, not the ssf chronology
#crop residual chronology to 1901-2021 and put in its own dataframe with years
std <- data.frame(Years=res_crn[219:339,"X"], stdCrn=res_crn[219:339,"std"])

#add a column for the years of the residual chronology with the indices of the coldest/warmest etc
coldest_df$stdCrn <- std[coldestIdx,"stdCrn"]
cold_df$stdCrn <- std[coldIdx,"stdCrn"]
warm_df$stdCrn <- std[warmIdx,"stdCrn"]
warmest_df$stdCrn <- std[warmestIdx,"stdCrn"]

#correlation the June tempreature and residual chronology
coldest_cor_std <- cor(x=coldest_df[,"Jun"], y=coldest_df[,"stdCrn"])
# result = 0.36

cold_cor_std <- cor(x=cold_df[,"Jun"], y=cold_df[,"stdCrn"])
# result = -0.06

warm_cor_std <- cor(x=warm_df[,"Jun"], y=warm_df[,"stdCrn"])
#result = -0.2169

warmest_cor_std <- cor(x=warmest_df[,"Jun"], y=warmest_df[,"stdCrn"])
#result = 0.0698

#make a dataframe with the correaltions
cor_plot_std <- data.frame(Name = c("Coldest", "Cold", "Warm", "Warmest"),
                       Value= c(coldest_cor_std, cold_cor_std, warm_cor_std, warmest_cor_std))


library(RColorBrewer)
coul <- brewer.pal(4, "Dark2") 
barplot(height=cor_plot_std$Value, names=cor_plot_std$Name, col=coul, ylab="Correlation Coefficient",
        main="Correlation of Quantiles, standard spline detrended chronology and June temperatures")



###### make a scatterplot of RWI versus june temperatures to see if there is a "threshold"
plot(x=Jun[,'Jun'], y=res[,"ResidualCrn"], ylab="RWI", xlab="June Temperature", main="Residual Chronology and June Temperature")
plot(x=Jun[,'Jun'], y=res_crn[219:339,"std"], ylab="RWI", xlab="June Temperature", main="Standard spline-detrended chronology and June Temperature")
plot(x=Jun[,'Jun'], y=sf[,"ssfCrn"], ylab="RWI", xlab="June Temperature", main="Signal-free spline Chronology and June Temperature")
#I'm not seeing a clear threshold. Looks like a mess mostly


##### correlate signal free chronology and regular june T over full period
full <- cor(sf[,"ssfCrn"], Jun[,"Jun"])
# result = 0.15279
