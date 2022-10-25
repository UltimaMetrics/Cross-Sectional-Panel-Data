
clear
capture log close
set more off
//cd "C:\Users\fuouy\Dropbox\Teaching\UQ\ECON3370 Panel Data and Discrete Variables\Week 11 Ordered\tutorial11"
cd "D:\UQ\2019 S2\ECON7371 Panel Data\Tute\tutorial11\tutorial11"
log using mytutorial11.log, replace 

** (a) **
use RHIE, clear
keep if year == 2

gen hlthstat = 1 if hlthp == 1 | hlthf == 1
replace hlthstat = 2 if hlthg == 1
replace hlthstat = 3 if 1 - hlthp - hlthf - hlthg == 1
label define hsvalue 1 "poor or fair" 2 "good" 3 "excellent"
lab var hlthstat hsvalue //assign the label definition to the variable
tabulate hlthstat

** (b) **
sum hlthstat age linc ndisease 

** (c) **
ologit hlthstat age linc ndisease, nolog 
test /cut1 = /cut2

** (d) **
//predicted probability
predict p1ologit p2ologit p3ologit, pr
//generate new varibales to calculate the sample prob. later
gen poor_fair = hlthstat == 1
gen good = hlthstat == 2
gen excellent = hlthstat == 3
//compare sample prob. and average predicted prob
sum poor_fair p1ologit
sum good p2ologit
sum excellent p3ologit

** (e) **
margins, dydx(*) atmeans //PEA
margins, dydx(*) //APE

** (f) **
oprobit hlthstat age linc ndisease, nolog 
test /cut1 = /cut2

predict p1probit p2probit p3probit, pr
sum poor_fair p1probit
sum good p2probit
sum excellent p3probit

margins, dydx(*) atmeans
margins, dydx(*) 

log close

