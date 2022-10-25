
clear
capture log close
set more off
//cd "C:\Users\fuouy\Dropbox\Teaching\UQ\ECON3370 Panel Data and Discrete Variables\Week 9\tutorial9"
cd "D:\UQ\2019 S2\ECON7371 Panel Data\Tute\tutorial 9\tutorial 9"

log using tutorial.log, replace

use fishmode, clear
des
capture eststo clear

* (a) *
tabulate mode

* (b) *
//average income in each mode
table mode, contents(N income mean income sd income)
//average price of beach, pier, private boat, charter boat for each categories
table mode, contents(mean pbeach mean ppier mean pprivate mean pcharter)

* (c) & (d) *Base outcome=beach=>compare all estimate relative to "beach"
eststo: mlogit mode income, nolog baseoutcome(1)
test income

* (e) *PCP: percentage correctly predicted=100*(N of corrected prediction)/All obs
*predict probabilitie of each of the categories
predict pmnl1 pmnl2 pmnl3 pmnl4, pr

*predict the categories
gen pmode = 1*(pmnl1 > pmnl2)*(pmnl1 > pmnl3)*(pmnl1 > pmnl4) + /*
*/ 2*(pmnl2 > pmnl1)*(pmnl2 > pmnl3)*(pmnl2 > pmnl4) + /*
*/ 3*(pmnl3 > pmnl1)*(pmnl3 > pmnl2)*(pmnl3 > pmnl4) + /*
*/ 4*(pmnl4 > pmnl1)*(pmnl4 > pmnl2)*(pmnl4 > pmnl3) 

tabulate pmode
gen correct1 = pmode == mode
sum correct1

* (f) *APE
margins, dydx(income) pr(out(3))

* (g) & (h) * Mixed logit
gen id = _n
reshape long d p q, i(id) j(fishmode beach pier private charter) string
asclogit d, case(id) alternatives(fishmode) nolog 
eststo: asclogit d p q, case(id) alternatives(fishmode) casevars(income) nolog

dis 1 - (-1215.1376)/(-1497.7229) //Psudeo r squared (McFadden)

test income

*PCP
predict pmnl, pr //predict prob of alternative
egen maxpmnl = max(pmnl), by(id) //Identify alternative with higher prob
gen dpred = maxpmnl == pmnl
gen dd = abs(dpred - d) //Compare the predicted choice to actual choice
egen maxdd = max(dd), by(id) //outing the corret cases
tabulate maxdd 
//PCP
tabulate maxdd if mode <= 2 //PCP for beach and pier
*PCP=tabulate maxdd if mode <=2 

*APE
estat mfx

log close
