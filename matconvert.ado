/*** DO NOT EDIT THIS LINE -----------------------------------------------------
Version:
Title: matconvert
Description: __matconvert__ belongs to {help Rcall} package. It takes the 
name of a Stata matrix and returns a code for constructing the same matrix in R.
for more information visit [Rcall homepage](http://www.haghish.com/packages/Rcall.php).
----------------------------------------------------- DO NOT EDIT THIS LINE ***/


/***
Example(s)
=================

    convert Stata matrix to R code
	
        {bf:. matrix A = (1,2\3,4)}
        {bf:. matconvert A}
        matrix(c(1,2,3,4), nrow=2, byrow = TRUE)

Author
======

__E. F. Haghish__     
Center for Medical Biometry and Medical Informatics     
University of Freiburg, Germany     
_and_        
Department of Mathematics and Computer Science       
University of Southern Denmark     
haghish@imbi.uni-freiburg.de     
      
[http://www.haghish.com/packages/Rcall.php](http://www.haghish.com/packages/Rcall.php)         
Package Updates on [Twitter](http://www.twitter.com/Haghish)    

- - -

This help file was dynamically produced by {help markdoc:MarkDoc Literate Programming package}
***/



capture program drop matconvert
program matconvert, rclass
	
	*mat list `0'
	
	//Get number of rows
	local row = rowsof(`0')
	local col = colsof(`0')
	
	local data
	//extract the scalars
	forval i = 1/`row' {
		forval j = 1/`col' {
			
			//avoid the first comma
			if !missing("`data'") local data "`data',"
			*di `0'[`i',`j']
			*di `"`0'[`i',`j']"'
			local data : display "`data'" `0'[`i',`j']
		}
	}
	
	local code "matrix(c(`data'), nrow=`row', byrow = TRUE)"
	display as txt "{p}`code'"

	return local `0' "`code'"
end


* markdoc matconvert.ado, export(sthlp) replace

/*
matrix A = (1,2\3,4\0,0)
matconvert A

