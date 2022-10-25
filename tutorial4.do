
clear
capture log close
set more off
//cd "C:\Users\fuouy\Dropbox\Teaching\UQ\ECON3370 Panel Data and Discrete Variables\Week 4\tutorial4"
cd "E:\UQ\2019 S2\ECON7371 Panel Data\Tute\Tute4\tutorial4\tutorial4"


log using tutorial4my.log, replace

use psidextract, clear
des

** (a) **
xtset id t
label variable t "year"

capture eststo clear
eststo: reg lwage ed wks exp exp2, vce(cluster id) 
eststo: xtreg lwage ed wks exp exp2, re vce(cluster id) theta
//not constant because of quadratic form. So Effect is not constant.
//Two error terms in RE. Because variance has two components: 
//one for alpha i, one for error term it
//Rho tells how much variation came from. Rho is a function of variance
//see formula on white board
//In our tute: it is  .81505521  which means 81.51 percent


** (b) **
eststo: xtreg lwage ed wks exp exp2, fe vce(cluster id)
//educ is zero because it is Omitted variable and because it is time invariant
//this section is related to fixed effect
//_cons or "Beta zero hat" is the average fixed effect or 1/n summation alpha i

** (c) **
eststo: xtreg lwage ed wks exp exp2 tdum2-tdum7, re vce(cluster id) theta
//we have 7 periods, but we only put 2 to 7. 
//we estimate both Random effect and fixed effect.
testparm tdum2-tdum7

//time fixed effecgt may be a problem if there is omitted varaible bias. 
 
** (still part C) **
eststo: xtreg lwage ed wks exp exp2 tdum2-tdum7, fe vce(cluster id) 

esttab, r2 ar2 not se scalars(r2_o r2_b r2_w sigma_u sigma_e rho) /*
*/ title("Linear Unobserved Effects Panel Data Models") 
 
esttab using table1.tex, r2 ar2 not se scalars(r2_o r2_b r2_w sigma_u sigma_e rho) /*
*/ title("POLS Estimation") replace

//when BLUE is sured, then can do pooled ols

** (D) **
reg D.(lwage ed wks exp exp2), vce(cluster id) noconstant
//D. means taking the first difference
//RE means hetero is not a potential problem
//FE relax that assumption
//**understnad RE FE FD: go to textbook
log close
