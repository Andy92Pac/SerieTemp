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

dt.min <- min(as.Date.character(dteday,format = "%Y-%m-%d"))
dt.max <- max(as.Date.character(dteday,format = "%Y-%m-%d"))

data.frame(dt.min,dt.max,row.names = '')
#Cnt en fonction de Date du jour
plot(cnt ~ dteday)

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
deseasonal_cnt <- tsdisplay(cnt_ma)


