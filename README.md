# SerieTemp

		Examine your data
Data: https://archive.ics.uci.edu/ml/datasets/Bike+Sharing+Dataset 
Download the data set, and read the data set day.csv.
We will work on the daily variable names __cnt_ in the data set day.csv
	•	Plot the cnt vs dteday and examine its patterns and irregularities
	•	Clean up any outliers or missing values if needed (tsclean() is a convenient method for outlier removal and inputting missing values)
	•	Use moving average to smooth the time serie (try with 7 and 30)
	•	plot the time series and the two smoothed curves

library('ggplot2')
library('forecast')
library('tseries')
daily_data <- day <- read_delim("day.csv", delim=",")
ggplot(daily_data, aes(dteday, cnt)) + geom_line() + scale_x_date('month')  + xlab("")
count_ts = ts(daily_data[, c('cnt')])

	1) Now we will be using the smoothed time series with order 7, that we will name hereafter cnt_ma
		Transform cnt_ma into a time series with frequency 30 named count_ma
		Does the series count_ma appear to have trends or seasonality?
		Create a time series deseasonal_cnt by removing the seasonal component 

	2) Stationarity
	Is the serie count_ma stationary?
		Use adf.test(), ACF, PACF plots to determine order of differencing needed

	3) Autocorrelations and choosing model order
	Choose order of the ARIMA by examining ACF and PACF plots of count_ma
		Does deseasonal_cnt have a trend?
		Use diff() function on deseasonal_cnt and plot the resulting ts? Is it stationary? (ACF, PACF, adf test)
		What is your conclusion?


		4) Fit an ARIMA model
		Use auto.arima() function to fit an ARIMA model of deseasonal_cnt (with option 'seasonal=FALSE')
	Check residuals. If there are visible patterns or bias, plot ACF/PACF. Are any additional order parameters needed?
		Refit model if needed. Compare model errors and fit criteria such as AIC or BIC.
		Calculate forecast using the chosen model
		Plot both the original and the forecasted time series

		5) Forecasting
		Split the data into training and test times series (test starting at observation 700, use function window)
		fit an Arima model on the training part
		Forecast the next 25 observation and plot the original ts and the forecasted one. What do you observe?
		Use auto.arima() function to fit an ARIMA model of deseasonal_cnt (with option 'seasonal=TRUE')
		Forecast the next 25 observation and plot the original ts and the forecasted one. What do you observe?

