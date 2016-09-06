
capture program drop Rcpp
program Rcpp
	
	Rcall vanilla :																	///
	library(Rcpp);																	///
	Rcpp::sourceCpp('/Users/haghish/Documents/Packages/Rcall/examples/programming/timesTwo.cpp');	///
	times2 <- timesTwo(`0');													///
	detach("package:Rcpp", unload=TRUE);
	
end

Rcpp 20
display r(times2)

/*
timer clear
timer on 1
	Rcpp 20
timer off 1
timer list
display r(times2)
