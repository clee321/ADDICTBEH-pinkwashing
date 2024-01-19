*Non-repeated data for OLS analysis

use "$Data/Stata/Dataset_clean_nonrepeated_demo.dta", clear

//For disease risk perceptions outcomes, purchase intentions, perceived misleadingness, and support for warnings (i.e., all non-repeated measures), we will use ordinary least squares regressions, regressing the outcome on an indicator variable for condition (pinkwashed ads vs. control ads). 

local row=2
foreach var of varlist breast stom mouth livercc liverdis hyper purchase mislead policy {

display "`var' linear regression"
regress `var' arm

*same as coefficient
margins, dydx(*)

return list
	matrix a = r(table)
	matrix list a
	matrix `var'b = a[1,1...]' 
	matrix `var'ci = a[5..6,1...]'
	matrix `var'p = a[4,1...]'

	putexcel set "$Analysis/Results/Results_OLS.xlsx", modify

putexcel A1=("Variable")
putexcel B1=("n")
putexcel C1=("ADE")
putexcel D1=("lb")
putexcel E1=("ub")
putexcel F1=("p")

	putexcel A`row'="`var'"
	putexcel B`row' = matrix(e(N))
	putexcel C`row'=matrix(`var'b), nformat(number_d2)
	putexcel D`row'=matrix(`var'ci), nformat(number_d2)
	putexcel F`row'=matrix(`var'p)
	local ++row 
}


//Examine potential moderation of the effect of pinkwashed ads on the primary outcome by frequency of drinking, frequency of binge drinking , gender (male vs. female), and age (young adults vs. middle/older adults). To assess moderation, we will add the potential moderator to the primary models along with the interaction between the moderator and experimental condition.

**#Regression with moderation - Primary Outcome: Breast Cancer

*Frequency of drinking - regroup variables
recode pastcat (1/4 = 1), generate(pastint)
label define pastlabel2 0 "0 days" 1 "1+"
label values pastint pastlabel2

regress breast arm##pastint
*Interaction NOT significant
testparm arm#pastint

*Frequency of binge drinking - regroup variables
recode bingecat (1/3 = 1), generate(bingeint)
label define bingelabel2 0 "0 days" 1 "1+"
label values bingeint bingelabel2

regress breast arm##bingeint
*Interaction NOT significant
testparm arm#bingeint


*Gender
**Removed non-binary due to small cell size

gen gen_mod = . //gender variable for moderation
replace gen_mod = 1 if Z20_Gen == 1 //"Woman" 
replace gen_mod = 2 if Z20_Gen == 2 //"Man"
*label define gender_Labels 1 "Woman" 2 "Man"
label values gen_mod gender_Labels

regress breast arm##gen_mod
//overall interaction IS NOT statistically significant
testparm arm#gen_mod
//marginal effect on breast cancer of being in gender group in each arm
* slope of arm for each level of gender
margins gen_mod, dydx(arm)

*Age
//Before regressing age, need to regroup in two groups (young adults vs. middle/older adults)

recode Z50_Age (18/25 = 1) (26/34 = 1) (35/44 = 2) (45/54 = 2) (55/64 = 2) (65/74 = 2) (65/100 = 2) , generate(agecat_mod)
label define agelabels2 1 "18-34 years" 2 "35-100 years"
label values agecat_mod agelabels2
lab var agecat_mod 	"Age"

regress breast arm##agecat_mod
//overall interaction is NOT statistically significant
testparm arm#agecat_mod
//marginal effect on breast cancer of being in age group in each arm
margins agecat_mod, dydx(arm)

