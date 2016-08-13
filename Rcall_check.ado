

program Rcall_check
	
	*syntax [anything] [, Rversion(real 0.0)]
	syntax [anything] [, Rversion(str)]
	
	// Check that Rcall is installed
	// -------------------------------------------------------------------------
	capture findfile Rcall.ado
	if _rc != 0 {
	    di as err "Rcall package is required"	
	    err 198
	}
	
	// Check that R is executable
	// -------------------------------------------------------------------------
	Rcall vanilla:                                                           ///
	major = R.Version()\$major; minor = R.Version()\$minor; 				 ///
	version = paste(major,minor, sep=".");                                   ///
	if ("`anything'" != "") {                                                ///
		pkglist = unlist(strsplit("`anything'", " +"));                      ///
		for (i in 1:length(pkglist)) {                                       ///
			pkg = unlist(strsplit(pkglist[i], ">="));                        ///      
			if (try(require(pkg[1], character.only = TRUE)) == FALSE) {      ///
				error = paste(pkg[1], "is required");                        ///
				break;                                                       ///
			};                                                               ///
			if (packageVersion(pkg[1]) < pkg[2]) {                           ///
				error = paste(pkg[1], pkg[2], "or newer is required");       ///
				break;                                                       ///
			};                                                               ///
		};                                                                   ///
    };																		 ///
	rm(i, pkg, pkglist, major, minor);                                   
	
	// Return propper error
	// -------------------------------------------------------------------------
	if !missing(r(error)) {
		display as err "`r(error)'"
		err 198
	} 
	else if missing(r(version)) {
		di as err "{help Rcall} could not access R on your system"
		err 198
	}
	
	// Check R version 
	// -------------------------------------------------------------------------
	if "`rversion'" > "`r(version)'" {
		di as err "R version `rversion' or higher is required. {help Rcall} "	///
		"is using R `r(version)'"
		err 198
	}
	
end

