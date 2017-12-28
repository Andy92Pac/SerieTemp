#Chargement des librairies 
library(ggplot2)
library(forecast)
library(tseries)
library(smooth)
library(ggplot2)

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

#Does the series count_ma appear to have trends or seasonality? oui tendance oui saison

#Create a time series deseasonal_cnt by removing the seasonal component 
count_ma.components <- decompose(count_ma)
plot(count_ma.components)

deseasonal_cnt <- count_ma - count_ma.components$seasonal
par(mfrow=c(2,1))
plot.ts(deseasonal_cnt,main = "cnt ts seasonal adjusted")
plot.ts(count_ma, main = "normal ts")
par(mfrow=c(1,1))

#2) Stationarity ------------------------------------------------------------------------------------

#Is the serie count_ma stationary?
#La série n'est pas stationnaire du fait qu'il y ai une saisonalité et une tendance

plot(count_ma.components)

#Use adf.test(), ACF, PACF plots to determine order of differencing needed
adf.test(count_ma) #La p-value est supérieur à 0.5 donc on rejette le test c'est à dire que la ts n'est pas stationnaire

count_ma.withoutTrend <- diff(count_ma)
plot(count_ma.withoutTrend)

acf(count_ma.withoutTrend) #2eme
pacf(count_ma.withoutTrend) #8 au total

#Modele MA se base sur pacf compter le nb de baton qui dépasse
#Modele AR se base sur ACF indiquer la position du 1er baton qui dépasse


#3) Autocorrelations and choosing model order--------------------------------------------------------

#Choose order of the ARIMA by examining ACF and PACF plots of count_ma

count_ma.AR <- arima(count_ma.withoutTrend,order = c(2,1,0))
count_ma.AR$aic #12518.18

count_ma.ARresidual <- count_ma.AR$residuals
plot(count_ma.ARresidual)
abline(0,0,col="red")

count_ma.MA <- arima(count_ma.withoutTrend,order = c(0,1,8))
count_ma.MA$aic #12041.75

count_ma.MAresidual <- count_ma.MA$residuals
plot(count_ma.MAresidual)
abline(0,0,col="red")

count_ma.ARMA <- arima(count_ma.withoutTrend,order = c(2,1,8))
count_ma.ARMA$aic #12044.5

auto.count_ma <- auto.arima(count_ma.withoutTrend)
auto.count_ma #Auto est flingué car il ns propose un modèle moins performant que le notre en cherchant nous
#même les paramètres

#On choisi le modèle avec le AIC le moins élévé donc MA

#Does deseasonal_cnt have a trend?
plot(deseasonal_cnt)
deseasonal_cnt.components <- decompose(deseasonal_cnt)
plot(deseasonal_cnt.components) #POur moi il y a pas de tendance