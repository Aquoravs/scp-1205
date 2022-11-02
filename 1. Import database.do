*---------------------------------------------------------*
*--------------- IMPORT AND CLEAN DATABASE ---------------*
*---------------------------------------------------------*
* Stata do-file used to import and clean the 'scp-1205' database.
* Author: David Mata Quispe
* Input: Raw 'scp-1205' database
* Output: Cleaned 'scp-1205' database
*---------------------------------------------------------*

*---------------------------------------------------------*
*--------------------- Program setup ---------------------*
*---------------------------------------------------------*
set more off     // Disable partitioned output
clear all        // Start with a clean slate
*---------------------------------------------------------*

* Acces routes:
global task "H:\Mi unidad\David\Trabajo\Postulaciones\BID, Columbia University - RA\Data Task" // Current do-file location
global data "$task\Medicare_Advantage" // Database location

* Setting directory
cd "$task"

* Importing the database
import delimited countyname state contract healthplanname typeofplan countyssa eligibles enrollees penetration ABrate using "$data\scp-1205.csv", stringcols(1/6) numericcols(7/10) clear // Naming columns and specifying the type of variables
* Note: Although the instructions don't specify a variable called 'contract' in the list, I assume that it must be specified given the proposed example.

* Replacing missing values by zero (some numeric variables)
foreach v of varlist eligibles-penetration {
	replace `v' = 0 if missing(`v')
}

* Saving the cleaned database
save "$data\scp-1205", replace