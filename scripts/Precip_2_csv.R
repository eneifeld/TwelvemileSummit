#Extracting precipitation data for the TWM gridpoint
# ELlie Neifeld
# 2023-02-26

library("ncdf4")
library("raster")

#Import climate data
cru_data <- brick('data/cru_ts4.06.1901.2021.pre.dat.nc')
#Crop the NetCdf as a raster to focus on the place of interest (in this case NWNA)
cru <- crop(cru_data, extent(-180, -100, 50, 75))

writeRaster(cru, "rstack.nc", overwrite=TRUE, format="CDF",     varname="pre", varunit="mm", 
            longname="Precipitation -- raster stack to netCDF", xname="lon",   yname="lat", zname="Time (Month)")

plot(cru)

#Load back in the NetCDF you saved as a NetCDF in R
ncin <- nc_open('rstack.nc')

#Note the lat / long
lon <- ncvar_get(ncin,"lon")
nlon <- dim(lon)
head(lon)

#assign lat and long and look at how many 
lat <- ncvar_get(ncin,"lat")
nlat <- dim(lat)
head(lat)

#Check the dimensions of the matrix 
print(c(nlon,nlat))

#Make this into an array (but, because it is just one slice, 
#this three-dimensional array will have just two dimensions like a matrix)  
ncin$var$pre

#This is where you have to customize the variable name. 
dname='pre'
# array of pre variable--very big
pre_array <- ncvar_get(ncin, dname)
#pulling out the variable in ncin called long_name
dlname <- ncatt_get(ncin,dname,"long_name")
# pulling out variable in ncin called units
dunits <- ncatt_get(ncin,dname,"units")
fillvalue <- ncatt_get(ncin,dname,"_FillValue")
#dimmensions of pre_array are 160(lon), 50(lat), 1452(months 1901-2021)
dim(pre_array)

library(chron)

# pull out from ncin the units of time, in this case "days since 1970-1-1"
tname="Time (Month)"
tunits<- ncatt_get(ncin, tname, "units")


#Label some things about the time series and make the array have the proper dates (in this case monthly) 
# pull out the calue of the units and separate them by a space so now there
# are 3 columns (1)days (2)since (3)1970-1-1
tustr <- strsplit(tunits$value, " ")
#from the 3rd column above, split by "-" so now there are 3 columns, (1)1970 (2)1 (3)1
tdstr <- strsplit(unlist(tustr)[3], "-")
#months are the 2nd column
tmonth <- as.integer(unlist(tdstr)[2])
#days are the 3rd column
tday <- as.integer(unlist(tdstr)[3])
# years are the 1st column
tyear <- as.integer(unlist(tdstr)[1])

#Label dates with the as.Date function
Start<-as.Date(unlist(tustr)[3])
NC_Date=seq.Date(from=Start, by='month' , length.out=dim(pre_array)[3])
as.Date(NC_Date)
#the problem now is that the dates go from 1970-2091 instead of 1901-2021

#Deal with the NA's
pre_array[tmp_array==fillvalue$value] <- NA
length(na.omit(as.vector(pre_array[,,1])))

#Choose the years you want to look at for the trend analysis...
Years=seq(1901,2021)
NROW(Years)
nmonths=NROW(Years)*12
dim(pre_array)

#Create a matrix that will organize the monthly data into year categories with 12 months in each...
Start=((min(Years)-1900)*12)-11
End=((max(Years)-1900)*12)

#create an empty matrix where the years are rows and there are 2 columns
x=matrix(nrow=NROW(Years), ncol=2)
#make a sequence from 1901-2021 by 12 so it looks like 1, 13, 25, 37, etc. this is the year column
xx= seq(from=Start, to=End, by=12)
# a sequence that starts in december 1901 and ends in december 2021. this is the month column?
xx2=  seq(from=Start+11, to=1452, by=12)
#into the x matrix put in the first column the sequence the 1, 13, 25 list, and in the second column put the 12, 24, 36 list
# so you have first month and last month for each year in the row
for (i in 1:NROW(x)){
  x[i,1]=xx[i]
  x[i,2]=xx2[i]
}

#Organize the array into a list with the first-order category as a year
#for each year in the sequence 1901-2021, put the tmp array, all lons, all lats, the january (first) month of that year
# and the december (last) month of that year
Yt_L=list()
for(i in 1:NROW(Years)){
  Yt_L[[i]] <- pre_array[,,x[i,1]:x[i,2]]
}

#Take a look at how these data are structured. 
NROW(Yt_L) #121 years
dim(Yt_L[[1]]) # In the first year there are 160lons, 50lats, 12months
dim(pre_array) # in full array there are 160lons, 50lats, 1452 months

#Make a 4 dimensional array. dim1: longitude, dim2: lat, dim3: year (row of matrix), 
#dim4:month (column of matrix). Also make the first column have the years. 
# i is longitude
# j is latitude
# k is year
# l is month
# creates a matrix where first column is years, and then next 12 columns are each month
# this is why there are 13 columns
#then there is a different matrix for each lat/lon

t=array(data=NA, dim=c(80, 25, 121,13))
for(i in 1:80){
  for(j in 1:25){
    for(k in 1:121){
      for (l in 1:12){
        t[i,j,k,l+1]=Yt_L[[k]][i, j , l]
        t[i,j,,1]=1901:2021
      }}}}

#the closest gridpoint for TWM is -145.75, 65.25, which is lon[69], lat[20]
#climate data at this point
t[69,20,,]

#write a csv for temperature data at TWM summit
TMS_pre <- write.csv(t[69,20,,], "data/TMS_pre.csv")
