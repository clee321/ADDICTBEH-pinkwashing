*Analysis Parent File

*Replace xxx with your Stata username
	*If you forgot your username, use the following command: [display "`c(username)'"] 
*Replace yyy with the applicable folder location

*User file paths
if "`c(username)'" =="xxx" {
	global Data 	"/yyy/Project folders-files/Data"
	global Analysis "/yyy/Project folders-files/Analysis"
	global Code 	"/yyy/ADDICTBEH-pinkwashing/Stata code"
}

*************
*Run the codes below:

*Data cleaning and preparation
run "$Code/1.1_Data cleaning_reshaped as long.do"
run "$Code/1.2_Prepare data for nonrepeated measures.do"
run "$Code/1.3_Prepare data for demo table.do"

*Data analysis - part 1: Descriptive statistcs
run "$Code/2.1_Descriptive stats_overall.do"
run "$Code/2.2_Descriptive stats_by arm.do"
run "$Code/2.3_Descriptive disease risks_by arm.do"

*Data analysis - part 2: Regression analysis
run "$Code/3_OLS Regression.do"
run "$Code/4_LMER.do"

