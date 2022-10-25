
clear
capture log close
set more off
//cd "C:\Users\fuouy\Dropbox\Teaching\UQ\ECON3370 Panel Data and Discrete Variables\Week 6\tutorial6"

cd "D:\UQ\2019 S2\ECON7371 Panel Data\Tute\tutorial 6\tutorial 6"

log using mytutorial6.log, replace

use smoking, clear
des
sum 
*ssc install xtoverid
//ssc install estout
tabstat smoker, by(smkban) statistics(n mean, sd, min, max)
reg smoker if smkban == 1, robust
reg smoker if smkban == 0, robust
reg smoker, robust

capture eststo clear
eststo: reg smoker smkban, robust

gen age2 = age^2
eststo: reg smoker smkban female age age2 hsdrop hsgrad colsome /*
*/ colgrad black hispanic, robust
test hsdrop hsgrad colsome colgrad

eststo: probit smoker smkban female age age2 hsdrop hsgrad colsome /*
*/ colgrad black hispanic
test hsdrop hsgrad colsome colgrad

eststo: logit smoker smkban female age age2 hsdrop hsgrad colsome /*
*/ colgrad black hispanic
test hsdrop hsgrad colsome colgrad

esttab, r2 ar2 scalars(p F ll) not se /*
*/ mtitles(LPM1 LPM2 Probit Logit) /*
*/ title("Smoker and Smoking Bans")
esttab using table1.tex, r2 ar2 scalars(p F ll) not se /*
*/ mtitles(LPM1 LPM2 Probit Logit) /*
*/ title("Smoker and Smoking Bans") replace

* Part h
quietly probit smoker smkban female age age2 hsdrop hsgrad colsome /*
*/ colgrad black hispanic
margins, at(smkban = 0 female = 0 age = 20 age2 = 400 black = 0 hispanic = 0 /*
*/ hsdrop = 1 hsgrad = 0 colsome = 0 colgrad = 0)
margins, at(smkban = 1 female = 0 age = 20 age2 = 400 black = 0 hispanic = 0 /*
*/ hsdrop = 1 hsgrad = 0 colsome = 0 colgrad = 0)
margins, at(smkban = 0 female = 1 age = 40 age2 = 1600 black = 1 hispanic = 0 /*
*/ hsdrop = 0 hsgrad = 0 colsome = 0 colgrad = 1)
margins, at(smkban = 1 female = 1 age = 40 age2 = 1600 black = 1 hispanic = 0 /*
*/ hsdrop = 0 hsgrad = 0 colsome = 0 colgrad = 1)

quietly reg smoker smkban female age age2 hsdrop hsgrad colsome /*
*/ colgrad black hispanic, robust
margins, at(smkban = 0 female = 0 age = 20 age2 = 400 black = 0 hispanic = 0 /*
*/ hsdrop = 1 hsgrad = 0 colsome = 0 colgrad = 0)
margins, at(smkban = 1 female = 0 age = 20 age2 = 400 black = 0 hispanic = 0 /*
*/ hsdrop = 1 hsgrad = 0 colsome = 0 colgrad = 0)
margins, at(smkban = 0 female = 1 age = 40 age2 = 1600 black = 1 hispanic = 0 /*
*/ hsdrop = 0 hsgrad = 0 colsome = 0 colgrad = 1)
margins, at(smkban = 1 female = 1 age = 40 age2 = 1600 black = 1 hispanic = 0 /*
*/ hsdrop = 0 hsgrad = 0 colsome = 0 colgrad = 1)

quietly logit smoker smkban female age age2 hsdrop hsgrad colsome /*
*/ colgrad black hispanic
margins, at(smkban = 0 female = 0 age = 20 age2 = 400 black = 0 hispanic = 0 /*
*/ hsdrop = 1 hsgrad = 0 colsome = 0 colgrad = 0)
margins, at(smkban = 1 female = 0 age = 20 age2 = 400 black = 0 hispanic = 0 /*
*/ hsdrop = 1 hsgrad = 0 colsome = 0 colgrad = 0)
margins, at(smkban = 0 female = 1 age = 40 age2 = 1600 black = 1 hispanic = 0 /*
*/ hsdrop = 0 hsgrad = 0 colsome = 0 colgrad = 1)
margins, at(smkban = 1 female = 1 age = 40 age2 = 1600 black = 1 hispanic = 0 /*
*/ hsdrop = 0 hsgrad = 0 colsome = 0 colgrad = 1)

log close

* Calculate probability manually
* Mr.A from company that ban smoking.
* probit model
* z = -.248718
di -1.734926 -.15863*1 -.1117313 * 0 + .0345114* 20 -.0004675* 20^2 + 1.14161* 1
* Pr(smoker = 1|smkban =1, age, female,...) = \Phi(z)= .40178946
di normprob(-.248718)

* Pr(smoker = 1|smkban = 0) = 0.46410864
* Diff = .40178946 - 0.46410864 = -.06231918

* Logit model
di (1+ exp(-(-2.999182 + .0599366*20 + -.0008182 * (20^2) + 2.016853)))^-1

* Pr(smoker = 1|smkban =0, age, female...)= .47230911
* Pr(smoker = 1|smkban = 1) = 0.40783909

* LPM:

* Pr(smoker = 1|smkban = 1, age, female...) = 0.4021324
* Pr(smoker = 1|smkban = 0) = 0.44493723
