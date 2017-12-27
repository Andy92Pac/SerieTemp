#Chargement des librairies 
library(ggplot2)
library(forecast)
library(tseries)
library(smooth)

#Pré-traitement --------------------------------------------------------
#Chargement des données
day.data <- read.csv("data/day.csv")

#Attach les données
attach(day.data)
View(day.data)

#	Plot the cnt vs dteday and examine its patterns and irregularities
plot(cnt ~ dteday)

#Clean up any outliers or missing values if needed (tsclean() is a convenient method for outlier removal and inputting missing values)


#Use moving average to smooth the time serie (try with 7 and 30)
#jcroi faut faire SMA()

#plot the time series and the two smoothed curves

#Time series
cnt_ma <- ts(cnt)
plot(cnt_ma)

#-------------------------------------------------------------------------

#1) Now we will be using the smoothed time series with order 7 that we will name hereafter cnt_ma
#Faut faire un bail de smooth


#Transform cnt_ma into a time series with frequency 30 named count_ma
count_ma <- ts(cnt,frequency = 30)
plot(count_ma)

#Does the series count_ma appear to have trends or seasonality? oui 

#Create a time series deseasonal_cnt by removing the seasonal component 
count_ma.decomp <- decompose(count_ma)
plot(count_ma.decomp)

deseasonal_cnt <- tsdisplay(count_ma)


