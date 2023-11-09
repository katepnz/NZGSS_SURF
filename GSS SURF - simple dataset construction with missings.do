cd "INSERT YOUR FOLDER LOCATION HERE"
label drop _all

insheet using "FILE_PATHWAY_HERE/GSS_SURF_2018_2021_ORIGINAL.txt", clear

*** Revising all variables to be numeric, including converting binary variables to 0/1 variables
* Age group
encode age, gen(age_temp)
drop age
rename age_temp age
label define agel 1 "1 15-24 years" 2 "2 25-34 years" 3 "3 35-44 years" 4 "4 45-54 years" 5 "5 55-64 years" 6 "6 65 years+" 
label values age agel

* Sex
encode sex, gen(sex_temp)
drop sex
rename sex_temp sex
replace sex=0 if sex==2
replace sex=2 if sex==3
label define sexl 0 "0 Male" 1 "1 Female" 2 "2 Other"
label values sex sexl

* Prioritised ethnicity 
encode ethnicity, gen(ethnicity_temp)
drop ethnicity
rename ethnicity_temp ethnicity

* Educational attainment 
replace education="77" if education=="DK"
replace education="99" if education=="NE"
replace education="88" if education=="RF"
destring education, replace
gen edu=1 if education>=0 & education<=3
	replace edu=2 if education==4 | education==11
	replace edu=3 if education>4 & education<=6
	replace edu=4 if education>6 & education<=10
	replace edu=education if edu==.
drop education
label define edul 1 "1 Less than secondary school completion/NCEA L4" 2 "2 Secondary school completion/NCEA L4" 3 "3 Post-secondary school NCEA or diploma" 4 "4 Bachelor's degree +" 77 "77 Don't know" 88 "88 Refused" 99 "99 Not elsewhere"
label values edu edul

* Labour force status
rename labourforcestatus lfs
label define lfsl 1 "1 Employed" 2 "2 Unemployed" 3 "3 Not in the labour force"
label values lfs lfsl

* Partner status
rename partneredstatus partner
replace partner=0 if partner==2
label define partnerl 0 "0 Not partnered" 1 "Partnered"
label values partner partnerl

* Parent status
encode parentalstatus, gen(parent)
drop parentalstatus
replace parent=0 if parent==2
label define parentl 0 "0 Not a parent" 1 "1 Parent"
label values parent parentl

* Number of dependent children in the home
replace dependentchild="99" if dependentchild=="PP"
destring dependentchild, replace
rename dependentchildren number_children
replace number_children=0 if number_children==99 // where respondent is not a parent
replace number_children=4 if number_children>=5 & number_children<=10
label define numkidl 0 "0 children" 1 "1 child" 2 "2 children" 3 "3 children" 4 "4+ children"
label values number_children numkidl

* Recoding parent status if no children in the home
replace parent=0 if number_children==0

* Tenure: simplifying
replace tenure = 1 if tenure==10 | tenure==11 | tenure==30 | tenure==31 
replace tenure = 2 if tenure==12 | tenure==32
replace tenure = 3 if tenure==20 | tenure==21 | tenure==22 
label define tenurel 1 "1 Own home, with mortgage" 2 "2 Own home, without mortgage" 3 "3 Rents home" 77 "77 Don't know"
label values tenure tenurel

* Household income
encode householdincome, gen(hh_income)
drop householdincome

* Deprivation index
rename deprivationindex nzdep
label define nzdepl 1 "1 - least deprived" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10 - most deprived" 77 "77 Don't know" 
label values nzdep nzdepl

* Migrant status -- collapsing some groups due to small cell sizes and missing for ease of use
rename migrantstatus migrant
replace migrant=99 if migrant==77
label define migrantl 1 "1 NZ-born with NZ-born parents" 2 "2 NZ-born with at least one parent born overseas" 3 "3 NZ-born with parents birthplace unknown" 4 "4 Recent migrant" 5 "5 Medium-term migrant" 6 "6 Long-term migrant" 77 "77 Don't know" 88 "88 Refused" 99 "99 Not stated"
label values migrant migrantl

* Disability status
rename disabilitystatus disability
replace disability=0 if disability==2
label define disabilityl 0 "0 Not disabled" 1 "1 Disabled"
label values disability disabilityl

* Housing affordability -- putting "don't know" at the midpoint for ease of use
replace housingaffordability="77" if housingaffordability=="DK"
replace housingaffordability="88" if housingaffordability=="RF"
destring housingaffordability, replace
rename housingaffordability home_afford
label define home_affordl 0 "0 Very unaffordable" 10 "10 very affordable" 77 "77 Don't know" 88 "88 Refused" 99 "99 Not elsewhere"
label values home_afford home_affordl

* Life satisfaction -- putting "don't know" at the midpoint for ease of use
replace mentalwellbeing="77" if mentalwellbeing=="DK" 
replace mentalwellbeing="88" if mentalwellbeing=="RF"
destring mentalwellbeing, replace
rename mentalwellbeing life_satisfy
label define life_satisfyl 0 "0 Completely dissatisfied" 10 "10 Completely satisfied" 77 "77 Don't know" 88 "88 Refused" 99 "99 Not elsewhere"
label values life_satisfy life_satisfyl

* Life worthwhile -- putting "don't know" at midpoint for each of use
replace lifesatisfaction="77" if lifesatisfaction=="DK" 
replace lifesatisfaction="88" if lifesatisfaction=="RF"
destring lifesatisfaction, replace
rename lifesatisfaction life_worth
label define life_worthl 0 "0 Not at all worthwhile" 10 "10 Completely worthwhile" 77 "77 Don't know" 88 "88 Refused" 99 "99 Not elsewhere"
label values life_worth life_worthl

* Global health scale - replace one case of "DK" as okay health for ease of use
replace overallhealth="77" if overallhealth=="DK"
replace overallhealth="88" if overallhealth=="RF"
destring overallhealth, replace
recode overallhealth (11 = 5) (12 = 4) (13 = 3) (14 = 2) (15 = 1)
rename overallhealth health
label define healthl 1 "1 Poor" 2 "2 Fair" 3 "3 Good" 4 "4 Very good" 5 "5 Excellent" 77 "77 Don't know" 88 "88 Refused" 99 "99 Not elsewhere"
label values health healthl

* Te reo fluency
replace tereofluency="77" if tereofluency=="DK"
replace tereofluency="88" if tereofluency=="RF"
destring tereofluency, replace
recode tereofluency (11 = 4) (12 = 4) (13 = 3) (14 = 2) (15 = 1)
rename tereofluency tereo
label define tereol 1 "1 No more than a few words" 2 "2 Not very well" 3 "3 Fairly well" 4 "4 Well or very well" 77 "77 Don't know" 88 "88 Refused" 99 "99 Not elsewhere"
label values tereo tereol

* Should government support te reo in daily situations
replace govsupporttereo="77" if govsupporttereo=="DK"
replace govsupporttereo="88" if govsupporttereo=="RF"
destring govsupporttereo, replace
recode govsupporttereo (11 = 5) (12 = 4) (13 = 3) (14 = 2) (15 = 1)
rename govsupporttereo gov_tereo
label define gov_tereol 1 "1 Strongly disagree" 2 "2 Disagree" 3 "3 Neither agree nor disagree" 4 "4 Agree" 5 "5 Strongly agree" 77 "77 Don't know" 88 "88 Refused" 99 "99 Not elsewhere"
label values gov_tereo gov_tereol

* Self-actualisation
recode selfactualisation (11 = 5) (12 = 4) (13 = 3) (14 = 2) (15 = 1)
rename selfactualisation selfactual
label define selfactuall 1 "1 Very hard" 2 "2 Hard" 3 "3 Sometimes easy, sometimes hard" 4 "4 Easy" 5 "5 Very easy" 77 "77 Don't know" 88 "88 Refused" 99 "99 Not elsewhere"
label values selfactual selfactuall

* Trust variables
foreach var of varlist generalisedtrust trustmedia trustparliament {
	replace `var'="77" if `var'=="DK"
	replace `var'="88" if `var'=="RF"
	destring `var', replace
}
rename generalisedtrust trust
rename trustpolice trust_police 
rename trustmedia trust_media
rename trustparliament trust_parliament
label define trustl 0 "0 Not at all" 10 "10 Completely" 77 "77 Don't know" 88 "88 Refused" 99 "99 Not elsewhere"
foreach var of varlist trust trust_police trust_media trust_parliament {
	label values `var' trustl
}
 
* Voted last election
replace votedlastelection="77" if votedlastelection=="DK" 
replace votedlastelection="88" if votedlastelection=="RF"
replace votedlastelection="99" if votedlastelection=="NE"
destring votedlastelection, replace
rename votedlastelection voted
recode voted (2 = 0) 
label define votedl 0 "0 Did not vote" 1 "1 Did vote" 77 "77 Don't know" 88 "88 Refused" 99 "99 Not eligible to vote"
label values voted votedl

* Material wellbeing
rename materialwellbeing mwb
label define mwbl 0 "0 Very low material wellbeing" 20 "20 Very high material wellbeing" 77 "77 Missing data"
label values mwb mwbl

* House coldness
replace housecoldness="77" if housecoldness=="DK"
destring housecoldness, replace
recode housecoldness (11 = 4) (12 = 3) (13 = 2) (14 = 1) (15 = 99)
rename housecoldness housecold
label define housecoldl 1 "1 No" 2 "2 Yes, sometimes" 3 "3 Yes, often" 4 "4 Yes, always" 77 "77 Don't know" 88 "88 Refused" 99 "99 Not spent a winter in this house/flat"
label values housecold housecoldl

* House dampness
replace housedampness="77" if housedampness=="DK"
destring housedampness, replace
recode housedampness (11 = 3) (12 = 2) (13 = 1)
rename housedampness housedamp
label define housedampl 1 "1 No, not damp" 2 "2 Yes, sometimes" 3 "3 Yes, always" 77 "77 Don't know" 
label values housedamp housedampl

* Residential mobility
replace residentialmobility="99" if residentialmobility=="NE"
destring residentialmobility, replace
replace residentialmobility=4 if residentialmobility>4 & residentialmobility<50
rename residentialmobility moves
label define movesl 0 "0 moves" 1 "1 move" 2 "2 moves" 3 "3 moves" 4 "4+ moves" 77 "77 Don't know" 88 "88 Refused" 99 "99 Not eligible"
label values moves movesl

* Access to nearest medical centre/doctor, public park/greenspace, and public transport
foreach var of varlist medicalaccess greenspaceaccess publictransportaccess {
replace `var'="77" if `var'=="DK"
destring `var', replace
recode `var' (11 = 5) (12 = 4) (13 = 3) (14 = 2) (15 = 1) (77 = 77)
}
rename medicalaccess access_med
rename greenspaceaccess access_green
rename publictransportaccess access_pt
label define accessl 1 "1 Very difficult" 2 "2 Difficult" 3 "3 Neither easy or difficult" 4 "4 Easy" 5 "5 Very easy" 77 "77 Don't know"
label values access_med accessl
label values access_green accessl
label values access_pt accessl

* Neighbourhood connection
replace neighbourhoodconnect="77" if neighbourhoodconnect=="DK"
destring neighbourhoodconnect, replace
rename neighbourhoodconnect neigh_connect
label define neigh_connectl 0 "0 No sense of connection" 10 "10 Very strong sense of connection" 77 "77 Don't know" 
label values neigh_connect neigh_connectl

* Neigbourhood crime
replace neighbourhoodcrime="77" if neighbourhoodcrime=="DK"
destring neighbourhoodcrime, replace
rename neighbourhoodcrime neigh_crime
recode neigh_crime (17 = 9) (16 = 8) (15 = 1) (14 = 2) (13 = 3) (12 = 4) (11 = 5)
label define neigh_crimel 1 "1 A lot less crime" 2 "2 A little less crime" 3 "3 About the same" 4 "4 A little more crime" 5 "5 A lot more crime" 8 "8 No crime around here" 9 "9 Haven't lived in the neighbourhood for 12 months" 77 "77 Don't know" 
label values neigh_crime neigh_crimel

* Victim of crime
replace victimofcrime="99" if victimofcrime=="NE"
replace victimofcrime="77" if victimofcrime=="DK"
rename victimofcrime victim
destring victim, replace
recode victim (2 = 0) (1 = 1)
label define victiml 0 "0 Not a crime victim" 1 "1 Victim of crime" 77 "77 Don't know" 88 "88 Refused" 99 "99 Not elsewhere"
label values victim victiml

* Experienced discrimination
replace experienceddiscrim="77" if experienceddiscrim=="DK" 
replace experienceddiscrim="88" if experienceddiscrim=="NE" 
replace experienceddiscrim="99" if experienceddiscrim=="RF"
rename experienceddiscrim discrim
destring discrim, replace
recode discrim (2 = 0) (1 = 1)
label define discriml 0 "0 Not discriminated against" 1 "1 Discriminated against" 77 "77 Don't know" 88 "88 Refused" 99 "99 Not elsewhere" 
label values discrim discriml 

* Loneliness
replace loneliness="77" if loneliness=="DK" 
replace loneliness="88" if loneliness=="RF" 
replace loneliness="99" if loneliness=="NE"
destring loneliness, replace
rename loneliness lonely
recode lonely (11 = 1) (12 = 2) (13 = 3) (14 = 4) (15 = 5)
label define lonelyl 1 "1 None of the time" 2 "2 A little of the time" 3 "3 Some of the time" 4 "4 Most of the time" 5 "5 All of the time" 77 "77 Don't know" 88 "88 Refused" 99 "99 Not elsewhere"
label values lonely lonelyl

* Hard to talk to others
replace sympatheticear="77" if sympatheticear=="DK" 
replace sympatheticear="88" if sympatheticear=="RF" 
replace sympatheticear="99" if sympatheticear=="NE"
rename sympatheticear hardtalk
destring hardtalk, replace
recode hardtalk (11 = 1) (12 = 2) (13 = 3) (14 = 4) (15 = 5) (16 = 6)
label define hardtalkl 1 "1 Very easy" 2 "2 Easy" 3 "3 Sometimes easy, sometimes hard" 4 "4 Hard" 5 "5 Very hard" 6 "6 I wouldn't talk to anyone" 77 "77 Don't know" 88 "88 Refused" 99 "99 Not elsewhere"
label values hardtalk hardtalkl

* reordering variables to match codebook order
order id surfweight year age sex ethnicity edu lfs partner parent number_children tenure ///
hh_income nzdep migrant disability home_afford life_satisfy life_worth health tereo ///
gov_tereo selfactual trust trust_police trust_media trust_parliament voted mwb ///
housecold housedamp moves access_med access_green access_pt neigh_connect neigh_crime ///
victim discrim lonely hardtalk

save GSS_SURF_2018_2021_with_missing, replace
outsheet using "GSS_SURF_2018_2021_with_missing.csv", nolabel comma replace
