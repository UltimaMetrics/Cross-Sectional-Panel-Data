
clear
capture log close
set more off
//cd "C:\Users\fuouy\Dropbox\Teaching\UQ\ECON3370 Panel Data and Discrete Variables\Week 12 Count data\tutorial12"
cd "D:\UQ\2019 S2\ECON7371 Panel Data\Tute\tutorial11\tutorial11"
 
log using mytutorial12.log, replace

use RHIE, clear
xtset id year

** (a) **
*Over disperse implies Var>mean
xtsum mdu

** (b) **
gen MDU = mdu
replace MDU = 4 if mdu >= 4
xttrans MDU

** (c) **
poisson mdu lcoins ndisease female age lfam child, nolog 
poisson mdu lcoins ndisease female age lfam child, robust nolog
poisson mdu lcoins ndisease female age lfam child, vce(cluster id) nolog

** (d) **
forvalues y = 0/6 {
predict pcf`y', pr(`y')
gen scf`y' = mdu == `y'
sum pcf`y' scf`y'
}

** (e) **
xtpoisson mdu lcoins ndisease female age lfam child, re nolog vce(cluster id)

** (f) **
//Calculate value of lcins or log of coinsurance rate
dis log(25 + 1) //lcins at 25%
dis log(50 + 1) //lcins at 50%
preserve
replace lcoins = 3.2580965
predict mdu25, nu0 //predict at 25% coinsurance rate
replace lcoins = 3.9318256
predict mdu50, nu0 //predict at 50% coinsurance rate
gen pe = mdu50 - mdu25
sum pe
restore

** (g) **
xtpoisson mdu lcoins ndisease female age lfam child, fe nolog vce(bootstrap) //a fixed effect model

egen Ti = count(year), by(id) //numer of obs per individual
egen Mmdu = max(mdu), by(id) //maximum numbers of doctor visits across year by id
preserve
duplicates drop id, force
gen Dmdu = Mmdu == 0 //Dmdu=1 if the person never visit doctor in any year
tabulate Ti Dmdu
restore
* 265 only observed for one year, that's why it was dropped.
* 491-265=666 individuals were dropped that is not a switcher

esttab, not se

log close


