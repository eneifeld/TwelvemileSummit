# zscore of chronology and JunT on same graph
#Ellie Neifeld

tmp_crn <- read.csv("data/tmp_union.csv")
#remove first column
tmp_crn <- subset(tmp_crn, select = -X)


zscore_crn <- (tmp_crn[219:339,"Chronology"] - mean(tmp_crn[219:339,"Chronology"])) / sd(tmp_crn[219:339,"Chronology"])
zscore_Jun <- (tmp_crn[219:339,"Jun"] - mean(tmp_crn[219:339,"Jun"], na.rm=TRUE)) / sd(tmp_crn[219:339,"Jun"], na.rm = TRUE)

zscores <- data.frame(Years=Years, Chronology=zscore_crn, June=zscore_Jun)

#june temperatures
ggplot()+
  geom_line(data=zscores, aes(Years, Chronology, color='black'))+
  geom_line(data=zscores, aes(Years, June, color='red'))+
  ggtitle('Chronology and June temperature')+
  xlab('YEAR')+
  ylab('zscore')+
  theme(text = element_text(size = 20))+
  scale_colour_manual(name=element_blank(),values =c('black'='black','red'= 'red'),
                      labels = c('Chronology','June Temperature'))
