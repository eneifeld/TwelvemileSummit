# TwelvemileSummit
Tree-ring analyses of Twelvemile Summit, Alaska

Spring 2023
Ellie Neifeld
eneifeld@arizona.edu

#### The best scripts are HighFreqAugustPrecip.R and Quantiles.R. Earlier scripts are a bit more chaotic

Order in which scripts were written:
1.	Precip_2_csv.R
  •	 Extracts the precipitation data for the Twlevemile summit gridpoint from the CRU netcdf file and writes the info to a csv. The same was done for temperature.
2.	Moving_cor.R
•	Moving correlations with different window widths between Signal-free detrended chronology and June temperature, August precipitation, and August PDSI. Also finds the standard deviation to compare to Gershunov et al. (2001) and plots the correlation coefficients
3.	Making_residual_chronology.R
•	Detrends the raw ring widths with a 0.67 spline and then outputs the residual chronology
•	High-pass filters June temperature and August precipitation data
4.	Zscore_residual.R
•	Finds the zscore of high-pass filtered June temperature and the residual chronology in order to plot on same graph
5.	HighFrequencyCorrelations.R
•	Moving window correlations of high-pass filtered June temperature data and the residual chronology. Also gets the zscores and plots the zscores.
•	Sets up data to plot in ggplot
6.	HighFreqAugustPrecip.R
•	Moving window correlations of high-pass filtered June temperature data and the residual chronology. Gets zscores and plots.
7.	Quantiles.R
•	Finds the quantiles of actual (non-filtered) June temperature data. 
•	Finds the years associated with these quantiles
•	Correlates the residual chronology and June Temperature for each quantile and makes a bar plot
•	Does the same for the signal-free chronology and the spline-detrended chronology
•	Makes a scatterplot to investigate whether there is a temperature threshold.
