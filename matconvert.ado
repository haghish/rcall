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




/*
matrix A = (1,2\3,4\0,0)
matconvert A
