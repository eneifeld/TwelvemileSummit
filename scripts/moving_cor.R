#running correlations
#Ellie Neifeld
#2023-03-20

tmp_union <- read.csv("data/tmp_union.csv")
#get rid of first column
tmp_union <- tmp_union[,-1]

#now I want to do a rolling correlation of the 2nd column (chronology) with the 4:17 columns (months and seasons)
#mcor <- rollapply(tmp_union[219:339,"Chronology"], width=11, FUN=cor(tmp_union[219:339,"Chronology"], tmp_union[219:339,4:17]), by.column=TRUE)

#(x=tmp_union[219:339,"Chronology"] use="pairwise.complete.obs")


##all that not working

#try something else
library(RolWinMulCor)

#make the stupid 3 column dataset
Jun_crn <- data.frame(Year=tmp_union[219:339,"Year"], Chronology=tmp_union[219:339,"Chronology"], Jun=tmp_union[219:339,"Jun"])
#make a csv of this data
write.csv(Jun_crn, "data/JunT_moving_cor.csv", row.names = FALSE)

#this worked
rolcor <- rolwincor_1win(Jun_crn, varX="Chronology", varY="Jun", CorMethod="pearson", widthwin=11, Align="center", pvalcorectmethod="BH", rmltrd=TRUE, Scale=TRUE)
#rmltrd=True means remove linear trend. not sure if I want this
plot(rolcor[["Correlation_coefficients"]], type="l", main="June Temperature 11-yr moving correlations")
plot(rolcor[["P_values_corrected"]], type="l", main="June Temperature 11-yr moving correlations")
plot(rolcor[["P_values_not_corrected"]], type="l", main="June Temperature 11-yr moving correlations")
sdrolcor <- sd(rolcor[["Correlation_coefficients"]][,2])
#standard deviation of the 11yr window june T is 0.29
#overall correlation of june T and chronology is 0.15
#according to Gershunov the rule of thumb for this level of correlation and this window width
#is that anything 0.22-0.38 is white noise, so this qualifies as white noise

#read in precip data
precip <- read.csv("data/precip.csv")
#get rid of first column
pre_union <- precip[,-1]

#make the stupid 3 column dataset
Aug_pre_crn <- data.frame(Year=pre_union[,"Year"], Chronology=pre_union[,"Chronology"], Aug=pre_union[,"Aug"])

rol_pre_Aug <- rolwincor_1win(Aug_pre_crn, varX="Chronology", varY="Aug", CorMethod="pearson", widthwin=11, Align="center", pvalcorectmethod="BH", rmltrd=TRUE, Scale=TRUE)
plot(rol_pre_Aug[["Correlation_coefficients"]], type="l", col="blue", main="August Precipitation 11-yr moving correlations")
lines(rolcor[["Correlation_coefficients"]], type="l", col="red")

plot(rolcor[["Correlation_coefficients"]], type="l", col="red", 
     main="11-yr moving correlations for June temperature (red) and August precipitation (blue)",
     xlab="year", ylab="correlation coefficient")
lines(rol_pre_Aug[["Correlation_coefficients"]], type="l", col="blue")

#standard deviation
sdAugP <- sd(rol_pre_Aug[["Correlation_coefficients"]][,2])
#sd is 0.265
#overall correlation with Aug P is 0.2
# Gershunov says for an 11yr window 0.22-0.38 is white noise, so this is white noise

#make dataframe of june correlation coefficients
JuneT_data <- data.frame(rolcor[["Correlation_coefficients"]])
names <- c("year", "correlation")
colnames(JuneT_data) <- names

#make a dataframe of the august precip
AugP_data <- data.frame(rol_pre_Aug[["Correlation_coefficients"]])
colnames(AugP_data) <- names

#make plot data
JuneT_data$variable <- "June temperature"
AugP_data$variable <- "August precipiation"
AugPDSI_data$variable <- "August PDSI"
plotdata <- rbind(JuneT_data, AugP_data, AugPDSI_data)

#dataframe of just the precip and t data
PT_data <-rbind(JuneT_data, AugP_data)


#plot in ggplot
ggplot(data=plotdata, mapping=aes(x=year, y=correlation,
                                  color=variable, group=variable))+
  geom_line()+
  ggtitle('11-year moving window correlations')+
  xlab('Middle year of moving window')+
  ylab('Correlation coefficient')+
  scale_colour_manual(name=element_blank(),values =c('green4', 'blue', 'red'))

#plot just precip and t
ggplot(data=PT_data, mapping=aes(x=year, y=correlation,
                                  color=variable, group=variable))+
  geom_line()+
  ggtitle('11-year moving window correlations')+
  xlab('Middle year of moving window')+
  ylab('Correlation coefficient')+
  theme(text = element_text(size = 20))+
  scale_colour_manual(name=element_blank(),values =c('blue', 'red'))


#plot in ggplot
ggplot()+
  geom_line(data=JuneT_data, aes(year, correlation), color="red")+
  geom_line(data=AugP_data, aes(year, correlation), color="blue")+
  ggtitle('11-year moving window correlations')+
  xlab('Year')+
  ylab('Correlation coefficient')+
  scale_colour_manual(name=element_blank(),values =c('red'='red', 'blue'= 'blue'),
                    labels = c('June temperature','August precipitation'))
  

#now try without the linear trend removed
rolcorT_withtrend <- rolwincor_1win(Jun_crn, varX="Chronology", varY="Jun", CorMethod="pearson", widthwin=11, Align="center", pvalcorectmethod="BH", rmltrd=FALSE, Scale=TRUE)
#rmltrd=True means remove linear trend. not sure if I want this
plot(rolcorT_withtrend[["Correlation_coefficients"]], type="l", main="June Temperature 11-yr moving correlations")
#keeping the trend didn't change anything it seems


#try moving correlation with pdsi
#read in pdsi data
#import PDSI data
pdsi <- read.csv('data/TMS_pdsi.csv')
pdsi <- pdsi[,-1]
colnames(pdsi) <- c("Year", "Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sept","Oct","Nov","Dec")

#make the stupid 3 column dataset
Aug_pdsi_crn <- data.frame(Year=pdsi[,"Year"], Chronology=pre_union[,"Chronology"], Aug=pdsi[,"Aug"])

rol_pdsi_Aug <- rolwincor_1win(Aug_pdsi_crn, varX="Chronology", varY="Aug", CorMethod="pearson", widthwin=11, Align="center", pvalcorectmethod="BH", rmltrd=FALSE, Scale=TRUE)

#make dataframe
AugPDSI_data <- data.frame(rol_pdsi_Aug[["Correlation_coefficients"]])
colnames(AugPDSI_data) <- names

#plot on top of temp and precip
ggplot()+
  geom_line(data=JuneT_data, aes(year, correlation, color="red"))+
  geom_line(data=AugP_data, aes(year, correlation, color="blue"))+
  geom_line(data=AugPDSI_data, aes(year, correlation, color="green4"))+
  ggtitle('11-year moving window correlations')+
  xlab('Year')+
  ylab('Correlation coefficient')+
  scale_colour_manual(name=element_blank(),values =c('red'='red','blue'= 'blue', 'green4'='green4'),
                      labels = c('June temperature','August precipitation', 'August PDSI'))

#25-yr moving correlations June T
t_25 <- rolwincor_1win(Jun_crn, varX="Chronology", varY="Jun", CorMethod="pearson", widthwin=25, Align="center", pvalcorectmethod="BH", rmltrd=FALSE, Scale=TRUE)
plot(t_25[["Correlation_coefficients"]], type="l", main="June Temperature 25-yr moving correlations")

#standard deviation
sd_t25 <- sd(t_25[["Correlation_coefficients"]][,2])
#sd = 0.2
#Gershunov: for 25 yr window at overall correlation 0.15, 0.1-0.26 is white noise
#so this is white noise

#Precip 25 yr moving
p_25 <- rolwincor_1win(Aug_pre_crn, varX="Chronology", varY="Aug", CorMethod="pearson", widthwin=25, Align="center", pvalcorectmethod="BH", rmltrd=FALSE, Scale=TRUE)
plot(p_25[["Correlation_coefficients"]], type="l", col="blue", main="August Precipitation 25-yr moving correlations")
#standard deviation
sd_p25 <- sd(p_25[["Correlation_coefficients"]][,2])
#sd = 0.1155
#Gershunov: for 25 yr window at overall correlation 0.2, 0.11-0.25 is white noise
#so this is on the border--on the edge of being less variable than expected by chance

#PDSI 25 yr moving
pdsi_25 <- rolwincor_1win(Aug_pdsi_crn, varX="Chronology", varY="Aug", CorMethod="pearson", widthwin=25, Align="center", pvalcorectmethod="BH", rmltrd=FALSE, Scale=TRUE)

#make dataframes to plot                       
AugPDSI_25 <- data.frame(pdsi_25[["Correlation_coefficients"]])
colnames(AugPDSI_25) <- names


AugP_25 <- data.frame(p_25[["Correlation_coefficients"]])
colnames(AugP_25) <- names

JunT_25 <- data.frame(t_25[["Correlation_coefficients"]])
colnames(JunT_25) <- names

#add variable column
JunT_25$variable <- "June temperature"
AugP_25$variable <- "August precipiation"
AugPDSI_25$variable <- "August PDSI"

#combine P and T dataframes
plot_25_PT <- rbind(JunT_25, AugP_25)
#combine all 3 dataframes (including PDSI)
plot_25_all <- rbind(JunT_25, AugP_25, AugPDSI_25)

#Plot 25yr moving correlations with P and T
ggplot(data=plot_25_PT, mapping=aes(x=year, y=correlation,
                                    color=variable, group=variable))+
  geom_line()+
  ggtitle('25-year moving window correlations')+
  xlab('Middle year of moving window')+
  ylab('Correlation coefficient')+
  theme(text = element_text(size = 20))+
  scale_colour_manual(name=element_blank(),values =c('blue', 'red'))

#plot 25yr moving correlations with PDSI and P and T
ggplot(data=plot_25_all, mapping=aes(x=year, y=correlation,
                                  color=variable, group=variable))+
  geom_line()+
  ggtitle('25-year moving window correlations')+
  xlab('Middle year of moving window')+
  ylab('Correlation coefficient')+
  theme(text = element_text(size = 20))+
  scale_colour_manual(name=element_blank(),values =c('green4', 'blue', 'red'))

##### 49 yr window correlations
#49-yr moving correlations June T
t_49 <- rolwincor_1win(Jun_crn, varX="Chronology", varY="Jun", CorMethod="pearson", widthwin=49, pvalcorectmethod="BH", rmltrd=FALSE, Scale=TRUE)
plot(t_49[["Correlation_coefficients"]], type="l", main="June Temperature 49-yr moving correlations")
plot(t_49[["P_values_corrected"]], type="l", col="red", main="June Temperature 49-yr moving p values corrected")
plot(t_49[["P_values_not_corrected"]], type="l", col="red", main="June Temperature 49-yr moving p values not corrected")


#standard deviation
sd_t49 <- sd(t_49[["Correlation_coefficients"]][,2])
#sd = 0.185
#Gershunov's table doesn't go up to 49yr window

#Precip 49 yr moving
p_49 <- rolwincor_1win(Aug_pre_crn, varX="Chronology", varY="Aug", CorMethod="pearson", widthwin=49, Align="center", pvalcorectmethod="BH", rmltrd=FALSE, Scale=TRUE)
plot(p_49[["Correlation_coefficients"]], type="l", col="blue", main="August Precipitation 49-yr moving correlations")
plot(p_49[["P_values_corrected"]], type="l", col="blue", main="August Precipitation 49-yr moving correlations")
plot(p_49[["P_values_not_corrected"]], type="l", col="blue", main="August Precipitation 49-yr moving correlations")

#standard deviation
sd_p49 <- sd(p_49[["Correlation_coefficients"]][,2])
#sd = 0.07
#Gershunov's table doesn't go up to 49yr window

#PDSI 25 yr moving
pdsi_49 <- rolwincor_1win(Aug_pdsi_crn, varX="Chronology", varY="Aug", CorMethod="pearson", widthwin=49, Align="center", pvalcorectmethod="BH", rmltrd=FALSE, Scale=TRUE)
plot(pdsi_49[["Correlation_coefficients"]], type="l", col="blue", main="August PDSI 49-yr moving correlations")

#make dataframes to plot                       
AugPDSI_49 <- data.frame(pdsi_49[["Correlation_coefficients"]])
colnames(AugPDSI_49) <- names


AugP_49 <- data.frame(p_49[["Correlation_coefficients"]])
colnames(AugP_49) <- names

JunT_49 <- data.frame(t_49[["Correlation_coefficients"]])
colnames(JunT_49) <- names

#add variable column
JunT_49$variable <- "June temperature"
AugP_49$variable <- "August precipiation"
AugPDSI_49$variable <- "August PDSI"

#combine P and T dataframes
plot_49_PT <- rbind(JunT_49, AugP_49)
#combine all 3 dataframes (including PDSI)
plot_49_all <- rbind(JunT_49, AugP_49, AugPDSI_49)

#Plot 25yr moving correlations with P and T
ggplot(data=plot_49_PT, mapping=aes(x=year, y=correlation,
                                    color=variable, group=variable))+
  geom_line()+
  ggtitle('49-year moving window correlations')+
  xlab('Middle year of moving window')+
  ylab('Correlation coefficient')+
  theme(text = element_text(size = 20))+
  scale_colour_manual(name=element_blank(),values =c('blue', 'red'))

#plot 25yr moving correlations with PDSI and P and T
ggplot(data=plot_49_all, mapping=aes(x=year, y=correlation,
                                     color=variable, group=variable))+
  geom_line()+
  ggtitle('49-year moving window correlations')+
  xlab('Middle year of moving window')+
  ylab('Correlation coefficient')+
  scale_colour_manual(name=element_blank(),values =c('green4', 'blue', 'red'))
