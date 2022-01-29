cd "/Users/gnlm/Desktop/School/MSC/DS/Term 2/TM/Assignments/PS3/scraping"
import delimited "hotel_df.csv", encoding(UTF-8) clear


// Generate day variable:

gen day_of_week = ""

replace day_of_week = "Monday" if day==5 | day==12
replace day_of_week = "Tuesday" if day==6 | day==13
replace day_of_week = "Wednesday" if day==0 | day==7  
replace day_of_week = "Thursday" if day==1 | day==8  
replace day_of_week = "Friday" if day==2 | day==9  
replace day_of_week = "Saturday" if day==3 | day==10  
replace day_of_week = "Sunday" if day==4 | day==11  

// Encode string variables:

encode hotel, gen(hotel_cc)
encode day_of_week, gen(day_of_week_cc)

// for hotel X day FE:
// gen hotel_day = hotel_cc*day_of_week_cc 

// Some duplicates due to ads:
sort hotel_cc day
quietly by hotel_cc day:  gen dup = cond(_N==1,0,_n)
drop if dup>1
duplicates report hotel_cc day


// Set id and time variable:

xtset hotel_cc day

// Generate treatment variable:

gen event = 1 if  day==7
replace event = 0 if event==.




// Regressions:

eststo clear

// Navie:

eststo:xtreg price1  event apartment yacht studio breakfast beach_near rating prepayment free_cancel metro dist num_revs, r

// Day FE:
eststo:xtreg price1  event apartment yacht studio breakfast beach_near rating prepayment free_cancel metro dist num_revs i.day_of_week_cc, r


// Save output to table:

esttab using table1.tex, replace
