/***
_v. 1.0.0_ 

rcall_check
===========

examines the required version of R and R packages

Syntax
------ 

> __rcall_check__ [_pkgname>=version_] [[...]] [, _options_]

| _option_                |  _Description_                                 |
|:------------------------|:-----------------------------------------------|
| **r**version(_str_)     | specify the minimum required R version         |
| **rcall**version(_str_) | specify the minimum required __rcall__ version |

Description
-----------

 __rcall_check__ can be used to check that R is accessible via __rcall__, 
 check for the required R packages, and specify a minimum acceptable versions for R, 
 __rcall__ , and all the required R packages. 

 As showed in the syntax, all of the arguments are optional. If __rcall_check__
is executed without any argument or option, it simply checks whether R is
accessible via __rcall__ and returns __r(rc)__ and __r(version)__ which is the version of
the R that is used by the package. If R is not reachable, an error is returned
accordingly.

Example(s)
----------

checking that R is accessuble via rcall

        . rcall_check

 check that the minimum rcall version 1.3.3, ggplot2 version 2.1.0, and R version of 3.1.0 are installed

        . rcall_check ggplot2>=2.1.0 , r(3.1.0) rcall(1.3.3)

Stored results
--------------

### Scalars

> __r(rc)__: indicates whether R was accessible via __rcall__ package

> __r(version)__: returns R version accessed by __rcall__

***/


*cap prog drop rcall_check
program rcall_check

	syntax [anything] [, Rversion(str) RCALLversion(str)]

	// Prepare the required rcall version
	// -------------------------------------------------------------------------
	if !missing("`rcallversion'") {
    
    // Check rcall version from the github version
    qui github version rcall
    local current `r(version)'
    local current : subinstr local current "." " ", all
    tokenize `current'
    local ver `1'
    macro shift
    while !missing("`1'") {
      local next `next'`1'
      macro shift
    }
    local CURRENTRCALLVERSION `ver'.`next'
    
    // check the required rcall version
		local requiredversion `rcallversion'
		local requiredversion : subinstr local requiredversion "." " ", all
		tokenize `requiredversion'
		local version `1'
		macro shift
		while !missing("`1'") {
			local secondary `secondary'`1'
			macro shift
		}
		local version `version'.`secondary'
		
		// return error if rcall is old
		if `version' > `CURRENTRCALLVERSION' {
			display as err "{help rcall} version `rcallversion' or newer is "	///
			"required"
			err 198
		}
	}	
	
	
	// Check that R is executable
	// -------------------------------------------------------------------------
	rcall vanilla:                                                           	///
	major = R.Version()\$major; minor = R.Version()\$minor; 				 	        ///
	version = paste(major,minor, sep=".");                                   	///
	if ("`anything'" != "") {                                                	///
		pkglist = unlist(strsplit("`anything'", " +"));                      	  ///
		for (i in 1:length(pkglist)) {                                       	  ///
			pkg = unlist(strsplit(pkglist[i], ">="));                        	    ///      
			if (try(require(pkg[1], character.only = TRUE)) == FALSE) {      	    ///
				error = paste("R package", pkg[1], "is required");           	      ///
				break;                                                       	      ///
			};                                                               	    ///
			if (packageVersion(pkg[1]) < pkg[2]) {                           	    ///
				error = paste("R package", pkg[1], pkg[2], 						              ///
				"or newer is required"); 										                        ///
				break;                                                       	      ///
			};                                                               	    ///
		};                                                                   	  ///
    };																		 	                                ///
	suppressWarnings(rm(i, pkg, pkglist, major, minor));                                   
	
	// Return propper error
	// -------------------------------------------------------------------------
	if !missing(r(error)) {
		display as err "`r(error)'"
		err 198
	} 
	else if missing(r(version)) {
		di as err "{help rcall} could not access R on your system"
		err 198
	}
	
	// Check R version 
	// -------------------------------------------------------------------------
	if "`rversion'" > "`r(version)'" {
		di as err "R version `rversion' or higher is required. {help rcall} "	///
		"is using R `r(version)'"
		err 198
	}
	
end

