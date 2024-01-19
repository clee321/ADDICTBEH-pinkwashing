use "$Data/Stata/Dataset_clean_nonrepeated_demo.dta", clear

**#Disease risks by study arm

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

		putexcel set "$Analysis/Demo table/Demo_disease risks_table.xlsx", modify
		
		local ncol=$c
		local col1 : word `ncol' of `c(ALPHA)'
		local col : word `ncol' of `c(ALPHA)'
				
		local ncol2=$c+1
		local col2 : word `ncol2' of `c(ALPHA)'
				
		local ncol3=$c+2
		local col3 : word `ncol3' of `c(ALPHA)'
				
		local ncolm=$m
		local colm : word `ncolm' of `c(ALPHA)'	
		
		putexcel D1 = "Disease risk perceptions and non-repeated variables"
		
		putexcel F2 = "Control (n=XYZ)"
		putexcel F3 = "mean"
		putexcel G3 = "(SD)"
		putexcel H3 = "Total sample"

		putexcel K2 = "Pinkwashing (n=XYZ)"
		putexcel K3 = "mean"
		putexcel L3 = "(SD)"
		putexcel M3 = "Total sample"

		//concatenated

		putexcel O2 = "Control"
		putexcel O3 = "Mean (SD)"

		putexcel P2 = "Pinkwashing"
		putexcel P3 = "Mean (SD)"
	
	local row=5

		
**#Breast cancer

foreach var of varlist breast stom mouth livercc liverdis hyper purchase mislead policy {
	local ncol=$c
	local col : word `ncol' of `c(ALPHA)'
	describe `var'
	
	sum `var' if arm==$t
	scalar mn = r(mean)
	scalar sd = r(sd)
	scalar tt = r(N)

	putexcel `col'`row' = "`var'"
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
		
	putexcel `colm'`row' = formula(CONCATENATE(TEXT(`col2'`row',"0.00"),"  (",TEXT(`col3'`row',"0.00"),")"))

	local ++row
}
}

*Cross tab breast x arm

gen breast_gp = . //group breast results for cross tab
replace breast_gp = 1 if breast < 3 & breast !=.
replace breast_gp = 3 if breast == 3 & breast !=.
replace breast_gp = 5 if breast > 3 & breast !=.

label define breastgp_lab 1 "believes it decreases risk" 3 "believes there is no effect" 5 "believes it increases risk" 
label values breast_gp breastgp_lab

label define arm_lab 0 "control" 1 "pinkwashing"
label values arm arm_lab

tab breast_gp arm

putexcel set "$Analysis/Demo table/Demo_disease risks_table.xlsx", sheet ("breast cross tab") modify
			
putexcel B1 = "Control"
putexcel F1 = "Pinkwashing"			

foreach var in breast_gp{		
local row=2
tab breast_gp if arm==0, matcell(`var'freq) matrow(`var'names)
			putexcel A`row'= matrix(`var'names) 
			putexcel B`row'=matrix(`var'freq) 
			putexcel C`row'=matrix(`var'freq/r(N)), nformat(percent)
			putexcel D`row'=`r(N)'
		
			local rows = rowsof(`var'names)
			forval i=1/`rows'   {
				local value = `var'names[`i',1]
				local valuelab : label (`var') `value'
				putexcel A`row'=("`valuelab'")
				
			local ++row
			}
			
local row=2
tab breast_gp if arm==1, matcell(`var'freq) matrow(`var'names)
			putexcel E`row'= matrix(`var'names) 
			putexcel F`row'=matrix(`var'freq) 
			putexcel G`row'=matrix(`var'freq/r(N)), nformat(percent)
			putexcel H`row'=`r(N)'
		
			local rows = rowsof(`var'names)
			forval i=1/`rows'   {
				local value = `var'names[`i',1]
				local valuelab : label (`var') `value'
				putexcel E`row'=("`valuelab'")
				
			local ++row
			}

}

