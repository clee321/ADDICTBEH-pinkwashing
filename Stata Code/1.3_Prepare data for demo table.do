**Prepare dataset for demographic analysis
**Recode demo variables
**Rearrange race variables - wide format/ separate multiple choices

use "$Data/Stata/Dataset_clean_nonrepeated.dta", clear

**#Age

tab Z50_Age

recode Z50_Age (18/25 = 1) (26/34 = 2) (35/44 = 3) (45/54 = 4) (55/64 = 5) (65/74 = 6) (65/100 = 7) , generate(agecat)
label define agelabels 1 "18-25 years" 2 "26-34 years" 3 "35-44 years" 4 "45-54 years" 5 "55-64 years" 6 "65-74 years" 7 "75+ years"
label values agecat agelabels
lab var agecat 	"Age"

tab agecat

**#Gender
	
tab Z20_Gen
tab Z20_Gen_4_TEXT
gsort -Z20_Gen_4_TEXT

**#Sexual orientation

tab Z40_SexualOrient
tab Z40_SexualOrient_4_TEXT
gsort -Z40_SexualOrient_4_TEXT

**#Race and Ethnicity
*Multiple choice (e.g "1,6") - can't label strings
*1 "White" 2 "Black" 3 "Am Indian/Alaska Native" 4 "Asian" 5 "Nat Hawaiian/Pacific Islander" 6 "Other"
**Not mutually exclusive

tab Z70_Race
tab Z70_Race_6_TEXT 
gsort -Z70_Race_6_TEXT 

gen race_white=0
replace race_white=1 if strpos(Z70_Race,"1")

gen race_black=0
replace race_black=1 if strpos(Z70_Race,"2")

gen race_amind=0
replace race_amind=1 if strpos(Z70_Race,"3")

gen race_asian=0
replace race_asian=1 if strpos(Z70_Race,"4")

gen race_pacisl=0
replace race_pacisl=1 if strpos(Z70_Race,"5")

gen race_other=0
replace race_other=1 if strpos(Z70_Race,"6")

	lab var race_white 	"White"
	lab var race_black 	"Black or African American"
	lab var race_amind 	"American Indian or Alaska Native"
	lab var race_asian 	"Asian"
	lab var race_pacisl "Native Hawaiian or other Pacific Islander" 
	lab var race_other 	"Other race" 

**#Education

tab Z80_Edu	
	
recode Z80_Edu (1/2 = 1) (3/4 = 2) (5/6 = 3), generate(educat)
label define edulabels 1 "High school degree/GED or below" 2 "Associate's degree or some college/technical school" 3 "Bachelor's degree or higher"
label values educat edulabels

lab var educat 	"Education level"
tab educat

**#IncomeCats
///1=Less than $10,000, 2=$10,000 to $14,999, 3=$15,000 to $24,999, 4=$25,000 to $34,999, 5=$35,000 to $49,999, 6=$50,000 to $74,999, 7=$75,000 to $99,999, 8=$100,000 to $149,999, 9=$150,000 to $199,999, 10=$200,000 or more

tab Z100_Income
	
recode Z100_Income (1/3 = 1) (4/5 = 2) (8/10 = 8), generate(incomecat)
label define inclabels 1 "$24,999 or less" 2 "$25,000 to $49,999" 6 "$50,000 to $74,999" 7 "$75,000 to $99,999" 8 "$100,000 or more"
label values incomecat inclabels	

lab var incomecat 	"Annual household income"
tab incomecat
	
**#Binge (all genders)
*how many days during the past 30 days did you have 5 or more drinks on an occasion?

lab var binge 	"Number of days of binge drinking"

recode binge (1 = 0) (2/3 = 1) (4/32 = 3), generate(bingecat)
label define bingelabels 0 "0 days" 1 "1-2" 3 "3+"
label values bingecat bingelabels

**#Past Use

recode Z87_Past30DayUse (4/5 = 4), generate(pastcat)
label define pastlabels 0 "0 days" 1 "1-2" 2 "3-5" 3 "6-9" 4 "10+"
label values pastcat pastlabels


save "$Data/Stata/Dataset_clean_nonrepeated_demo.dta", replace
