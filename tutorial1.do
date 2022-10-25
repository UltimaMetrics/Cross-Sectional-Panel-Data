
clear
capture log close
set more off
cd "C:\Users\fuouy\Dropbox\Teaching\UQ\ECON7310 Elements of Econometrics\2019\Week 1 Introduction\tutorial1"
log using tutorial1.log, replace


** Question 1 **

import delimited cps98, clear

sum

tab age
tabstat age, stat(n mean sd med)

tab female bachelor

hist ahe, kdensity

sum ahe if female == 1
sum ahe if female == 0

sum if ahe > 40
sum if ahe < 3

gen ahe2 = ahe*ahe

scatter ahe2 ahe, title("Ahe2")
scatter ahe2 ahe, title("Ahe2") xlabel(0(2)50) ylabel(0(1000)3000)

pwcorr ahe age
corr ahe age

pwcorr ahe age if ahe > 40
pwcorr ahe age if ahe < 3


** Question 2 **

use fultonfish, clear

des
codebook lprice quan lquan

sum quan, detail

dis abs(sqrt(111)*(6334.667 - 7200)/4040.12)

dis 6334.667 - 1.96*4040.12/sqrt(111)
dis 6334.667 + 1.96*4040.12/sqrt(111)

scatter lprice lquan || lfit lprice lquan
scatter lprice lquan || qfit lprice lquan

export excel using fultonfish.xlsx, replace

log close

