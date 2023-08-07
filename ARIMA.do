import excel "D:\桌面\STATA\summer\time series\工作簿2.xlsx", sheet("Sheet1") firstrow clear
tsset time
/*stationary check*/
pperron AHE,lag(5) /*original assumption of non-stationary data**/
dfuller AHE,lag(5) /*unsurprisingly non-stationary**/
dfgls AHE, notrend maxlag(5) /*original assumption non-smooth*/

dfgls d.AHE,notrend maxlag(3)

/*model selection*/
ac d2.AHE /*for AR(q), which firstly decreases with increasing lag order, and secondly depends on which section it vanishes at */
pac d.AHE /*for MA(q) consistent with above**/
/*note if both autocorrelation and partial autocorrelation decrease with increasing lag --- ARMA(p,q)*/
/*note ARIMA(p,w,q) p stands for the number of lags of the regression variable itself, w stands for the order of the difference of the regression variable itself, and q stands for the number of lags of the disturbance term*/
arima AHE,arima(1,0,0) /*AR(p)*/
/* Comparisons are made using the AIC and BIC criteria, the smaller the better. */
estat ic
predict AHEres1,res
wntestq AHEres1,lags(10)
/* Comparison using predict i capability */
gen mse=AHEres1*AHEres1
sum mse /* look at the average can be, the smaller the better */
predict AHEhat1
arima AHE,arima(0,0,1)/*MA(q)*/
estat ic
predict AHEres2,res
wntestq AHEres2,lags(10)
predict AHEhat2
/*note If the ACF and PACF do not yield accurate results, the AIC and BIC criteria can be calculated using multiple operations for comparison*/.

arima AHE,arima(2,2,1)/*ARIMA vs ARMA Use ARIMA in non-stationary cases and ARMA in stationary cases*/
estat ic
predict AHEres4,res
wntestq AHEres4,lags(10)
predict AHEhat4
twoway line AHE time || line AHEhat1 time || line AHEhat2 time || line AHEhat4 time
