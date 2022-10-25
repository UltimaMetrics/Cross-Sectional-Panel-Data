
clear
capture log close
set more off
//cd "C:\Users\fuouy\Dropbox\Teaching\UQ\ECON3370 Panel Data and Discrete Variables\Week 7\tutorial7"

cd "D:\UQ\2019 S2\ECON7371 Panel Data\Tute\tutorial 7\tutorial 7"
log using mytutorial7.log, replace

use RHIE, clear
capture eststo clear
xtset id year

eststo: probit dmdu lcoins ndisease female age lfam child, vce(cluster id) nolog
margins, atmeans dydx(lcoins)
margins, dydx(lcoins)
margins, atmeans dydx(female) //PEA

sum lcoins ndisease female age lfam child

margins, dydx(female) //APE and APE is more popular among researchers

probit dmdu lcoins ndisease female age lfam child, nolog
//For probit need converge in probability

*(B beings)
eststo: logit dmdu lcoins ndisease female age lfam child, vce(cluster id) nolog
margins, atmeans dydx(lcoins)
margins, dydx(lcoins)
margins, atmeans dydx(female)
margins, dydx(female)

eststo: xtlogit dmdu lcoins ndisease female age lfam child, re vce(bootstrap) nolog
eststo: xtlogit dmdu lcoins ndisease female age lfam child, fe vce(bootstrap) nolog

(C)
*Clustered standard errors
xtlogit dmdu lcoins ndisease female age lfam child, re vce(cl id) nolog
xtlogit dmdu lcoins ndisease female age lfam child, re vce(robust) nolog


codebook dmdu lcoins ndisease female age lfam child //check if there are missing values

esttab, not se title("Rand Health Insurance Experiment") /*
*/ mtitles("Pooled Logit" "Pooled Probit" "RE Logit" "FE Logit")
esttab using table1.tex, not se replace title("Rand Health Insurance Experiment") /*
*/ mtitles("Pooled Logit" "Pooled Probit" "RE Logit" "FE Logit")

*When use FE, observation will decrease a lot. Why? because of within estimation!

log close
