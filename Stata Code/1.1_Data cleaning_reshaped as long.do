**Data Cleaning
**Transform to a long shape, define arms, rename and recode variables

import excel "$Data/Raw data.xlsx", firstrow clear

**#Exclusion criteria
*Qualtrics excluded ineligible data (see Methods section)

**#Define Arms
*Check if arms are mutually exclusive
count if A10_a!=. & A15_a!=.
count if A10_a==. & A15_a==.

*Generate Arms
gen arm=.
replace arm=1 if A10_a!=. & A15_a==. //pink, experimental arm (298 counts)
replace arm=0 if A10_a==. & A15_a!=. //control arm (304 counts)

**#Reshape wide to long
reshape long A10_ A15_ A20_ A25_ A30_ A35_ A40_ A45_, i(transaction_id) j(bev) string 

replace bev="liquor" if bev=="a"
replace bev="beer" if bev=="b"
replace bev="wine" if bev=="c"

**#Combine A10+15, A20+A25, A30+35, A40+45
gen fam=.
replace fam=A10_ if arm==1
replace fam=A15_ if arm==0
lab var fam "Brand Familiarity"

gen health=.
replace health=A20_ if arm==1
replace health=A25_ if arm==0
lab var health "Healthfulness"

gen socresp=.
replace socresp=A30_ if arm==1
replace socresp=A35_ if arm==0
lab var socresp "Social Responsability"

gen fav=.
replace fav=A40_ if arm==1
replace fav=A45_ if arm==0
lab var fav "Favorable Attitudes"

**#Labeling the other variables

*PINK
rename Q274 A50
lab var A50 "Purchase Pink"
rename A50 purchase_pk

lab var A60_1 "BreastCancer Wine Pink"
rename A60_1 breast_wine_pk
lab var A60_2 "StomachCancer Wine Pink"
rename A60_2 stom_wine_pk
lab var A60_3 "MouthThrCancer Wine Pink"
rename A60_3 mouth_wine_pk
lab var A60_4 "LiverCancer Wine Pink"
rename A60_4 livercc_wine_pk
lab var A60_5 "LiverDisease Wine Pink"
rename A60_5 liverdis_wine_pk
lab var A60_6 "Hypertension Wine Pink"
rename A60_6 hyper_wine_pk

lab var A61_1 "BreastCancer Beer Pink"
lab var A61_2 "StomachCancer Beer Pink"
lab var A61_3 "MouthThrCancer Beer Pink"
lab var A61_4 "LiverCancer Beer Pink"
lab var A61_5 "LiverDisease Beer Pink"
lab var A61_6 "Hypertension Beer Pink"
rename A61_1 breast_beer_pk
rename A61_2 stom_beer_pk
rename A61_3 mouth_beer_pk
rename A61_4 livercc_beer_pk
rename A61_5 liverdis_beer_pk
rename A61_6 hyper_beer_pk

lab var A62_1 "BreastCancer Liquor Pink"
lab var A62_2 "StomachCancer Liquor Pink"
lab var A62_3 "MouthThrCancer Liquor Pink"
lab var A62_4 "LiverCancer Liquor Pink"
lab var A62_5 "LiverDisease Liquor Pink"
lab var A62_6 "Hypertension Liquor Pink"
rename A62_1 breast_liq_pk
rename A62_2 stom_liq_pk
rename A62_3 mouth_liq_pk
rename A62_4 livercc_liq_pk
rename A62_5 liverdis_liq_pk
rename A62_6 hyper_liq_pk

lab var A70 "Misleading Pink"
lab var A80 "Policy Pink"
rename A70 mislead_pk
rename A80 policy_pk

**CONTROL

lab var A55 "Purchase Control"
rename A55 purchase_ctr

lab var A65_1 "BreastCancer Wine Control"
lab var A65_2 "StomachCancer Wine Control"
lab var A65_3 "MouthThrCancer Wine Control"
lab var A65_4 "LiverCancer Wine Control"
lab var A65_5 "LiverDisease Wine Control"
lab var A65_6 "Hypertension Wine Control"
rename A65_1 breast_wine_ctr
rename A65_2 stom_wine_ctr
rename A65_3 mouth_wine_ctr
rename A65_4 livercc_wine_ctr
rename A65_5 liverdis_wine_ctr
rename A65_6 hyper_wine_ctr

lab var A66_1 "BreastCancer Beer Control"
lab var A66_2 "StomachCancer Beer Control"
lab var A66_3 "MouthThrCancer Beer Control"
lab var A66_4 "LiverCancer Beer Control"
lab var A66_5 "LiverDisease Beer Control"
lab var A66_6 "Hypertension Beer Control"
rename A66_1 breast_beer_ctr
rename A66_2 stom_beer_ctr
rename A66_3 mouth_beer_ctr
rename A66_4 livercc_beer_ctr
rename A66_5 liverdis_beer_ctr
rename A66_6 hyper_beer_ctr

lab var A67_1 "BreastCancer Liquor Control"
lab var A67_2 "StomachCancer Liquor Control"
lab var A67_3 "MouthThrCancer Liquor Control"
lab var A67_4 "LiverCancer Liquor Control"
lab var A67_5 "LiverDisease Liquor Control"
lab var A67_6 "Hypertension Liquor Control"
rename A67_1 breast_liq_ctr
rename A67_2 stom_liq_ctr
rename A67_3 mouth_liq_ctr
rename A67_4 livercc_liq_ctr
rename A67_5 liverdis_liq_ctr
rename A67_6 hyper_liq_ctr

lab var A75 "Misleading Control"
lab var A85 "Policy Control"
rename A75 mislead_ctr
rename A85 policy_ctr

**DEMO
lab var Z88_Binge5 "Binge 5 Men/NB/Skip"
lab var Z89_Binge4 "Binge 4 Women"

lab var Z100_1 "Income 19K-38K"
lab var Z100_2 "Income 26K-52K"
lab var Z100_3 "Income 33K-65K"
lab var Z100_4 "Income 39K-79K"
lab var Z100_5 "Income 46K-92K"
lab var Z100_6 "Income 53K-105K"
**etc 
lab var Z100_20 "Income 147K-293K"

**Gender values label
label define gender_Labels 1 "Woman" 2 "Man" 3 "Non-binary" 4 "Self-describe" 5 "Prefer not to say"
label values Z20_Gen gender_Labels

**Sexual Orientation values label
label define sxorient_Labels 1 "Straight" 2 "Gay or Lesbian" 3 "Bisexual" 4 "Self-describe"
label values Z40_SexualOrient sxorient_Labels

**Binge - combine 2 variables in 1 (all genders)
gen binge=.
replace binge=Z89_Binge4 if Z20_Gen==1 //women
replace binge=Z88_Binge5 if Z20_Gen!=1
lab var binge "Days Binge Drinking (all genders)"


save "$Data/Stata/Dataset_clean_long.dta", replace
