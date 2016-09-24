***************************************************************************************************************************************************
***************************************************************************************************************************************************
***************************************************************************************************************************************************
*** Robert Lange - University of Cologne - WiSo Faculty Examination No.: 33252 ********************************************************************
*** Code replicates some empirical findings of Hornung (Tables 2,4 and 5, 2014) and extends the analysis ******************************************
*** Erik Hornung (2014) - AER - "Immigration and the Diffusion of Technology: The Huguenot Diaspora in Prussia" ***********************************
*** Main code and data was published by Hornung (2014) and can be downloaded here: https://www.aeaweb.org/articles.php?doi=10.1257/aer.104.1.84 ***
***************************************************************************************************************************************************
***************************************************************************************************************************************************
***************************************************************************************************************************************************

cd "..."

set more off
*ssc install ivreg2, replace
*ivreg2 is a user written command: Baum, Christopher F., Mark E. Schaffer, and Steven Stillman. "ivreg2: Stata module for extended instrumental variables/2SLS, GMM and AC/HAC, LIML and k-class regression." Boston College Department of Economics, Statistical Software Components S 425401 (2007): 2007.

******************************
******************************
***Stata Generated Figures ***
******************************
******************************

**************************************************************************************************

*** Figure 1: Scatterplot - Huguenot Share and Ln Output: Textile Industry
**************************************************************************************************

use hornung-data-textiles, clear
graph twoway (lfitci ln_output1802_all hugue_1700_pc) (scatter ln_output1802_all hugue_1700_pc), title("Scatterplot - Textile Industry") subtitle("Data Source: Hornung (2014b)")


**************************************************************************************************

*** Figure 2: Scatterplot - Huguenot Share and Ln Output: Non-textile Industry
**************************************************************************************************

use hornung-data-nontextiles, clear
graph twoway (lfitci ln_output1802_all hugue_1700_pc) (scatter ln_output1802_all hugue_1700_pc), title("Scatterplot - Non-textile Industries") subtitle("Data Source: Hornung (2014b)")



******************************
*****************************
***Stata Generated Tables ***
*****************************
******************************

use hornung-data-textiles, clear

**************************************************************************************************
*** Generation of Global Macros in order to short-cut regressions  
**************************************************************************************************


*firmlist - Production materials (ln workers 1802, ln looms 1802, ln materials 1802 - not imputed!), loom dummy

global firmlist  ln_workers1802_all ln_looms1802_all ln_input1802_all no_looms 

*townlist - firmlist plus ln town population 1802, Merino sheep pc 1816 (county)

global townlist  ln_workers1802_all ln_looms1802_all ln_input1802_all no_looms ln_popcity1802 vieh1816_schaf_ganz_veredelt_pc 

*xlist - townlist plus Percent Protestant and "Not Prussia in 1700"-dummy 

global xlist  ln_workers1802_all ln_looms1802_all ln_input1802_all no_looms ln_popcity1802 vieh1816_schaf_ganz_veredelt_pc pop1816_prot_pc no_hugue_possible 

*mixlist - Production materials (ln workers 1802, ln looms 1802, ln materials 1802 imputed!), loom dummy and imputed values-dummy

global mixlist  ln_workers1802_all ln_looms1802_all mi_ln_input1802_all no_looms ln_popcity1802 vieh1816_schaf_ganz_veredelt_pc pop1816_prot_pc no_hugue_possible imputed_dummy



**************************************************************************************************
*** Labeling of Textile Data Set
**************************************************************************************************


label var id "Firm Identifier"
label var groupid "Town Identifier"
label var uniquetown "Indicator whether Firm is the first in Town"
label var wool "Indicator whether firm produces wool"
label var linen "Indicator whether firm produces linen"
label var cotton "Indicator whether firm produces cotton"
label var silk "Indicator whether firm produces silk"
label var hats "Indicator whether firm produces hats"
label var tuch "Indicator whether firm produces cloth (tuch)"
label var zeug "Indicator whether firm produces fabric (zeug)"
label var weaving "Indicator whether firm produces woven goods (weaving)"
label var waaren "Indicator whether firm produces mixed goods (waaren)"
label var posament "Indicator whether firm produces passement (posament)"
label var hugue_1700 "Number of Huguenots living in town"
label var hugue_1700_pc "Percentage of Huguenots in Population - 1700"
label var ln_occ1700_hugue_textile "Ln of Number of Huguenots employed in textiles"
label var hugue_1720_pc "Percentage of Huguenots in Population - 1720"
label var hugue_1795_pc "Percentage of Huguenots in Population - 1795"
label var hugue_dummy "Huguenots Dummy"
label var ln_dist_host "Ln of distance to the next colony"
label var output1802_all "Value of output 1802"
label var input1802_all "Value of input 1802"
label var looms1802_all "Number of looms used 1802"
label var workers1802_all "Number of workers 1802"
label var ln_output1802_all "Ln value of output 1802"
label var ln_input1802_all "Ln value of input 1802"
label var mi_ln_value_added "Ln added value - imputed"
label var ln_workers1802_all "Ln Number of workers 1802"
label var ln_looms1802_all "Ln Number of looms used 1802"
label var mi_ln_input1802_all "Ln value of materials - imputed"
label var no_looms "Indicator whether firm is not using looms"
label var ln_popcity1802 "Ln population of town 1802"
label var vieh1816_schaf_ganz_veredelt_pc "Percentage of Merino sheep 1816"
label var pop1816_prot_pc "Percentage of Protestants in Population 1816"
label var no_hugue_possible "Indicator whether town is in Prussia 1700"
label var imputed_dummy "Indicator whether value was imputed"
label var textil_1680_dummy "Indicator whether firm had relevant textile production before 1685"
label var poploss_keyser "Population Loss in 30 Years' War - Keyser"
label var poploss_keyser_projected "Projected Population Loss in 30 Years' War - Keyser"
label var poploss_aggregated_pr "Pr Population Loss in 30 Years' War - Keyser"
label var rel1816_protluth_pc "Percentage of Lutheran Protestants in Total Population of county"
label var rel1816_protref_pc "Percentage of Reformed Protestants in Total Population of county"
label var ln_piece_value "Ln Price per Unit"
label var ln_pop_before_aggregated "Ln Town population in 1625"
label var hanseatictraderoutes "Number of roads in the 17th century"
label var river "Indicator whether is near to the county"
label var dist_next_city "Distance to the next city"
label var km40 "Distance dummy"
label var elevation "Elevation"
label var cityrights "Year of City Rights"
label var no_markets "Number of Markets"
label var bishop "Episcopal city (bischhšflich)"

save hornung-data-textiles-labeled, replace


**************************************************************************************************

*** Table 1: OLS 
*** OLS regressions: Town-clustered standard errors and bootstrap standard errors
**************************************************************************************************

use hornung-data-textiles-labeled, clear


*OLS Regressions comparable to Hornung (2014, 104) Table 2 with Cluster-Robust Standard Errors
reg ln_output1802_all hugue_1700_pc, cluster(groupid)


reg ln_output1802_all hugue_1700_pc ln_workers1802_all, cluster(groupid)


reg ln_output1802_all hugue_1700_pc $townlist, cluster(groupid)


reg ln_output1802_all hugue_1700_pc $xlist, cluster(groupid)


reg ln_output1802_all hugue_1700_pc $xlist textil_1680_dummy, cluster(groupid)


reg ln_output1802_all hugue_1700_pc $mixlist textil_1680_dummy, cluster(groupid)


*OLS Regressions comparable to Hornung (2014, 104) Table 2 with Cluster-Bootstrap Standard Errors

reg ln_output1802_all hugue_1700_pc, vce(bootstrap,rep(400) seed(100)) cluster(groupid)


reg ln_output1802_all hugue_1700_pc ln_workers1802_all, vce(bootstrap,rep(400) seed(100)) cluster(groupid)


reg ln_output1802_all hugue_1700_pc $townlist, vce(bootstrap,rep(400) seed(100)) cluster(groupid)


reg ln_output1802_all hugue_1700_pc $xlist, vce(bootstrap,rep(400) seed(100)) cluster(groupid)


reg ln_output1802_all hugue_1700_pc $xlist textil_1680_dummy, vce(bootstrap,rep(400) seed(100)) cluster(groupid)


reg ln_output1802_all hugue_1700_pc $mixlist textil_1680_dummy, vce(bootstrap,rep(400) seed(100)) cluster(groupid)


**************************************************************************************************

*** Table 2: IV 
*** IV regressions: Possibly endogenous regressor - Huguenot population share, Instrument: Population Loss
**************************************************************************************************


* Reduced Form
reg ln_output1802_all poploss_aggregated_pr  $mixlist textil_1680_dummy, cluster(groupid)

* First Stage: Unadjusted Instrument - Hornung (2014, 108) Table 4 Column 2
reg hugue_1700_pc poploss_keyser $mixlist textil_1680_dummy , cluster(groupid)

* Second Stage: Unadjusted Instrument - Hornung (2014, 108) Table 4 Column 3
ivreg2 ln_output1802_all (hugue_1700_pc=poploss_keyser) $mixlist textil_1680_dummy , first cluster(groupid)

* First Stage: Interpolated Instrument - Hornung (2014, 108) Table 4 Column 4
reg hugue_1700_pc poploss_keyser_projected $mixlist textil_1680_dummy , cluster(groupid)

* Second Stage: Interpolated Instrument - Hornung (2014, 108) Table 4 Column 5
ivreg2 ln_output1802_all (hugue_1700_pc=poploss_keyser_projected) $mixlist textil_1680_dummy , first cluster(groupid)

* First Stage: Aggregated Instrument - Hornung (2014, 110) Table 5 Column 2
reg hugue_1700_pc poploss_aggregated_pr $mixlist textil_1680_dummy , cluster(groupid)

* Second Stage: Aggregated Instrument - Hornung (2014, 110) Table 5 Column 3
ivreg2 ln_output1802_all (hugue_1700_pc=poploss_aggregated_pr) $mixlist textil_1680_dummy , first cluster(groupid)


* Cluster-Bootstrap Standard Errors

* Reduced Form with Cluster-Bootstrap Standard Error
reg ln_output1802_all poploss_aggregated_pr  $mixlist textil_1680_dummy,  vce(bootstrap,rep(400) seed(100)) cluster(groupid)

* CB - First Stage: Unadjusted Instrument - Hornung (2014, 108) Table 4 Column 2
bootstrap, reps(400) seed(100) cluster(groupid): reg hugue_1700_pc poploss_keyser $mixlist textil_1680_dummy

* CB - Second Stage: Unadjusted Instrument - Hornung (2014, 108) Table 4 Column 3
bootstrap, reps(400) seed(100) cluster(groupid): ivreg ln_output1802_all (hugue_1700_pc=poploss_keyser) $mixlist textil_1680_dummy

* CB - First Stage: Interpolated Instrument - Hornung (2014, 108) Table 4 Column 4
bootstrap, reps(400) seed(100) cluster(groupid): reg hugue_1700_pc poploss_keyser_projected $mixlist textil_1680_dummy 

* CB - Second Stage: Interpolated Instrument - Hornung (2014, 108) Table 4 Column 5
bootstrap, reps(400) seed(100) cluster(groupid): ivreg ln_output1802_all (hugue_1700_pc=poploss_keyser_projected) $mixlist textil_1680_dummy

* CB - First Stage: Aggregated Instrument - Hornung (2014, 110) Table 5 Column 2
bootstrap, reps(400) seed(100) cluster(groupid): reg hugue_1700_pc poploss_aggregated_pr $mixlist textil_1680_dummy

* CB - Second Stage: Aggregated Instrument - Hornung (2014, 110) Table 5 Column 3
bootstrap, reps(400) seed(100) cluster(groupid): ivreg ln_output1802_all (hugue_1700_pc=poploss_aggregated_pr) $mixlist textil_1680_dummy



****************************************************************************************************************************************************************************************************

*** Table 3: Comparison of Different Standard errors
*** Standard Errors, Cluster Standard Errors (town level), Cluster Bootstrap (50 reps), Cluster Bootstrap (50 reps with different seed), Cluster Bootstrap (400 reps), Cluster Bootstrap (2000 reps) 
****************************************************************************************************************************************************************************************************

reg ln_output1802_all  hugue_1700_pc $xlist textil_1680_dummy, robust
estimates store het_robust

reg ln_output1802_all  hugue_1700_pc $xlist textil_1680_dummy, cluster(groupid)
estimates store clu_robust

reg ln_output1802_all  hugue_1700_pc $xlist textil_1680_dummy, vce(bootstrap,rep(50) seed(100)) cluster(groupid)
estimates store boots_robust_50

reg ln_output1802_all  hugue_1700_pc $xlist textil_1680_dummy, vce(bootstrap,rep(50) seed(20202)) cluster(groupid)
estimates store boots_robust_50_diff_seed

reg ln_output1802_all  hugue_1700_pc $xlist textil_1680_dummy, vce(bootstrap,rep(400) seed(100)) cluster(groupid)
estimates store boots_robust_400

reg ln_output1802_all  hugue_1700_pc $xlist textil_1680_dummy, vce(bootstrap,rep(2000) seed(100)) cluster(groupid)
estimates store boots_robust_2000

estimates table het_robust clu_robust boots_robust_50 boots_robust_50_diff_seed boots_robust_400 boots_robust_2000, b se


****************************************************************************************************************************************************************************************************

*** Table 4: Weak Instrument Statistics
*** Partial R^2, Cragg-Donald F statistic, Kleinbergen-Paap rK Wald F-Statistic
****************************************************************************************************************************************************************************************************


*UNADJUSTED
ivreg2 ln_output1802_all (hugue_1700_pc=poploss_keyser) $mixlist textil_1680_dummy , ffirst cluster(groupid)

mat first=e(first)
mat list first

*INTERPOLATED
ivreg2 ln_output1802_all (hugue_1700_pc=poploss_keyser_projected) $mixlist textil_1680_dummy , ffirst cluster(groupid)

mat first=e(first)
mat list first

*Population loss aggregated - Regressor: Percent Huguenots 1700

ivreg2 ln_output1802_all (hugue_1700_pc=poploss_aggregated_pr) $mixlist textil_1680_dummy , ffirst cluster(groupid)

mat first=e(first)
mat list first

*Population loss aggregated - Regressor: ln Huguenots in 1700
reg ln_occ1700_hugue_textile poploss_aggregated_pr $mixlist textil_1680_dummy , cluster(groupid)
ivreg2 ln_output1802_all (ln_occ1700_hugue_textile=poploss_aggregated_pr) $mixlist textil_1680_dummy , ffirst cluster(groupid)

mat first=e(first)
mat list first



****************************************************************************************************************************************************************************************************

*** Table 5: Missing Data Imputation Regressions
*** OLS regressions considering several imputation methods for ln input 1802 
*** Different imputation variables are computed in R code. Afterwards the variables are merged using id as the unique identifier
****************************************************************************************************************************************************************************************************

use hornung-data-textiles-labeled.dta, clear
merge 1:1 id using hornung-data-textiles_R_imputed.dta
drop _merge



global mixlist 		ln_workers1802_all ln_looms1802_all mi_ln_input1802_all no_looms ln_popcity1802 vieh1816_schaf_ganz_veredelt_pc pop1816_prot_pc no_hugue_possible imputed_dummy

global mixlist1 	ln_workers1802_all ln_looms1802_all mean_imp_ln_input1802 no_looms ln_popcity1802 vieh1816_schaf_ganz_veredelt_pc pop1816_prot_pc no_hugue_possible imputed_dummy

global mixlist2 	ln_workers1802_all ln_looms1802_all random_imp_ln_input1802 no_looms ln_popcity1802 vieh1816_schaf_ganz_veredelt_pc pop1816_prot_pc no_hugue_possible imputed_dummy

global mixlist3 	ln_workers1802_all ln_looms1802_all reg_imp_ln_input1802 no_looms ln_popcity1802 vieh1816_schaf_ganz_veredelt_pc pop1816_prot_pc no_hugue_possible imputed_dummy

global mixlist4 	ln_workers1802_all ln_looms1802_all iterative_imp_ln_input1802 no_looms ln_popcity1802 vieh1816_schaf_ganz_veredelt_pc pop1816_prot_pc no_hugue_possible imputed_dummy

global mixlist5 	ln_workers1802_all ln_looms1802_all reg_random_imp_ln_input1802 no_looms ln_popcity1802 vieh1816_schaf_ganz_veredelt_pc pop1816_prot_pc no_hugue_possible imputed_dummy


reg ln_output1802_all hugue_1700_pc $mixlist textil_1680_dummy, cluster(groupid)

reg ln_output1802_all hugue_1700_pc $mixlist1 textil_1680_dummy, cluster(groupid)

reg ln_output1802_all hugue_1700_pc $mixlist2 textil_1680_dummy, cluster(groupid)

reg ln_output1802_all hugue_1700_pc $mixlist3 textil_1680_dummy, cluster(groupid)

reg ln_output1802_all hugue_1700_pc $mixlist4 textil_1680_dummy, cluster(groupid)

reg ln_output1802_all hugue_1700_pc $mixlist5 textil_1680_dummy, cluster(groupid)


reg ln_output1802_all hugue_1700_pc $mixlist textil_1680_dummy, vce(bootstrap,rep(400) seed(100)) cluster(groupid)

reg ln_output1802_all hugue_1700_pc $mixlist1 textil_1680_dummy, vce(bootstrap,rep(400) seed(100)) cluster(groupid)

reg ln_output1802_all hugue_1700_pc $mixlist2 textil_1680_dummy, vce(bootstrap,rep(400) seed(100)) cluster(groupid)

reg ln_output1802_all hugue_1700_pc $mixlist3 textil_1680_dummy, vce(bootstrap,rep(400) seed(100)) cluster(groupid)

reg ln_output1802_all hugue_1700_pc $mixlist4 textil_1680_dummy, vce(bootstrap,rep(400) seed(100)) cluster(groupid)

reg ln_output1802_all hugue_1700_pc $mixlist5 textil_1680_dummy, vce(bootstrap,rep(400) seed(100)) cluster(groupid)


/***********************************************************
***********************************************************
*** Further Results - not explicitly diplayed in thesis ***
***********************************************************
***********************************************************

**************************************************************************************************
*Alternative Figure 1: Scatterplot - Huguenot Share and Ln Output: Textile Industry with top 5 percentiles dropped
**************************************************************************************************

use hornung-data-textiles, clear

_pctile hugue_1700_pc, p(5 95)
ret li

drop if hugue_1700_pc >= .0565937012434006

graph twoway (lfitci ln_output1802_all hugue_1700_pc) (scatter ln_output1802_all hugue_1700_pc), title("Scatterplot - Textile Industry") subtitle("Source: Hornung (2014)")


****************************************************************************************************************************************************************************************************
*ATTEMPT TO RECREATE HORNUNGS IMPUTATION MEASURE - Using the procedure described in Hornung (2014c, 2)
****************************************************************************************************************************************************************************************************
preserve
global milist  ln_workers1802_all ln_looms1802_all ln_output1802_all no_looms ln_popcity1802 vieh1816_schaf_ganz_veredelt_pc pop1816_prot_pc no_hugue_possible hugue_1700_pc


mi set mlong

mi register imputed ln_input1802_all

mi misstable summarize, all

mi impute regress ln_input1802_all = $milist, add(500) rseed(1234) force
*Attention: ln_input1802_all has now changed and is the mi imputed variable!

sum mi_ln_input1802_all ln_input1802_all
*Summary statistics indicate that both measures are very similar

global mi_rep_xlist ln_workers1802_all ln_looms1802_all ln_input1802_all no_looms ln_popcity1802 vieh1816_schaf_ganz_veredelt_pc pop1816_prot_pc no_hugue_possible _mi_miss

reg ln_output1802_all hugue_1700_pc $mi_rep_xlist textil_1680_dummy, cluster(groupid)
*Still, regression results are very different! Again: Missing robustness when changing imputation methods

restore


****************************************************************************************************************************************************************************************************
*OLS REGRESSIONS - ANALYSIS OF INFLUENCE OF CONTROL VARIABLES
****************************************************************************************************************************************************************************************************

reg ln_output1802_all hugue_1700_pc, cluster(groupid)

reg ln_output1802_all hugue_1700_pc ln_workers1802_all, cluster(groupid)

reg ln_output1802_all hugue_1700_pc ln_workers1802_all ln_looms1802_all, cluster(groupid)

reg ln_output1802_all hugue_1700_pc ln_workers1802_all ln_looms1802_all ln_input1802_all, cluster(groupid)

reg ln_output1802_all hugue_1700_pc ln_workers1802_all ln_looms1802_all ln_input1802_all no_looms, cluster(groupid)


****************************************************************************************************************************************************************************************************
*IV REGRESSIONS - ANALYSIS OF INFLUENCE OF CONTROL VARIABLES
****************************************************************************************************************************************************************************************************

* IV Regressions without any control variables
* Results: Instrument is not relevant in first stage; Instrumented regressor is not significant in second stage
* FS Coefficient: 0.09, SS Coefficient: 5.44
ivreg2 ln_output1802_all (hugue_1700_pc=poploss_keyser_projected) , first cluster(groupid)

*Adding Controls: firmlist
* Results: Instrument is still not relevant in first stage; Instrumented regressor is still not significant in second stage
* FS Coefficient: 0.094, SS Coefficient: 1.04
ivreg2 ln_output1802_all (hugue_1700_pc=poploss_keyser_projected) $firmlist , first cluster(groupid)

*Adding Controls: townlist - new: Merino sheep and town population
* Results: Instrument is still not relevant in first stage; Instrumented regressor is now highly significant in second stage
* FS Coefficient: 0.121, SS Coefficient: 1.36
ivreg2 ln_output1802_all (hugue_1700_pc=poploss_keyser_projected) $townlist , first cluster(groupid)

*Adding Controls: xlist - new: Percent Protestant and "Not Prussia in 1700"-dummy
* Results: Instrument is now highly significant/relevant in first stage; Instrumented regressor is highly significant in second stage
* FS Coefficient: 0.07, SS Coefficient: 3.17
ivreg2 ln_output1802_all (hugue_1700_pc=poploss_keyser_projected) $xlist , first cluster(groupid)

*Adding Controls: mixlist and textil-dummy -> Final configuration used by Hornung (2014)
* Results: Instrument is significant/relevant at 10 percent level in first stage; Instrumented regressor is highly significant in second stage
* FS Coefficient: 0.072, SS Coefficient: 3.48
ivreg2 ln_output1802_all (hugue_1700_pc=poploss_keyser) $mixlist textil_1680_dummy , first cluster(groupid)


*************************************************************************************
*Comparison of Standard Errors using imputed input values instead of unadjusted data 
*************************************************************************************

reg ln_output1802_all  hugue_1700_pc $mixlist textil_1680_dummy, robust
estimates store het_robust

reg ln_output1802_all  hugue_1700_pc $mixlist textil_1680_dummy, cluster(groupid)
estimates store clu_robust

reg ln_output1802_all  hugue_1700_pc $mixlist textil_1680_dummy, vce(bootstrap,rep(50) seed(100)) cluster(groupid)
estimates store boots_robust_50

reg ln_output1802_all  hugue_1700_pc $mixlist textil_1680_dummy, vce(bootstrap,rep(50) seed(20202)) cluster(groupid)
estimates store boots_robust_50_diff_seed

reg ln_output1802_all  hugue_1700_pc $mixlist textil_1680_dummy, vce(bootstrap,rep(400) seed(100)) cluster(groupid)
estimates store boots_robust_400

reg ln_output1802_all  hugue_1700_pc $mixlist textil_1680_dummy, vce(bootstrap,rep(2000) seed(100)) cluster(groupid)
estimates store boots_robust_2000

estimates table het_robust clu_robust boots_robust_50 boots_robust_50_diff_seed boots_robust_400 boots_robust_2000, b se


****************************************************************************************************************************************************************************************************

*** Testing for Endogeneity: Hausmann test - Only valid under homoscedasticity
*Table 4 - without cluster-robust inference

preserve
drop if poploss_keyser!=.
reg ln_output1802_all  hugue_1700_pc $mixlist textil_1680_dummy

estimates store OLS
restore
ivreg ln_output1802_all (hugue_1700_pc=poploss_keyser) $mixlist textil_1680_dummy 

estimates store IV
hausman OLS IV

*Table 5 - without cluster-robust inference

preserve
drop if poploss_aggregated_pr!=.
reg ln_output1802_all  hugue_1700_pc $mixlist textil_1680_dummy 

estimates store OLS
restore
ivreg2 ln_output1802_all (hugue_1700_pc=poploss_aggregated_pr) $mixlist textil_1680_dummy 
estimates store IV
hausman OLS IV

*** Testing the Exogeneity of the Regressors: Wooldridge (2010) - First stage residuals
*Table 4 - results: first-stage residuals are not significant

reg  hugue_1700_pc poploss_keyser $mixlist textil_1680_dummy, cluster(groupid)
predict v, resid
reg ln_output1802_all hugue_1700_pc poploss_keyser v, cluster(groupid)

*Table 5 - results: first-stage residuals are significant - should not be the case

reg hugue_1700_pc poploss_aggregated_pr $mixlist textil_1680_dummy, cluster(groupid)
predict u, resid
reg ln_output1802_all hugue_1700_pc poploss_aggregated_pr u


