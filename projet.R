#Chargement des librairies 
library(ggplot2)
library(forecast)
library(tseries)
library(smooth)
library(ggplot2)
library(zoo)

#Pré-traitement --------------------------------------------------------
#Chargement des données
day.data <- read.csv("data/day.csv")

#Attach les données
attach(day.data)
View(day.data)

#	Plot the cnt vs dteday and examine its patterns and irregularities
plot(cnt ~ dteday)

#Clean up any outliers or missing values if needed (tsclean() is a convenient method for outlier removal and inputting missing values)
ts.cnt <- ts(cnt)
ts.cnt <- tsclean(ts.cnt)
plot(ts.cnt)

#Use moving average to smooth the time serie (try with 7 and 30)
#jcroi faut faire SMA()
ma.7 <- rollmean(ts.cnt, 7)
ma.30 <- rollmean(ts.cnt, 30)

#plot the time series and the two smoothed curves
lines(ma.7, col = 'red', type = 'l')
lines(ma.30, col = 'blue', type = 'l')

#-------------------------------------------------------------------------

#1) Now we will be using the smoothed time series with order 7 that we will name hereafter cnt_ma
#Faut faire un bail de smooth
cnt_ma <- ma.7

#Transform cnt_ma into a time series with frequency 30 named count_ma
count_ma <- ts(cnt_ma, frequency = 30)
plot(count_ma)
acf(count_ma)
pacf(count_ma)

#Does the series count_ma appear to have trends or seasonality? oui tendance oui saison
count_ma.components <- decompose(count_ma)
plot(count_ma.components)

#Create a time series deseasonal_cnt by removing the seasonal component 
deseasonal_cnt <- count_ma - count_ma.components$seasonal
par(mfrow=c(2,1))
plot.ts(deseasonal_cnt,main = "cnt ts seasonal adjusted")
plot.ts(count_ma, main = "normal ts")
par(mfrow=c(1,1))

#Plot alternatif
plot.ts(deseasonal_cnt, col = 'blue')
lines(count_ma, col = 'red')

#2) Stationarity ------------------------------------------------------------------------------------

#Is the serie count_ma stationary?
#La série n'est pas stationnaire du fait qu'il y ai une saisonalité et une tendance

plot(count_ma.components)

#Use adf.test(), ACF, PACF plots to determine order of differencing needed
adf.test(count_ma) #La p-value est supérieur à 0.5 donc on rejette le test c'est à dire que la ts n'est pas stationnaire
acf()
plot(count_ma)
count_ma.withoutTrend <- diff(count_ma,differences = 1) #Ordre optimal de différenciation
plot(count_ma.withoutTrend)

acf(count_ma.withoutTrend) #Deviens nul à partir de 2
pacf(count_ma.withoutTrend) #7 barre qui dépasse de la zone on compte pas la 1ere barre

#Modele MA se base sur pacf compter le nb de baton qui dépasse
#Modele AR se base sur ACF indiquer la position du 1er baton qui dépasse

adf.test(count_ma.withoutTrend,alternative = "stationary")

#3) Autocorrelations and choosing model order--------------------------------------------------------

#Choose order of the ARIMA by examining ACF and PACF plots of count_ma

count_ma.AR <- arima(count_ma,order = c(2,1,0))
count_ma.AR$aic #9444.884

count_ma.ARresidual <- count_ma.AR$residuals
plot(count_ma.ARresidual)
abline(0,0,col="red")

count_ma.MA <- arima(count_ma,order = c(0,1,9))
count_ma.MA$aic #9046.192

count_ma.MAresidual <- count_ma.MA$residuals
acf(count_ma.MA$residuals)
plot(count_ma.MAresidual)
abline(0,0,col="red")

count_ma.ARMA <- arima(count_ma,order = c(2,1,9))
count_ma.ARMA$aic #9046.563

auto.count_ma <- auto.arima(count_ma)
auto.count_ma #Auto est flingué car il ns propose un modèle moins performant que le notre en cherchant nous
#même les paramètres

#On choisi le modèle avec le AIC le moins élévé donc MA

#Does deseasonal_cnt have a trend?
plot(deseasonal_cnt)
deseasonal_cnt.components <- decompose(deseasonal_cnt)
plot(deseasonal_cnt.components) #POur moi il y a pas de tendance

#Use diff() function on deseasonal_cnt and plot the resulting ts? Is it stationary? (ACF, PACF, adf test)
deseasonal_cnt.withoutTrend <- diff(deseasonal_cnt)
plot(deseasonal_cnt.withoutTrend)

acf(deseasonal_cnt.withoutTrend) #2eme position
pacf(deseasonal_cnt.withoutTrend) #10 qui dépasse
adf.test(deseasonal_cnt.withoutTrend) #p value inférieur à 5% donc on accepte l'hypothèse H0 que la ts est stationnaire

#What is your conclusion?

#4) Fit an ARIMA model
#Use auto.arima() function to fit an ARIMA model of deseasonal_cnt (with option 'seasonal=FALSE')
auto.arima(deseasonal_cnt,seasonal = FALSE)

#Check residuals. If there are visible patterns or bias, plot ACF/PACF. Are any additional order parameters needed?

