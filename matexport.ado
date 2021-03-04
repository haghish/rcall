// documentation written for markdoc

/***
Version: 1.0.0

matexport
=========

export matrices from Stata as a data set

Syntax
------

matexport `mat', rnames(name) filename(filename) version(13)

the command exports a data set from a given matrix with the given name and 
includes the matrix row names in a column named

Citation
--------

The program is based on a command written by __Nicholas J. Cox__, in a package 
called __dm79__, from which I read and borrowed a command named
__svmat2__. I have used the version 1.2.2 

Author
------

__E. F. Haghish__
Department of Psychology
University of Oslo
haghish@hotmail.com

[rcall Homepage](www.haghish.com/packages/Rcall.php)
Package Updates on [Twitter](http://www.twitter.com/Haghish)

- - -

This help file was dynamically produced by {help markdoc:MarkDoc Literate Programming package}
***/

*cap prog drop matexport
program define matexport
  version 5.0
  
  preserve
  quietly drop _all
  quietly label drop _all 
  
  // Syntax processing
  // ------------------------------------------------------------
  parse "`*'", parse(" ,")
  
  // specify the matrix name as `A' and make sure it exists, otherwise, return an error
  if "`2'" == "" | "`2'" == "," {
    local type "float"
    local A    "`1'"
    macro shift
  }
  else {
    local type "`1'"
    local A    "`2'"
    macro shift 2
  }
  capture local nc = colsof(matrix(`A'))
  if _rc {
    di in red "matrix `A' not found"
    exit 111
  }
  
  local options "Rnames(string) Full filename(string) version(integer 13)"
  
  parse "`*'"
  if "`rnames'" != "" { confirm new variable `rnames' }
  local j 1
  
  // allways get the matrix column names from the columns
  local names = "col"         
  local notc  "*" 

  `nots' local cnames : colnames(`A')
  `notc' `notm' `nots' local enames : coleq(`A')
  while `j' <= `nc' {
    `nots' local varnam : word `j' of `cnames'
    `notc' `notm' `nots' local pre : word `j' of `enames'
    `notc' `noteq' `nots' local pre "`A'"
    `notc' `nots' local varnam = substr("`pre'`varnam'",1,8)
    `nots' local vars "`vars' `varnam'"
    `notc' `noteq' `notm' if `stub' { local vars "`vars' `names'`j'" }
    `notc' `noteq' `notm' if !`stub' { local vars "`names'" }
    local j = `j' + 1
  }
  
  local varlist "new"
  capture parse "`type'(`vars')"
  if _rc == 110 {
    di in red "new variables cannot be uniquely named or already defined"
    exit _rc
  }
  
  if _rc == 900 | _rc == 902 { noroom `type' `nc' _rc }
  if _rc { error _rc }
  drop `varlist'
  parse "`varlist'", parse(" ")
  local nr = rowsof(matrix(`A'))
  local old_N = _N
  if `nr' > _N {
    di in blu "number of observations will be reset to `nr'"
    di in blu "Press any key to continue, or Break to abort"
    more
    set obs `nr'
  }
  capture {
    local j 1
    while `j' <= `nc' {
      tempvar y`j'
      gen `type' `y`j'' = matrix(`A'[_n, `j']) in 1/`nr'
      local j = `j' + 1
    }
    local j 1
    while `j' <= `nc' {
      rename `y`j'' ``j''
      local j = `j' + 1
    }
  }
  
  if _rc {
    if _N > `old_N' { quietly drop if _n > `old_N' }
    error _rc
  }
  qui if "`rnames'" != "" {
    gen str1 `rnames' = ""

    * trap and ignore any user -full- if < 6
    capture di _caller( )
    if _rc == 0 { local full "`full'" } /* it is 6 or more */
    else {
      if "`full'" == "full" {
        noi di in bl "full option not supported"
        local full ""
      }
    }

    local Rnames : row`full'names(`A')
    local i = 1
    while `i' <= `nr' {
      local rname : word `i' of `Rnames'
      replace `rnames' = "`rname'" in `i'
      local i = `i' + 1
    }
  }
  
  // save the data and replace it
  quietly saveold "`filename'.dta", version(`version') replace
  restore
end

*cap prog drop noroom
program define noroom /* `type' `nc' _rc */
  version 4.0
  local type "`1'"
  local nc    `2'
  local rc    `3'
  if      "`type'"=="float"  { local w 4 }
  else if "`type'"=="double" { local w 8 }
  else if "`type'"=="long"   { local w 4 }
  else if "`type'"=="int"    { local w 2 }
  else if "`type'"=="byte"   { local w 1 }
  local w = `w'*`nc'
  di as err  "no room to add more variables"
  di as txt "room for `nc' additional variables and additional width of `w' required"
  exit `rc'
end


/*
clear
matrix drop _all
qui sysuse auto, clear
mkmat price mpg ,  matrix(auto) rownames(make)
mat list auto
quietly matexport auto, rnames("MATR0WNAMES") filename("_send.matrix.sss") version(13)
