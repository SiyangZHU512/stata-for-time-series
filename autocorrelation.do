import excel "D:\桌面\STATA\summer\time series\工作簿2.xlsx", sheet("Sheet1") firstrow clear
/*autocorrelation*/
tsset time
tsline AHE AGE
/*Image inspection*/
scatter AHE L.AHE
ac AHE,lags(10)
pac AHE,lags(10) yline(0) ciopts(bstyle(outline))
corrgram AHE,lags(10)
/*cross-cutting correlation*/
xcorr AHE AGE
xcorr AHE AGE, table
/*BG test* after regression*/
reg AHE AGE BACHELOR FEMALE
estat bgodfrey,lags(10)
/*Ljung-BOX Q test*/
reg AHE AGE BACHELOR FEMALE
predict Yhat
gen e=AHE-Yhat
wntestq e,lags(2)
/*Original assumption of no autocorrelation*/
/*DW-TEST*/
reg AHE AGE BACHELOR FEMALE
estat dwatson

/*deal with autocorrelation*/
newey AHE AGE BACHELOR FEMALE,lag(3) /* Robust standard error, note that if there are many years with no value then it is likely to report an error */
/*FGLS*/
prais AHE AGE BACHELOR FEMALE
prais AHE AGE BACHELOR FEMALE,corc