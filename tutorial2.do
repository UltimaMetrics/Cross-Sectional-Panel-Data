
clear
capture log close
set more off
cd "E:\UQ\2019 S2\ECON7371 Panel Data\Tute\tutorial2\tutorial2\"
log using tutorial2.log, replace

//use psidextract, clear
ssc install estout
use psidextract.dta
des

** (a) **
xtset id t 
xtdescribe //for stat distribution//

*mdesc:ssc install mdesc //help describe missing variable
ssc install mdesc

mdesc

*nmissing:ssc install nmissing
ssc install nmissing
nmissing
npresent

** (b) **
xtsum lwage ed tdum1 wks //where tduml is the time dummy variable, wks is number of weeks worked

//wks means weeks worked

//within groups: variation around group means (Variation over time )
//between groups: variation of the group means around the overall means (variation across individuals)
*ed is time invariant, tduml is individual invariant

** (c) **
xttrans south

ssc install estout



** (d) **
capture eststo clear
eststo: reg lwage ed wks exp exp2

eststo: reg lwage ed wks exp exp2, vce(robust)
//eststo: reg lwage ed wks exp exp2, vce(cluster id) //assuming ID is the panel variable in your -xtset- command
//cluster id is the same as robust

*the default SEs are misleadingly smaller than the panel-robust SEs.

** (e) **
eststo: reg lwage ed wks exp exp2 tdum2-tdum7
eststo: reg lwage ed wks exp exp2 tdum2-tdum7, vce(cluster id)
*Coef are the same under two cases but Standard error is larger under cluster id
test tdum2 tdum3 tdum4 tdum5 tdum6 tdum7

//vcd(cluster id): specifies that the standard errors allow for intragroup correlation, relaxing
//the usual requirement that the observations be independent. That is to say, the observations are
//independent across groups (clusters) but not necessarily within groups. clustvar specifies to which
//group each observation belongs, for example, vce(cluster personid) in data with repeated
//observations on individuals. vce(cluster clustvar) affects the standard errors and variance–
//covariance matrix of the estimators but not the estimated coefficients;

*no seriall autocorrelation will be violated
//no tdum1 because it is the base period and most importatnly need to avoid multicollinearity




** (f) **
esttab, r2 ar2 not se  

//However there  could be omitted varaible bias despite the fact that they look significant.
*/ title("POLS Estimation") /*
*/ mtitles("Default SE" "Panel-Robust SE" "Time effects + Default SE" "Time effects + Panel-Robust")
 
esttab using table1.tex, r2 ar2 not se /*
*/ mtitles("Default SE" "Panel-Robust SE" "Time effects + Default SE" "Time effects + Panel-Robust") /*
*/ title("POLS Estimation")


**(g)**
*Q:Do you think the POLS estimator in (e) is consistent (or equivalently, Assumption POLS3 is valid)? Why?
*Note: POLS3 means exogeniety

*my answers: no, the robust standard error are generally about twice the uncorred ones. Ignoring
*the within group does affect the inference one would draw. 

**The OLS estimator in the generalized regression model may be consistent, but the conventional
**estimator of its asymptotic variance is likely to underestimate the true varianc eof the estimator

//Define consistent:The OLS estimator is consistent when the regressors are exogenous, 
//and optimal in the class of linear unbiased estimators when the 
//errors are homoscedastic and serially uncorrelated[


*Assumptions POLS1-3 are sufﬁcient for pooled OLS estimator to consistently estimate (α,β). 

log close
