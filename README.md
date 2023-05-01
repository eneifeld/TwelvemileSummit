# TwelvemileSummit
Tree-ring analyses of Twelvemile Summit, Alaska

Spring 2023
Ellie Neifeld
eneifeld@arizona.edu

These tree-ring data were collected in summer 2022 and span 1601CE-2021CE. The chronology was truncated at >4 cores, at 1683CE.
These analyses attempt to investigate the relationship between climate and Tree-ring width at this site.

#### The best scripts are HighFreqAugustPrecip.R and Quantiles.R. Earlier scripts are a bit more chaotic

Approximate order in which scripts were written + descriptions:

1.	DetrendingTWM.R
•	Early detrending explorations
2.	CompareChron.R
•	Comparing detrending methods using ratios vs. residuals
3.	SignalFreeTWM.R
•	Detrending with signal-free method
4.	SF_TWM_TMS.R
•	Signal-free detrending by walking through Andy Bunn’s Simple Signal Free tutorial on Learning to Love dplR
5.	Precip_2_csv.R
•	Extracts the precipitation data for the Twlevemile summit gridpoint from the CRU netcdf file and writes the info to a csv. The same was done for temperature.
6.	Moving_cor.R
•	Moving correlations with different window widths between Signal-free detrended chronology and June temperature, August precipitation, and August PDSI. Also finds the standard deviation to compare to Gershunov et al. (2001) and plots the correlation coefficients
7.	Making_residual_chronology.R
•	Detrends the raw ring widths with a 0.67 spline and then outputs the residual chronology
•	High-pass filters June temperature and August precipitation data
8.	Zscore_residual.R
•	Finds the zscore of high-pass filtered June temperature and the residual chronology in order to plot on same graph
9.	HighFrequencyCorrelations.R
•	Moving window correlations of high-pass filtered June temperature data and the residual chronology. Also gets the zscores and plots the zscores.
•	Sets up data to plot in ggplot
10.	HighFreqAugustPrecip.R
•	Moving window correlations of high-pass filtered June temperature data and the residual chronology. Gets zscores and plots.
11.	Quantiles.R
•	Finds the quantiles of actual (non-filtered) June temperature data. 
•	Finds the years associated with these quantiles
•	Correlates the residual chronology and June Temperature for each quantile and makes a bar plot
•	Does the same for the signal-free chronology and the spline-detrended chronology
•	Makes a scatterplot to investigate whether there is a temperature threshold.
12.	Figures_for_paper.R
•	Makes the figures for the final assignment in a more concise way
13.	Running_Correlation_Exercise.R
•	Example script I wrote for Dendro Workshop class for how to do a running correlation
14.	Basic_ARIMA_script_example.R
•	Using Twelvemile data for ARIMA modelling exercise
