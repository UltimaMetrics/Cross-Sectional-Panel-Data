
clear
capture log close
set more off
*cd "C:\Users\fuouy\Dropbox\Teaching\UQ\ECON3370 Panel Data and Discrete Variables\Week 10\tutorial10"
cd "D:\Tutor\2019\ECON3370 & ECON7371\week 10\tutorial10"
log using tutorial10.log, replace 

** (a) NL **
use fishmodelong, clear

*******************
*Mixed logit model*
*******************
asclogit d p q, case(id) alternatives(fishmode) casevars(income) nolog

* Predict probabilities at each alternative
predict P_cl, pr

* Compare predicted probabilities to the sample probabilities
tabulate fishmode, summarize(P_cl)
tabulate fishmode, summarize(d)
estat mfx  // PEA

* Private = 0.000553, pier = 0.000087, charter = 0.000609, beach =-0.001249

* Calculate APE manually
preserve
quietly sum p
gen delta = r(sd)/1000  // small change
quietly replace p = p + delta if fishmode == "beach"
predict P_cl_new, pr
gen pe = (P_cl_new - P_cl)/delta 
tabulate fishmode, summarize(pe)
restore

/*
            |            Summary of pe
   fishmode |        Mean   Std. Dev.       Freq.
------------+------------------------------------
      beach |  -.00210892    .0019528       1,182
    charter |   .00064642   .00050528       1,182
       pier |   .00090711   .00154867       1,182
    private |   .00055537   .00047725       1,182
------------+------------------------------------
      Total |  -3.384e-09   .00178105       4,728
*/
* Seems to differ for beach and pier fishing

*********************
* Nested logit model*
*********************
* errors to correlated within group but not across group
* Create variable based on specification of branches
nlogitgen type = fishmode(shore: pier|beach, boat: private|charter) 

* Display tree structure
nlogittree fishmode type, choice(d)

* Nested logit regression
nlogit d p q || type:, base(shore) ||fishmode: income, case(id) notree nolog
* Coefficients of p is little changed compared to CL model, but the other
* changed significantly

* Rejection of LR test favouring the NL than CL

* Calculate the probability of of Level 1 and 2
predict plimb pbranch, pr
* Compare predicted probabilities to the sample probabilities
tabulate type, summarize(plimb)
tabulate fishmode, summarize(pbranch)
tabulate fishmode, summarize(d)
* Predicted prob for level 1 is exactly the same as sample
* Level 2 are slightly diff from the sample prob

* APE 
preserve
quietly sum p
gen delta = r(sd)/1000  // small change
quietly replace p = p + delta if fishmode == "beach"
predict plimb_new pbranch_new, pr
gen pe = (pbranch_new - pbranch)/delta 
tabulate fishmode, summarize(pe)
restore

/*
            |            Summary of pe
   fishmode |        Mean   Std. Dev.       Freq.
------------+------------------------------------
      beach |  -.00054263   .00048505       1,182
    charter |   .00063416   .00054756       1,182
       pier |  -.00064879   .00057086       1,182
    private |   .00055727   .00051241       1,182
------------+------------------------------------
      Total |   5.095e-09   .00079863       4,728
*/

* Little change on APE of charter and private boat.
* But the probability of pier fishing falls in the addition to
* the probability of beach fishing

** (b) MNP **
* Relax IIA assumption and does not require nesting structure
* Allow for error correlation
use fishmodelong, clear
drop if fishmode == "charter" | mode == 4

* Unstructured corelationa and heteroskedastic errors
asmprobit d p q, case(id) alternatives(fishmode) casevars(income) /*
*/ correlation(unstructured) structural stddev(heteroskedastic) nolog
* expected sign for the coeficients
* Base model = beach (default chose the 1st one)

estat covariance 
estat mfx // PEA

* Predicted probabilities
predict P_mnp, pr
tabulate fishmode, summarize(P_mnp)
tabulate fishmode, summarize(d)

* Close but not exactly the same


** (c) RPL **
* Allow parameters in the CL to be normally distributed or lognormally distributed
ssc install mixlogit
* No option for case specfic variables "income"
* Manually generate regressors for income and intercept
gen dbeach = fishmode == "beach"
gen dprivate = fishmode == "private"
gen ybeach = dbeach*income
gen yprivate = dprivate*income

mixlogit d q dbeach dprivate ybeach yprivate, group(id) rand(p)
mixlpred P_rpl
tabulate fishmode, summarize(P_rpl)
tabulate fishmode, summarize(d)

asclogit d p q, case(id) alternatives(fishmode) casevars(income) nolog


log close

