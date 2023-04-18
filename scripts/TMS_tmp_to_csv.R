# Correlating TWM with climate data
#Ellie Neifeld
# 2023-02-24

#Import chronology
crn <- read.csv("data/ssfCrn_spline.csv")

library("ncdf4")
library("raster")

#Import climate data
cru_data <- brick('data/cru_ts4.06.1901.2021.tmp.dat.nc')
#Crop the NetCdf as a raster to focus on the place of interest (in this case NWNA)
cru <- crop(cru_data, extent(-180, -100, 50, 75))

writeRaster(cru, "rstack.nc", overwrite=TRUE, format="CDF",     varname="tmp", varunit="degC", 
            longname="Temperature -- raster stack to netCDF", xname="lon",   yname="lat", zname="Time (Month)")

plot(cru)
