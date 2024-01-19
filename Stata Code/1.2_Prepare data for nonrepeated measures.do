**Prepare dataset with non-repeated variables (e.g., health outcome) for Linear Regression
**One row per seqn for demo and non-repeated variables analysis (derived from long dataset)
**Combine variables into 1 column each
**Disease risk perceptions aggregated with alpha command (Cronbach's alpha)

use "$Data/Stata/Dataset_clean_long.dta", clear

*Drop duplicates on transaction_id - dataset for linear regression (variables without repeated measures)
duplicates drop transaction_id, force

**Breast Cancer Risk Perceptions
*Wine
//pink
sum breast_wine_pk
//control
sum breast_wine_ctr

*Beer
//pink
sum breast_beer_pk
//control
sum breast_beer_ctr

*Liquor
//pink
sum breast_liq_pk
//control
sum breast_liq_ctr

**#Prepare data for Linear Regression Analysis
*Primary outcome: perceptions that drinking alcohol increases the risk of developing breast cancer 
*Assuming sufficient internal consistency (Cronbach's alpha>=0.70), responses to these 3 items will be averaged for analysis. 

**#Combine disease risk perceptions - average of beer+wine+liquor
**When an answer to one of the categories is missing, the average will be missing.

//1 Pink Breast Cancer
alpha breast_liq_pk breast_wine_pk breast_beer_pk if arm==1, i c a g(breast_all_pk)
summ breast_all_pk
//Control 
alpha breast_liq_ctr breast_wine_ctr breast_beer_ctr if arm==0, i c a g(breast_all_ctr)
summ breast_all_ctr

*Check mutual exclusivity
count if breast_all_pk==. & breast_all_ctr==.
count if breast_all_pk!=. & breast_all_ctr!=.

gen breast = .
replace breast=breast_all_pk if arm==1
replace breast=breast_all_ctr if arm==0

//2 Pink Stomach Cancer
alpha stom_liq_pk stom_wine_pk stom_beer_pk if arm==1, i c a g(stom_all_pk)
summ stom_all_pk
//Control 
alpha stom_liq_ctr stom_wine_ctr stom_beer_ctr if arm==0, i c a g(stom_all_ctr)
summ stom_all_ctr

*Check mutual exclusivity
count if stom_all_pk==. & stom_all_ctr==.
count if stom_all_pk!=. & stom_all_ctr!=.

gen stom= .
replace stom=stom_all_pk if arm==1
replace stom=stom_all_ctr if arm==0

//3 Pink Mouth & Throat Cancer
alpha mouth_liq_pk mouth_wine_pk mouth_beer_pk if arm==1, i c a g(mouth_all_pk)
summ mouth_all_pk
//Control 
alpha mouth_liq_ctr mouth_wine_ctr mouth_beer_ctr if arm==0, i c a g(mouth_all_ctr)
summ mouth_all_ctr

*Check mutual exclusivity
count if mouth_all_pk==. & mouth_all_ctr==.
count if mouth_all_pk!=. & mouth_all_ctr!=.

gen mouth= .
replace mouth=mouth_all_pk if arm==1
replace mouth=mouth_all_ctr if arm==0

//4 Pink Liver Cancer
alpha livercc_liq_pk livercc_wine_pk livercc_beer_pk if arm==1, i c a g(livercc_all_pk)
summ livercc_all_pk
//Control 
alpha livercc_liq_ctr livercc_wine_ctr livercc_beer_ctr if arm==0, i c a g(livercc_all_ctr)
summ livercc_all_ctr

*Check mutual exclusivity
count if livercc_all_pk==. & livercc_all_ctr==.
count if livercc_all_pk!=. & livercc_all_ctr!=.

gen livercc= .
replace livercc=livercc_all_pk if arm==1
replace livercc=livercc_all_ctr if arm==0

//5 Pink Liver Disease
alpha liverdis_liq_pk liverdis_wine_pk liverdis_beer_pk if arm==1, i c a g(liverdis_all_pk)
summ liverdis_all_pk
//Control 
alpha liverdis_liq_ctr liverdis_wine_ctr liverdis_beer_ctr if arm==0, i c a g(liverdis_all_ctr)
summ liverdis_all_ctr

*Check mutual exclusivity
count if liverdis_all_pk==. & liverdis_all_ctr==.
count if liverdis_all_pk!=. & liverdis_all_ctr!=.

gen liverdis= .
replace liverdis=liverdis_all_pk if arm==1
replace liverdis=liverdis_all_ctr if arm==0


//6 Pink Hypertension
alpha hyper_liq_pk hyper_wine_pk hyper_beer_pk if arm==1, i c a g(hyper_all_pk)
summ hyper_all_pk
//Control 
alpha hyper_liq_ctr hyper_wine_ctr hyper_beer_ctr if arm==0, i c a g(hyper_all_ctr)
summ hyper_all_ctr

*Check mutual exclusivity
count if hyper_all_pk==. & hyper_all_ctr==.
count if hyper_all_pk!=. & hyper_all_ctr!=.


gen hyper= .
replace hyper=hyper_all_pk if arm==1
replace hyper=hyper_all_ctr if arm==0


//Combine pink+control variables

gen purchase= .
replace purchase=purchase_pk if arm==1
replace purchase=purchase_ctr if arm==0

gen mislead= .
replace mislead=mislead_pk if arm==1
replace mislead=mislead_ctr if arm==0

gen policy= .
replace policy=policy_pk if arm==1
replace policy=policy_ctr if arm==0


save "$Data/Stata/Dataset_clean_nonrepeated.dta", replace

