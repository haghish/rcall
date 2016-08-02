
// -----------------------------------------------------------------------------
// Example of Stata program that runs R program within itself
// =============================================================================

capture program drop timesTen
program timesTen
	
	Rcall vanilla: 																///
		cat("----- Running R ------------------------------------");			///
		times10 <- function(x){													///
			x*10																///
		}; 																		///
		t10 <- times10(`0');
	
	display r(t10)
	
end

timesTen 94
