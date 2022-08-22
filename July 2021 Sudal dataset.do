// means comment
* means comment
* /// line break for long commands
//clear everything
clear
//change directory
cd "D:\~Drive Share (Rohan)\~~STATA Nov 7, 2020"
//importing data
*syntax 
*import excel "<file_path>",sheet("Data") firstrow
import excel "2077.06.18 SPSS dataset sudal1.xlsx", sheet("Data") firstrow
//browse data
//syntax
*browse
browse
//syntax for browse selecting cases
*browse in 1/20
//browse in 1/20
//editing data
//syntax
*edit
//edit
//labeling or describing variable
//syntax
*label variable <variable_name> "description of variable"
*Note: label variable is STATA command.
label variable Household "Household ID"
//renaming variable
//syntax
*rename <old_variable_name> <new_variable_name>
rename Membersinfamily hhsize
// generating new variable
*syntax: gen new_var = operation to be performed
gen new_var=0
gen age = Age*Age

rename age age2

//dropping variable
*syntax drop <var_name>
drop new_var
drop age2

//count
count if Age>=40
//sort dataset in ascending order
//syntax 
*sort <variable_name>
sort Age
//labeling of value of variables
//syntax
*Step 1: label define गर्ने  ।
*Step 2: label लाई  variable संग टास्ने ।
*label define <label_name> <label_codes> "label_names"
*label values <variable_name> <label_name>
*Note: label define and label values are STATA command.
label define Gender 1"Male" 2"Female"
label values Gender Gender 
//label list <label_name>
label list Gender
//Labeling for Religion
label define Religion 1"Hindiusm" 2"Kirat" 3"Buddhist"
label values Religion Religion
label list Religion
//Labeling for family type
label define Familytype 1"Nuclear" 2"Joint"
label values Familytype Familytype
//Labeling for Education
label def Education 1"Never Attended School" 2"Attended School" ///
3"SLC" 4"Intermediate" 5"Bachelors" 6"Masters"
label values Education Education
//labeling for Area
label def Area 1"Sudal" 2"Koteshwor"
label values Area Area
//Same process of labeling other variables
//Recoding variable Age
//syntax
*recode <variable_name> <(range=code "label")>,gen<new_variable_name>

label define Employment 1"Employed" 2"Unemployed"
label values Employment Employment

recode Age (min/20=1 "Below 20") (20/30=2 "20-30") ///
(30/40=3 "30-40")(40/50=4 "40-50")(50/60=5 "50-60") ///
(60/max=6 "60+"),gen(age_group)
list Age age_group
label var age_group "Grouping of Age"

//Producing tables
*Tables are only generated for Categorical variables (nominal and ordinal)
//one-way tables
tab Gender
tab Gender,missing //if there is missing values
tab Occupation
tab Occupation,missing

tab Religion //display with label name
tab Religion, missing

//I want codes not label
tab Religion, nol
tab Gender,nol //do not display labels
tab Education

//all one-way tables

//tab1 var_1 var_2 var_n
tab1 Gender Education Familytype

//two way tables
**command tab <var_1> <var_2>

tab Gender Education
tab Gender Area

//all two way tables
tab2 Gender Area Gender Education

//two-way table with row percent
tab Gender Education, row
tab Gender Area, row

//two-way table with column percent
tab Gender Education, col
tab Gender Area, col

//two-way table with row percent but no frequency
tab Gender Education, row nofreq
tab Gender Area, row nofreq

//two-way table with column percent but no frequency
tab Gender Education, col nofreq
tab Gender Area, col nofreq

//graph
*bar chart, pie chart, box plot...

graph bar,over(Area) ///
blabel(bar,position(outside) size(11pt)) ///
ylabel(none) ytitle("Percentage") yscale(r(0,70)) ///
title("Percentage of respondents by Area",margin(b=4)) ///
caption("Source: Author's own data") ///
asyvars

graph pie,over(Area)

//box plot

graph box Food_today,over(Area) ///
ylabel(none) ytitle("Food expenses in Rs.") ///
title("Box plot of Food expenses in Sudal and Koteshwor",margin(b=4)) ///
asyvars ///
box(1,color(red)) ///
box(2,color(navy)) ///
legend(size(small) ///
title(Area of respondents,size(medium)))

graph export boxplot.png,replace

//summary statistics
*we will find summary statistics for numerical variables
//it shows obs, mean, sd, Min, max

// syntax sum var_list
sum Food_today Food_10_years_ago Total_expense TotalIncome AverageIncome
//I need detail
sum Food_today,detail

//correlation
*syntax corr var_list

corr Food_today Food_10_years_ago

// lets try another command
*syntax pwcorr var_list

//normal correlation
pwcorr Food_today Food_10_years_ago

//correlation with significance level
pwcorr Food_today Food_10_years_ago,sig

//correlation with significance level in star
pwcorr Food_today Food_10_years_ago,star(0.05) //show star if sig.<0.05

//hypothesis test

//null hypothesis: Hypothesis of no difference

//rule do not reject null if p>0.05

//t test, z test, f-test (ANOVA), Chi2

//t test
//one sample t test (variable: numerical)
//null: food expenses=10000

//p<0.05 we reject our claim.

ttest Food_today=10000

//one sample ttest by group

by Area,sort:ttest Food_today == 10000

//independent sample t test
//null: there is no difference between food expenses in sudal and koteshwor.
//numerical variable and categorical
*syntax: ttest numercial_var,by(categorical variable)

//equal variance
ttest Food_today,by(Area)
//unequal variance
ttest Food_today,by(Area) unequal

//paired t test
//both variables numerical
//null/claim: Food expenses today=Food expenses 10 year ago
ttest Food_today==Food_10_years_ago

//ztest
//ztest valid for large sample but ttest valid for both large and small samples.

//null: food expenses=10000

//p<0.05 we reject our claim.

ztest Food_today=10000

//independent sample z test
//null: there is no difference between food expenses in sudal and koteshwor.
//numerical variable and categorical
*syntax: ttest numercial_var,by(categorical variable)
ztest Food_today,by(Area)

//ANOVA
//extension of independent sample t test
//one numerical and other categorical with more than two categories

//in case of t test
//one numerical and other categorical with only two categories

*syntax anova num_var cat_var
//null: there is no difference between food expenses among religious groups

//p<0.05 reject null or claim

anova Food_today Religion

//Chi2

//when to use it?
//when both variables are categorical
//null: there is no association between Gender and Area

//pvalue<0.05, reject null

tab Gender Area,chi2
//for expected count
tab Gender Area,chi2 expected 

//if expected count is less than 5, then we cannot use pearson chi2. So we need to move to fischer's exact test.

//for fischer test
tab Gender Area,chi2 expected exact

//for log likelihood
tab Gender Area,chi2 expected exact lrchi2

//regression
//multiple linear regresion

*syntax reg num_dep_var ind_vars

//generating new variable

*syntax gen new_var_name = ln(old_var_name) //in case of log transformation
gen ln_food_today=ln(Food_today)

gen ln_avg_income=ln(AverageIncome)
//regression begins

reg ln_food_today i.Area i.Gender Age ln_avg_income

//result interpretation

//area: The food expenses in Koteshwor is 65 percent higher than the food expenses in Sudal. 

//Income: If income increases by 10 percent, then food expenses increases by 1.9 percent. 

//test for multicollinarity and heteroskedasticity

//for multicollinarity

vif

//rule: if vif is less than 10, the model is free from multicollinarity
//for heteroskedasticity
estat hettest

//model is free of heteroskedasticity as Prob value is 0.2719 >0.05.

//for autocorrelation only for time series data
estat dwatson

//logistic regression
*syntax logit cat_dep_var ind_vars

gen gender1=0
replace gender1=1 if Gender==1

//logit coefficients
logit gender1 ln_food_today ln_avg_income i.Area i.Familytype

//odds ratio
logit gender1 ln_food_today ln_avg_income i.Area i.Familytype,or

//test: mispecification test
linktest

//goodness of fit
estat gof

//fitstat
fitstat

//heteroskedasticity and multicollinarity

reg gender1 ln_food_today ln_avg_income i.Area i.Familytype
estat hettest
vif

//logit coefficients
logit gender1 ln_food_today ln_avg_income i.Area i.Familytype
//odds ratio
logit gender1 ln_food_today ln_avg_income i.Area i.Familytype,or
//for marginal effect
mfx,force

//export work from stata to word
//installing package
//ssc install <package_name>
//we will use outreg2
ssc install outreg2

reg ln_food_today i.Area i.Gender Age ln_avg_income
outreg2 using word.doc,label

//logit coefficients
logit gender1 ln_food_today ln_avg_income i.Area i.Familytype
outreg2 using word1.doc,label ctitle(Logit Coeff) replace

//odds ratio
logit gender1 ln_food_today ln_avg_income i.Area i.Familytype,or
outreg2 using word1.doc,label ctitle(Odds ratio) append eform

//for marginal effect
mfx,force
outreg2 using word1.doc,label ctitle(mfx) append mfx
