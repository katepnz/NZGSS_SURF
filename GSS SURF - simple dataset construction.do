cd "INSERT YOUR FOLDER LOCATION HERE"
label drop _all

insheet using "FILE_PATHWAY_HERE/GSS_SURF_2018_2021_ORIGINAL.txt", clear

*** Revising all variables to be numeric, including converting binary variables to 0/1 variables
* Dropping replicate weights (retaining final survey weight)
drop surfweight_1 - surfweight_100

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
replace education="4" if education=="DK"
replace education="4" if education=="NE"
replace education="3" if education=="RF"
destring education, replace
gen edu=1 if education>=0 & education<=3
	replace edu=2 if education==4 | education==11
	replace edu=3 if education>4 & education<=6
	replace edu=4 if education>6 & education<=10
drop education
label define edul 1 "1 Less than secondary school completion/NCEA L4" 2 "2 Secondary school completion/NCEA L4" 3 "3 Post-secondary school NCEA or diploma" 4 "4 Bachelor's degree +"
label values edu edul

* Labour force status
rename labourforcestatus lfs
label define lfsl 1 "1 Employed" 2 "2 Unemployed" 3 "3 Not in the labour force"
label values lfs lfsl

* Partner status
rename partneredstatus partner
replace partner=0 if partner==2
label define partnerl 0 "0 Not partnered" 1 "1 Partnered"
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
replace tenure = 3 if tenure==20 | tenure==21 | tenure==22 | tenure==77 // coding the four people missing info (=77) as a renter for ease of use
label define tenurel 1 "1 Own home, with mortgage" 2 "2 Own home, without mortgage" 3 "3 Rents home"
label values tenure tenurel

* Household income
encode householdincome, gen(hh_income)
drop householdincome

* Deprivation index
replace deprivationindex=5 if deprivationindex==77 // coding three people missing info (=77) as the mean for ease of use
rename deprivationindex nzdep
label define nzdepl 1 "1 - least deprived" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10 - most deprived"
label values nzdep nzdepl

* Migrant status
rename migrantstatus migrant
replace migrant=1 if migrant==77 // coding 16 people with missing info (=77) as NZ born for ease of use
label define migrantl 1 "1 NZ-born with NZ-born parents" 2 "2 NZ-born with at least one parent born overseas" 3 "3 NZ-born with parents birthplace unknown" 4 "4 Recent migrant" 5 "5 Medium-term migrant" 6 "6 Long-term migrant" 
label values migrant migrantl

* Disability status
rename disabilitystatus disability
replace disability=0 if disability==2
label define disabilityl 0 "0 Not disabled" 1 "1 Disabled"
label values disability disabilityl

* Housing affordability -- putting "don't know" at the midpoint for ease of use
replace housingaffordability="07" if housingaffordability=="DK" | housingaffordability=="RF" // coding 12 people who said don't know (=DK) or refused to say (=RF) at median value for ease of use
destring housingaffordability, replace
rename housingaffordability home_afford
label define home_affordl 0 "0 Very unaffordable" 10 "10 Very affordable"
label values home_afford home_affordl

* Life satisfaction -- putting "don't know" at the midpoint for ease of use
replace mentalwellbeing="08" if mentalwellbeing=="DK" | mentalwellbeing=="RF" // coding 7 people who said don't know (=DK) or refused to say (=RF) at median value for ease of use
destring mentalwellbeing, replace
rename mentalwellbeing life_satisfy
label define life_satisfyl 0 "0 Completely dissatisfied" 10 "10 Completely satisfied"
label values life_satisfy life_satisfyl

* Life worthwhile -- putting "don't know" at midpoint for each of use
replace lifesatisfaction="08" if lifesatisfaction=="DK" | lifesatisfaction=="RF" // coding 8 people who said don't know (=DK) or refused to say (=RF) at median value for ease of use
destring lifesatisfaction, replace
rename lifesatisfaction life_worth
label define life_worthl 0 "0 Not at all worthwhile" 10 "10 Completely worthwhile"
label values life_worth life_worthl

* Global health scale - replace one case of "DK" as okay health for ease of use
replace overallhealth="13" if overallhealth=="DK" | overallhealth=="RF" // coding 2 people who said don't know (=DK) or refused to say (=RF) at median value for ease of use
destring overallhealth, replace
recode overallhealth (11 = 5) (12 = 4) (13 = 3) (14 = 2) (15 = 1)
rename overallhealth health
label define healthl 1 "1 Poor" 2 "2 Fair" 3 "3 Good" 4 "4 Very good" 5 "5 Excellent"
label values health healthl

* Te reo fluency
replace tereofluency="15" if tereofluency=="DK" | tereofluency=="RF" // coding 9 people who said don't know (=DK) or refused to say (=RF) at median value for ease of use
destring tereofluency, replace
recode tereofluency (11 = 4) (12 = 4) (13 = 3) (14 = 2) (15 = 1)
rename tereofluency tereo
label define tereol 1 "1 No more than a few words" 2 "2 Not very well" 3 "3 Fairly well" 4 "4 Well or very well"
label values tereo tereol

* Should government support te reo in daily situations
replace govsupporttereo="12" if govsupporttereo=="DK" | govsupporttereo=="RF" // coding 13 people who said don't know (=DK) or refused to say (=RF) at median value for ease of use
destring govsupporttereo, replace
recode govsupporttereo (11 = 5) (12 = 4) (13 = 3) (14 = 2) (15 = 1)
rename govsupporttereo gov_tereo
label define gov_tereol 1 "1 Strongly disagree" 2 "2 Disagree" 3 "3 Neither agree nor disagree" 4 "4 Agree" 5 "5 Strongly agree"
label values gov_tereo gov_tereol

* Self-actualisation
replace selfactualisation=12 if selfactualisation==88 // coding 13 people who said don't know (=DK) or refused to say (=RF) at median value for ease of use
destring selfactualisation, replace
recode selfactualisation (11 = 5) (12 = 4) (13 = 3) (14 = 2) (15 = 1)
rename selfactualisation selfactual
label define selfactuall 1 "1 Very hard" 2 "2 Hard" 3 "3 Sometimes easy, sometimes hard" 4 "4 Easy" 5 "5 Very easy"
label values selfactual selfactuall

* Trust variables
foreach var of varlist generalisedtrust trustmedia trustparliament {
	replace `var'="88" if `var'=="DK"
	replace `var'="99" if `var'=="RF"
	destring `var', replace
}
replace generalisedtrust=7 if generalisedtrust==88 | generalisedtrust==99 // coding 9 people who said don't know (=88) or refused to say (=99) at median value for ease of use
replace trustpolice=8 if trustpolice==88 | trustpolice==99 // coding 5 people who said don't know (=88) or refused to say (=99) at median value for ease of use
replace trustmedia=5 if trustmedia==88 | trustmedia==99 // coding 11 people who said don't know (=88) or refused to say (=99) at median value for ease of use
replace trustparliament=6 if trustparliament==88 | trustparliament==99 // coding 40 people who said don't know (=88) or refused to say (=99) at median value for ease of use

rename generalisedtrust trust
rename trustpolice trust_police 
rename trustmedia trust_media
rename trustparliament trust_parliament
label define trustl 0 "0 Not at all" 10 "10 Completely"
foreach var of varlist trust trust_police trust_media trust_parliament {
	label values `var' trustl
}

* Voted last election
replace votedlastelection="2" if votedlastelection=="DK" | votedlastelection=="RF" // coding 8 people who said don't know (=DK) or refused to say (RF) as modal category for ease of use
replace votedlastelection="99" if votedlastelection=="NE"
destring votedlastelection, replace
rename votedlastelection voted
recode voted (2 = 0) 
label define votedl 0 "0 Did not vote" 1 "1 Did vote" 99 "99 Not eligible to vote"
label values voted votedl

* Material wellbeing
replace materialwellbeing=15 if materialwellbeing==77 // coding 36 people with missing values at median value fofr ease of use
rename materialwellbeing mwb
label define mwbl 0 "0 Very low material wellbeing" 20 "20 Very high material wellbeing" 
label values mwb mwbl

* House coldness
replace housecoldness="14" if housecoldness=="DK" // coding 2 people who said don't know (=DK) as modal category for ease of use
destring housecoldness, replace
recode housecoldness (11 = 4) (12 = 3) (13 = 2) (14 = 1) (15 = 99)
rename housecoldness housecold
label define housecoldl 1 "1 No" 2 "2 Yes, sometimes" 3 "3 Yes, often" 4 "4 Yes, always" 77 "77 Don't know" 88 "88 Refused" 99 "99 Not spent a winter in this house/flat"
label values housecold housecoldl

* House dampness
replace housedampness="13" if housedampness=="DK" // coding 7 people who said don't know (=DK) as modal category for ease of use
destring housedampness, replace
recode housedampness (11 = 3) (12 = 2) (13 = 1)
rename housedampness housedamp
label define housedampl 1 "1 No, not damp" 2 "2 Yes, sometimes" 3 "3 Yes, always"
label values housedamp housedampl

* Residential mobility
replace residentialmobility="00" if residentialmobility=="NE" // coding 1 peerson who was not eligible (=NE) as modal category for ease of use
destring residentialmobility, replace
replace residentialmobility=4 if residentialmobility>4 & residentialmobility~=.
rename residentialmobility moves
label define movesl 0 "0 moves" 1 "1 move" 2 "2 moves" 3 "3 moves" 4 "4+ moves"
label values moves movesl

* Access to nearest medical centre/doctor, public park/greenspace, and public transport
replace medicalaccess="12" if medicalaccess=="DK" // coding 6 people who said don't know (=DK) at median value for ease of use
replace greenspaceaccess="11" if greenspaceaccess=="DK" // coding 4 people who said don't know (=DK) at median value for ease of use
replace publictransportaccess="12" if publictransportaccess=="DK" // coding 56 people who said don't know (=DK) at median value for ease of use

foreach var of varlist medicalaccess greenspaceaccess publictransportaccess {
destring `var', replace
recode `var' (11 = 5) (12 = 4) (13 = 3) (14 = 2) (15 = 1)
}
rename medicalaccess access_med
rename greenspaceaccess access_green
rename publictransportaccess access_pt
label define accessl 1 "1 Very difficult" 2 "2 Difficult" 3 "3 Neither easy or difficult" 4 "4 Easy" 5 "5 Very easy"
label values access_med accessl
label values access_green accessl
label values access_pt accessl

* Neighbourhood connection
replace neighbourhoodconnect="06" if neighbourhoodconnect=="DK" // coding 3 people who said don't know (=DK) at median value for ease of use
destring neighbourhoodconnect, replace
rename neighbourhoodconnect neigh_connect
label define neigh_connectl 0 "0 No sense of connection" 10 "10 Very strong sense of connection"
label values neigh_connect neigh_connectl

* Neigbourhood crime
replace neighbourhoodcrime="13" if neighbourhoodcrime=="DK" // coding 69 people who said don't know (=DK) at median value for ease of use
destring neighbourhoodcrime, replace
rename neighbourhoodcrime neigh_crime
recode neigh_crime (17 = 9) (16 = 8) (15 = 1) (14 = 2) (13 = 3) (12 = 4) (11 = 5)
label define neigh_crimel 1 "1 A lot less crime" 2 "2 A little less crime" 3 "3 About the same" 4 "4 A little more crime" 5 "5 A lot more crime" 8 "8 No crime around here" 9 "9 Haven't lived in the neighbourhood for 12 months"
label values neigh_crime neigh_crimel

* Victim of crime
replace victimofcrime="2" if victimofcrime=="NE" | victimofcrime=="DK" // coding 3 people who said don't know (=DK) or not eligible (NE) as modal category for ease of use
rename victimofcrime victim
destring victim, replace
recode victim (2 = 0) (1 = 1)
label define victiml 0 "0 Not a crime victim" 1 "1 Victim of crime"
label values victim victiml

* Experienced discrimination
replace experienceddiscrim="2" if experienceddiscrim=="DK" | experienceddiscrim=="NE" | experienceddiscrim=="RF" // coding 16 people who said don't know (=DK), refused to say (RF), or not eligible (NE) as modal category for ease of use
rename experienceddiscrim discrim
destring discrim, replace
recode discrim (2 = 0) (1 = 1)
label define discriml 0 "0 Not discriminated against" 1 "1 Discriminated against"
label values discrim discriml 

* Loneliness
replace loneliness="11" if loneliness=="DK" | loneliness=="NE" | loneliness=="RF" // coding 8 people who said don't know (=DK), refused to say (RF), or not eligible (NE) at median value for ease of use
destring loneliness, replace
rename loneliness lonely
recode lonely (11 = 1) (12 = 2) (13 = 3) (14 = 4) (15 = 5)
label define lonelyl 1 "1 None of the time" 2 "2 A little of the time" 3 "3 Some of the time" 4 "4 Most of the time" 5 "5 All of the time"
label values lonely lonelyl

* Hard to talk to others
replace sympatheticear="12" if sympatheticear=="DK" | sympatheticear=="NE" | sympatheticear=="RF" // coding 13 people who said don't know (=DK), refused to say (RF), or not eligible (NE) at median value for ease of use
rename sympatheticear hardtalk
destring hardtalk, replace
recode hardtalk (11 = 1) (12 = 2) (13 = 3) (14 = 4) (15 = 5) (16 = 6)
label define hardtalkl 1 "1 Very easy" 2 "2 Easy" 3 "3 Sometimes easy, sometimes hard" 4 "4 Hard" 5 "5 Very hard" 6 "6 I wouldn't talk to anyone"
label values hardtalk hardtalkl

* Reordering variables to match codebook order
order id surfweight year age sex ethnicity edu lfs partner parent number_children tenure ///
hh_income nzdep migrant disability home_afford life_satisfy life_worth health tereo ///
gov_tereo selfactual trust trust_police trust_media trust_parliament voted mwb ///
housecold housedamp moves access_med access_green access_pt neigh_connect neigh_crime ///
victim discrim lonely hardtalk

save GSS_SURF_2018_2021, replace
outsheet using "GSS_SURF_2018_2021.csv", nolabel comma replace
