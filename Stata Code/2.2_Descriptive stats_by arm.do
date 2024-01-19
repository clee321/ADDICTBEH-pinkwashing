use "$Data/Stata/Dataset_clean_nonrepeated_demo.dta", clear

**#Descriptive stats by study arm

**Set up different column values for each arm

forval arm=0/1{
	global t=`arm'

	if $t ==0{ //control
		global c=5
		global m=15
	}
	
	else if $t ==1{ //pink
		global c=10
		global m=16
	}

		putexcel set "$Analysis/Demo table/Demo_table.xlsx", modify
		
		local ncol=$c
		local col1 : word `ncol' of `c(ALPHA)'
		local col : word `ncol' of `c(ALPHA)'
				
		local ncol2=$c+1
		local col2 : word `ncol2' of `c(ALPHA)'
				
		local ncol3=$c+2
		local col3 : word `ncol3' of `c(ALPHA)'
				
		local ncolm=$m
		local colm : word `ncolm' of `c(ALPHA)'	
		

		putexcel F2 = "Control (n=XYZ)"
		putexcel F3 = "n"
		putexcel G3 = "(%)"
		putexcel H3 = "Total sample"

		putexcel K2 = "Pinkwashing (n=XYZ)"
		putexcel K3 = "n"
		putexcel L3 = "(%)"
		putexcel M3 = "Total sample"

		//concatenated

		putexcel O2 = "Control"
		putexcel O3 = "N (%)"

		putexcel P2 = "Pinkwashing"
		putexcel P3 = "N (%)"
	
	local row=5

		
**#Age

	local var agecat
		local varlabel : var label `var'
		putexcel `col'`row' = ("`varlabel'")
			local ++row		
			
			local ncol=$c
			local col : word `ncol' of `c(ALPHA)'
		
			tabulate `var' if arm==$t, matcell(`var'freq) matrow(`var'names)
				putexcel `col'`row'= matrix(`var'names) 
					local ++ncol
					local col : word `ncol' of `c(ALPHA)'
				putexcel `col'`row'=matrix(`var'freq) 
					local ++ncol
					local col : word `ncol' of `c(ALPHA)'
				putexcel `col'`row'=matrix(`var'freq/r(N)), nformat(percent)
					local ++ncol
					local col : word `ncol' of `c(ALPHA)'
				putexcel `col'`row'=`r(N)'
			
			local rows = rowsof(`var'names)
			forval i=1/`rows'   {
				local value = `var'names[`i',1]
				local valuelab : label (`var') `value'
				putexcel `col1'`row'=("`valuelab'")
				
			putexcel `colm'`row' = formula(CONCATENATE(`col2'`row',"  (",TEXT(`col3'`row',"0.0%"),")"))
					
				local ++row
				display "row is `row'"
			}
   
			
**#Age mean

	local ncol=$c
	local col : word `ncol' of `c(ALPHA)'
	
	sum Z50_Age if arm==$t
	scalar mn = r(mean)
	scalar sd = r(sd)
	scalar tt = r(N)

	putexcel `col'`row' = "Mean (SD)"
		local ++ncol
		local col : word `ncol' of `c(ALPHA)'
	putexcel `col'`row' = mn, nformat(number_d2)
		local ++ncol
		local col : word `ncol' of `c(ALPHA)'
	putexcel `col'`row' = sd, nformat(number_d2)
		local ++ncol
		local col : word `ncol' of `c(ALPHA)'
	putexcel `col'`row' = tt
		local ++ncol
		local col : word `ncol' of `c(ALPHA)'
		
	putexcel `colm'`row' = formula(CONCATENATE(TEXT(`col2'`row',"0.0"),"  (",TEXT(`col3'`row',"0.0"),")"))

	local ++row


**#Gender	

	local ncol=$c
	local col : word `ncol' of `c(ALPHA)'
	
	 local var Z20_Gen
		local varlabel : var label `var'
		putexcel `col'`row' = ("`varlabel'")
			local ++row		
		
		tabulate `var' if arm==$t, matcell(`var'freq) matrow(`var'names)
				putexcel `col'`row'= matrix(`var'names) 
					local ++ncol
					local col : word `ncol' of `c(ALPHA)'
				putexcel `col'`row'=matrix(`var'freq) 
					local ++ncol
					local col : word `ncol' of `c(ALPHA)'
				putexcel `col'`row'=matrix(`var'freq/r(N)), nformat(percent)
					local ++ncol
					local col : word `ncol' of `c(ALPHA)'
				putexcel `col'`row'=`r(N)'
			
			local rows = rowsof(`var'names)
			forval i=1/`rows'   {
				local value = `var'names[`i',1]
				local valuelab : label (`var') `value'
				putexcel `col1'`row'=("`valuelab'")
				
				putexcel `colm'`row' = formula(CONCATENATE(`col2'`row',"  (",TEXT(`col3'`row',"0.0%"),")"))
							
				local ++row
				display "row is `row'"
			}
		

**#Race and Ethnicity

	local ncol=$c
	local col : word `ncol' of `c(ALPHA)'
	
	putexcel `col'`row' = "Race"
	local ++row
	
	foreach var of varlist race_white-race_other Z60_HispEthn {
		local ncol=$c
		local col : word `ncol' of `c(ALPHA)'
		describe `var'
		
		local varlabel : var label `var'
		putexcel `col'`row' = ("`varlabel'")
			local ++ncol
			local col : word `ncol' of `c(ALPHA)'
		
		//Count
		count if `var'==1 & arm==$t
		scalar freq = r(N)
		putexcel `col'`row' = freq
			local ++ncol
			local col : word `ncol' of `c(ALPHA)'
		
		sum `var' if arm==$t
		scalar ttl = r(N)
		
		//Percentage
		putexcel `col'`row' = freq/ttl, nformat(percent)
			local ++ncol
			local col : word `ncol' of `c(ALPHA)'
		putexcel `col'`row' = ttl
		
		putexcel `colm'`row' = formula(CONCATENATE(`col2'`row',"  (",TEXT(`col3'`row',"0.0%"),")"))
		
		local ++row	
	}
	
	
**#Education, Income

	foreach var of varlist educat incomecat{
		local ncol=$c
		local col : word `ncol' of `c(ALPHA)'
	
		local varlabel : var label `var'
		putexcel `col'`row' = ("`varlabel'")
			local ++row		
		
		tabulate `var' if arm==$t, matcell(`var'freq) matrow(`var'names)
				putexcel `col'`row'= matrix(`var'names) 
					local ++ncol
					local col : word `ncol' of `c(ALPHA)'
				putexcel `col'`row'=matrix(`var'freq) 
					local ++ncol
					local col : word `ncol' of `c(ALPHA)'
				putexcel `col'`row'=matrix(`var'freq/r(N)), nformat(percent)
					local ++ncol
					local col : word `ncol' of `c(ALPHA)'
				putexcel `col'`row'=`r(N)'
			
			local rows = rowsof(`var'names)
			forval i=1/`rows'   {
				local value = `var'names[`i',1]
				local valuelab : label (`var') `value'
				putexcel `col1'`row'=("`valuelab'")
				
			putexcel `colm'`row' = formula(CONCATENATE(`col2'`row',"  (",TEXT(`col3'`row',"0.0%"),")"))
					
				local ++row
				display "row is `row'"
			}
	}
	 
	
**#Household mean

	local ncol=$c
	local col : word `ncol' of `c(ALPHA)'
	
	sum Z90_Household if arm==$t
	scalar mn = r(mean)
	scalar sd = r(sd)
	scalar tt = r(N)

	putexcel `col'`row' = "Number of people in household, Mean (SD)"
		local ++ncol
		local col : word `ncol' of `c(ALPHA)'
	putexcel `col'`row' = mn, nformat(number_d2)
		local ++ncol
		local col : word `ncol' of `c(ALPHA)'
	putexcel `col'`row' = sd, nformat(number_d2)
		local ++ncol
		local col : word `ncol' of `c(ALPHA)'
	putexcel `col'`row' = tt
		local ++ncol
		local col : word `ncol' of `c(ALPHA)'
	putexcel `colm'`row' = formula(CONCATENATE(TEXT(`col2'`row',"0.0"),"  (",TEXT(`col3'`row',"0.0"),")"))

	local ++row
	

**#Binge and Past Use

	foreach var of varlist bingecat pastcat{
		local ncol=$c
		local col : word `ncol' of `c(ALPHA)'
	
		local varlabel : var label `var'
		putexcel `col'`row' = ("`varlabel'")
			local ++row		
		
		tabulate `var' if arm==$t, matcell(`var'freq) matrow(`var'names)
				putexcel `col'`row'= matrix(`var'names) 
					local ++ncol
					local col : word `ncol' of `c(ALPHA)'
				putexcel `col'`row'=matrix(`var'freq) 
					local ++ncol
					local col : word `ncol' of `c(ALPHA)'
				putexcel `col'`row'=matrix(`var'freq/r(N)), nformat(percent)
					local ++ncol
					local col : word `ncol' of `c(ALPHA)'
				putexcel `col'`row'=`r(N)'
			
			local rows = rowsof(`var'names)
			forval i=1/`rows'   {
				local value = `var'names[`i',1]
				local valuelab : label (`var') `value'
				putexcel `col1'`row'=("`valuelab'")
				
			putexcel `colm'`row' = formula(CONCATENATE(`col2'`row',"  (",TEXT(`col3'`row',"0.0%"),")"))
					
				local ++row
				display "row is `row'"
			}
	}
}
