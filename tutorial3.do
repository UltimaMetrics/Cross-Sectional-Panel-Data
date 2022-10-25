
clear
capture log close
set more off
//cd "/Users/uqfouyan/Dropbox/Teaching/UQ/ECON3370 Panel Data and Discrete Variables/Week 2/tutorial2"
cd "E:\UQ\2019 S2\ECON7371 Panel Data\Tute\Tute3\"

log using tutorial3myv.log, replace

use psidextract, clear
des
ssc install estout
** (a) **
xtset id t
label variable t "year"
xtline lwage if id <= 10, overlay leg(off) title("Time Series Plot of Log Hourly Wage against Year")
xtline wks if id <= 10, overlay leg(off) title("Time Series Plot of Weeks Worked against Year")

** (b) **
sort id t
forvalue k = 1(1)6 {
correlate lwage L`k'.lwage
}

** (c) **
quietly reg lwage ed wks exp exp2, vce(cluster id)
predict uhat, res

forvalue k = 1(1)6 {
correlate uhat L`k'.uhat
}

** (d) **
reg lwage ed wks exp exp2 L1.uhat, robust

//Ho:rho=0, H1:rho!=0 ; by looking at p -value we can reject the null, so there is seriall autocorrelation existed

** (e) **
reg lwage L1.lwage ed wks exp exp2, vce(cluster id) //contain one lag of lwage in regressor
predict ehat, res
reg lwage L1.lwage ed wks exp exp2 L1.ehat, robust

reg lwage L1.lwage L2.lwage L3.lwage L4.lwage ed wks exp exp2, vce(cluster id)
predict vhat, res
predict yhat, xb
reg lwage L1.lwage L2.lwage L3.lwage L4.lwage ed wks exp exp2 L1.vhat, robust //failed to reject the null, so after using four lags, seriall autocorrelation is killed

//Look up dynamic completeness definition: exogeneity (POLS3) and seriall auto(POLS5) are all satisfied. 

** (f) **
gen yhat2 = yhat^2 
gen vhat2 = vhat^2
reg vhat2 yhat yhat2 

dis 1785*0.0013
dis 1-chi2(2,1785*0.0013)

//we get p-value=0.31340782; so we do not reject the null, it is homo

//test statistics: 595*3*00013=2.321

//Note: the 3 here means because 4 lags were used to kill Serial auto, we use total 
//N=7 years minus 4 years of lag equal to 3 years, thus use 3 in that formula
//formula is : N*T*R^2 (could be on the test)
xtdes

//Ho: Homoskedastcity H1: Hetero


** (g) **
forvalue s = 2(1)7 {
correlate uhat L1.uhat if t == `s'
}

correlate uhat L1.uhat L2.uhat L3.uhat L4.uhat L5.uhat L6.uhat

esttab, r2 ar2 not se /*
*/title("POLS Estimation")

esttab using table1.tex, r2 ar2 not se replace /*
*/title("POLS Estimation")

//assumption in part B may not be satisified

log close
