*Descriptive stats - overall

use "$Data/Stata/Dataset_clean_nonrepeated_demo.dta", clear

**#Overall sample table

	putexcel set "$Analysis/Demo table/Demo_table.xlsx", modify

	putexcel A4 = "Participant Characteristics"
	putexcel B2 = "All (n=XYZ)"
	putexcel B3 = "n"
	putexcel C3 = "(%)"
	putexcel D3 = "Total sample"

	//concatenated
	putexcel N2 = "All"
	putexcel N3 = "N (%)"


**#Age

	local row=5

	local var agecat
		local varlabel : var label `var'
		putexcel A`row' = ("`varlabel'")
			local ++row
			
		tabulate `var', matcell(`var'freq) matrow(`var'names)
			putexcel A`row'= matrix(`var'names) 
			putexcel B`row'=matrix(`var'freq) 
			putexcel C`row'=matrix(`var'freq/r(N)), nformat(percent)
			putexcel D`row'=`r(N)'
		
			local rows = rowsof(`var'names)
			forval i=1/`rows'   {
				local value = `var'names[`i',1]
				local valuelab : label (`var') `value'
				putexcel A`row'=("`valuelab'")
				
			putexcel N`row' = formula(CONCATENATE(B`row',"  (",TEXT(C`row',"0.0%"),")"))
				local ++row
				display "row is `row'"
			}

			
**#Age mean

	sum Z50_Age
	scalar mn = r(mean)
	scalar sd = r(sd)
	scalar tt = r(N)

	putexcel A`row' = "Mean (SD)"
	putexcel B`row' = mn, nformat(number_d2)
	putexcel C`row' = sd, nformat(number_d2)
	putexcel D`row' = tt
	putexcel N`row' = formula(CONCATENATE(TEXT(B`row',"0.0"),"  (",TEXT(C`row',"0.0"),")"))

	local ++row

	
**#Gender	

	local var Z20_Gen
		local varlabel : var label `var'
		putexcel A`row' = ("`varlabel'")
			local ++row
			
		tabulate `var', matcell(`var'freq) matrow(`var'names)
			putexcel A`row'= matrix(`var'names) 
			putexcel B`row'=matrix(`var'freq) 
			putexcel C`row'=matrix(`var'freq/r(N)), nformat(percent)
			putexcel D`row'=`r(N)'
		
			local rows = rowsof(`var'names)
			forval i=1/`rows'   {
				local value = `var'names[`i',1]
				local valuelab : label (`var') `value'
				putexcel A`row'=("`valuelab'")
				
			putexcel N`row' = formula(CONCATENATE(B`row',"  (",TEXT(C`row',"0.0%"),")"))
				local ++row
				display "row is `row'"
			}
	 
	 
**#Race and Ethnicity

	putexcel A`row' = "Race"
	local ++row
	
	foreach var of varlist race_white-race_other Z60_HispEthn{
		describe `var'
		local varlabel : var label `var'
		putexcel A`row' = ("`varlabel'")
		
		//Count
		count if `var'==1
		scalar freq = r(N)
		putexcel B`row' = freq
		
		sum `var'
		scalar ttl = r(N)
		//Percentage
		putexcel C`row' = freq/ttl, nformat(percent)
		putexcel D`row' = ttl
		
		putexcel N`row' = formula(CONCATENATE(B`row',"  (",TEXT(C`row',"0.0%"),")"))

		local ++row		
	}

	
**#Education, Income

	foreach var of varlist educat incomecat{
		
		local varlabel : var label `var'
		putexcel A`row' = ("`varlabel'")
			local ++row
			
		tabulate `var', matcell(`var'freq) matrow(`var'names)
			putexcel A`row'= matrix(`var'names) 
			putexcel B`row'=matrix(`var'freq) 
			putexcel C`row'=matrix(`var'freq/r(N)), nformat(percent)
			putexcel D`row'=`r(N)'
		
			local rows = rowsof(`var'names)
			forval i=1/`rows'   {
				local value = `var'names[`i',1]
				local valuelab : label (`var') `value'
				putexcel A`row'=("`valuelab'")
				
			putexcel N`row' = formula(CONCATENATE(B`row',"  (",TEXT(C`row',"0.0%"),")"))
				local ++row
				display "row is `row'"
			}
	}
	
	
**#Household mean

	sum Z90_Household
	scalar mn = r(mean)
	scalar sd = r(sd)
	scalar tt = r(N)

	putexcel A`row' = "Number of people in household, Mean (SD)"
	putexcel B`row' = mn, nformat(number_d2)
	putexcel C`row' = sd, nformat(number_d2)
	putexcel D`row' = ttl
	putexcel N`row' = formula(CONCATENATE(TEXT(B`row',"0.0"),"  (",TEXT(C`row',"0.0"),")"))

	local ++row


**#Binge and Past Use
	foreach var of varlist bingecat pastcat{
		
		local varlabel : var label `var'
		putexcel A`row' = ("`varlabel'")
			local ++row
			
		tabulate `var', matcell(`var'freq) matrow(`var'names)
			putexcel A`row'= matrix(`var'names) 
			putexcel B`row'=matrix(`var'freq) 
			putexcel C`row'=matrix(`var'freq/r(N)), nformat(percent)
			putexcel D`row'=`r(N)'
		
			local rows = rowsof(`var'names)
			forval i=1/`rows'   {
				local value = `var'names[`i',1]
				local valuelab : label (`var') `value'
				putexcel A`row'=("`valuelab'")
				
			putexcel N`row' = formula(CONCATENATE(B`row',"  (",TEXT(C`row',"0.0%"),")"))
				local ++row
				display "row is `row'"
			}
	}
			
			
