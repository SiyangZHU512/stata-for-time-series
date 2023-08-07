import excel "D:\desktop\STATA\summer\time series\workbook2.xlsx", sheet("Sheet1") firstrow clear
tsset time
/*ARCH model*/
/*Whether to apply ARCH or GARCH */
varsoc AHE,maxlag(10)
/*method one*/
reg AHE L(1/2).AHE
estat archlm
/*method two*/ 
reg AHE L(1/2).AHE
predict AHEres,res
gen AHEressq=AHEres*AHEres
wntestq AHEressq
/*method three After estimating ARCH or GRACH, see whether the model parameters are significant or not.*/
varsoc AHEressq
arch AHE L(1/2).AHE,arch(1/4) nolog /*ARCH(4)*/ /*Focus on whether the regression coefficients of the residuals are significant */
arch AHE L(1/2).AHE,arch(1) garch(1) nolog /*GARCH(1,1)*/ /*GARCH model*/
arch AHE L(1/2).AHE,arch(1/4) garch(1) tarch(1) nolog /*GARCH + TARCH*/
arch AHE L(1/2).AHE,arch(1) archm nolog /*GARCH + TARCH-M*/
arch AHE L(1/2).AHE,earch(1) egarch(1) nolog /*EGARCH model*/
predict v,variance
line v time

/*normality test*/
kdensity AHE, normal
qui var AHE,lags(1/2)
varnorm
/* if normality is not obvious, then we may need to change the distribution when estimating ARCH**/


