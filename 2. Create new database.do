*----------------------------------------------------*
*------------------- NEW DATABASE -------------------*
*----------------------------------------------------*
* Stata do-file used to create a new database using the 'scp-1205' cleaned database.
* Author: David Mata Quispe
* Input: Cleaned 'scp-1205' database
* Output: New database derived from the cleaned 'scp-1205' one
*----------------------------------------------------*

*-----------------------------------------------------*
*------------------- Program setup -------------------*
*-----------------------------------------------------*
set more off     // Disable partitioned output
clear all        // Start with a clean slate
*-----------------------------------------------------*

* Acces routes:
global task "H:\Mi unidad\David\Trabajo\Postulaciones\BID, Columbia University - RA\Data Task" // Current do-file location
global data "$task\Medicare_Advantage" // Database location

* Setting directory
cd "$task"

* Opening the database
use "$data\scp-1205", clear

* Sorting by state and county
sort state countyname

* Deleting some unusual county names
drop if trim(countyname) == "UNDER-11" | trim(countyname) == "Unusual SCounty Code"
* Note: Browsing the database, I noticed that some 'countyname' values ('UNDER-11' and 'Unusual Scounty Code') can't be associated with an actual county, so I deleted those rows.

* Creating a variable that displays the number of health plans in the county with more than 10 enrollees
bys state countyname: egen numberofplans1 = total(enrollees > 10)

* Creating a variable that displays the number of health plans in the county with penetration greater than 0.5% 
bys state countyname: egen numberofplans2 = total(penetration > 0.5)

* Creating a variable that displays the number of individuals in the county with a MA health plan
bys state countyname: egen totalenrollees = total(enrollees)

* Creating a variable that displays the percent of individuals in the county enrolled in a MA health plan
gen totalpenetration = 100*totalenrollees/eligibles // Some counties have a missing value because they have zero MA eligible individuals

* Keeping the necessary variables
keep countyname state numberofplans1 numberofplans2 countyssa eligibles totalenrollees totalpenetration

* Deleting duplicate rows
duplicates drop

* Saving the new database
save "$data\scp_1205_derived", replace