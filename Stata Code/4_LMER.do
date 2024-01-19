*For Mixed Effect Regression, use long data (repeated id)

use "$Data/Stata/Dataset_clean_long.dta", clear

//For perceived product healthfulness,
*perceived social responsibility of brand, and 
*favorable brand attitudes (i.e., measures that were repeated within participants), 
*we will fit mixed models that regress outcomes on an 
*indicator variable for condition, 
*indicators for product type (beer, wine, or liquor), and the 
*interaction between condition and product type. 
*Models will treat the intercept as random to account for repeated measures. If treatment effects vary by product type (i.e., significant moderation) we will report effects at each level of the moderator. 

//Create beverage type variable using numbers for regression (can't use strings)
gen bevtype=.
replace bevtype=1 if bev=="liquor"
replace bevtype=2 if bev=="beer"
replace bevtype=3 if bev=="wine"
label define bevlabels 1 "liquor" 2 "beer" 3 "wine"
label values bevtype bevlabels	

local row=3
*Health, Social Responsibility, Favorable Attitudes
foreach var of varlist health socresp fav {

display "`var' LMER"

//Random intercepts by id

mixed `var' arm##bevtype || transaction_id: 

testparm arm#bevtype

	putexcel set "$Analysis/Results/Results_LMER.xlsx", sheet("Wald") modify
	putexcel A1="Interaction arm x product type"
	putexcel A2="Variable"
	putexcel B2="Wald test p-value"
		
	putexcel A`row'= "`var'"
	putexcel B`row' = `r(p)'
	local ++row

/* slope of arm for each level of bev type*/
margins bevtype, dydx(arm)

return list
	matrix a = r(table)
	matrix list a
	matrix `var'b = a[1,1...]' 
	matrix `var'ci = a[5..6,1...]'
	matrix `var'p = a[4,1...]'

	putexcel set "$Analysis/Results/Results_LMER.xlsx", sheet("LMER") modify

putexcel A1=("Variable")
putexcel B1=("arm")
putexcel C1=("ADE")
putexcel D1=("lb")
putexcel E1=("ub")
putexcel F1=("p")
putexcel G1=("n")

	local lab: var lab `var'
	putexcel A`row'= "`lab'"
	putexcel B`row'=matrix(`var'b), rownames
	putexcel C`row'=matrix(`var'b), nformat(number_d2) 
	putexcel D`row'=matrix(`var'ci), nformat(number_d2)
	putexcel F`row'=matrix(`var'p)
	putexcel G`row' = matrix(e(N))
	local row = `row'+7
	
}

*Repeated variables means,SD and data for moderation plot (health x bevtype x arm) - plot in excel

foreach var of varlist health socresp fav{
	local row=3
	
	forval a=0/1{
		forval f=1/3{
		
	display" `var' bev:`f' arm:`a'"
	summ `var' if bevtype ==`f' & arm == `a'
	
	putexcel set "$Analysis/Results/Repeated vars means and moderation plot.xlsx", sheet("`var'") modify
	
	putexcel A1= "`var'"
	putexcel A2= "Bev type" B2="Arm" C2="Mean" D2="SD"
	putexcel F2= "1 liquor 2 beer 3 wine"
	
	putexcel A`row' = "`f'"
	putexcel B`row' = `a'
	putexcel C`row' = `r(mean)'
	putexcel D`row' = `r(sd)'
	putexcel F`row' = formula(CONCATENATE(TEXT(C`row',"0.00"),"  (",TEXT(D`row',"0.00"),")"))
	local ++row
	
		}
	}
}

//For perceived product healthfulness, 
*perceived social responsibility of brand, and 
*favorable brand attitudes, 
*we will assess whether the effect of pinkwashed ads on these outcomes vary by 
*brand familiarity. 
*We will fit mixed models that regress outcomes on 
*an indicator variable for condition, 
*a variable for brand familiarity, and the 
*interaction between condition and brand familiarity.
*Brand familiarity as continuous variable

local row=3
*Health, Social Responsibility, Favorable Attitudes
foreach var of varlist health socresp fav {

display "`var' LMER"

//Random intercepts by id

mixed `var' arm##c.fam || transaction_id: 

testparm arm#c.fam

	putexcel set "$Analysis/Results/Results_LMER.xlsx", sheet("Wald_Familiarity") modify
	putexcel A1="Interaction arm x brand familiarity"
	putexcel A2="Variable"
	putexcel B2="Wald test p-value"
		
	putexcel A`row'= "`var'"
	putexcel B`row' = `r(p)'
	local ++row

}


