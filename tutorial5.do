
clear
capture log close
set more off
//cd "C:\Users\fuouy\Dropbox\Teaching\UQ\ECON3370 Panel Data and Discrete Variables\Week 5\tutorial 5"

cd "E:\UQ\2019 S2\ECON7371 Panel Data\Tute\Tute5\tutorial5\tutorial5"

log using tutorial5my.log, replace

** Q1 **
use CORNWELL, clear
des
capture eststo clear

** (a) **
xtset county year 
forvalues t = 82/87 {
gen y`t' = year == `t'
}
eststo: reg lcrmrte lpolpc lprbarr lprbconv lprbpris lavgsen y8*, vce(cluster county) 
predict vhat, res

reg vhat L1.vhat //can try robust se
reg lcrmrte lpolpc lprbarr lprbconv lprbpris lavgsen y8* L1.vhat, vce(cluster county)

//post pic of testing for serial autocorelation

** (b) **
eststo: reg lcrmrte lpolpc lprbarr lprbconv lprbpris lavgsen lw* y8*, vce(cluster county)
test lwcon lwtuc lwtrd lwfir lwser lwmfg lwfed lwsta lwloc
//for each,look at p values, somme of them are significant
//however, as a whole, joint test is significant

** (c) **
//Hausman test
//first run random effect model
eststo: xtreg lcrmrte lpolpc lprbarr lprbconv lprbpris lavgsen lw* y8*, re vce(cluster county)
ssc install xtoverid
xtoverid

*xtoverid is used on a test of overidentifying restrictions (orthogonality conditions) 
//for a panel data estimation after xtreg, xtivreg, xtivreg2, or xthtaylor.
*xtoverid conducts a test on whether the excluded instruments are valid IVs or not (i.e.,

//then we run fixed effect model
eststo: xtreg lcrmrte lpolpc lprbarr lprbconv lprbpris lavgsen lw* y8*, fe vce(cluster county)

esttab, not se title("Question 1") 
esttab using table1.tex, not se replace title("Question 1") 
//first colons are pols, third colon is re, fourth colon is fe
//overall, we prefer fe over re


** (d) **
reg D.(lcrmrte lpolpc lprbarr lprbconv lprbpris lavgsen lw* y8*), vce(cluster county) noconstant
predict ehat, res


*(e)
reg ehat L.ehat


** Q2 **
use MURDER, clear
des
gen t = year == 87
replace t = 2 if year == 90
replace t = 3 if year == 93
xtset id t
capture eststo clear

** (a) **
gen y87 = year == 87
gen y90 = year == 90
gen y93 = year == 93

reg D.(mrdrte exec unem y90 y93), vce(cluster id) noconstant
predict ehat, res
reg ehat L1.ehat

** (b) **
eststo: xtreg mrdrte exec unem y90 y93, re vce(cluster id) 
xtoverid
eststo: xtreg mrdrte exec unem y90 y93, fe vce(cluster id) 

esttab, not se title("Question 2") 
esttab using table2.tex, not se replace title("Question 2") 

log close
