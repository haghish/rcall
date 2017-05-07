# rcall : seamless R in Stata

> <span style="color:red;">WARNING</span>: From version 2.0.0 forth, `Rcall` command was renamed to `rcall`, `Rcall_check` command was renamed to `rcall_check`, and the package will have no official abbreviation for shortenning the `rcall` command.

--- 


<a href="http://haghish.com/markdoc"><img src="./Documentation/Rcall.png" align="left" width="140" hspace="10" vspace="6"></a>

__`rcall`__ runs [__R__](https://cran.r-project.org/) commands in Stata and allow the two software automatically communicate _variables_, 
_matrices_, and _data_. more information read the help file or 
[visit diagram homepage](http://www.haghish.com/packages/Rcall.php). 
__`rcall`__ returns _rclass_ scalars, macros, and matrices to Stata, anytime an [__R__](https://cran.r-project.org/) command is executed. 
Similarly, it allows passing _macro_, _matrix_, _scalar_, and _data_ from Stata to [__R__](https://cran.r-project.org/). 

__`rcall`__ makes it so easy to run [__R__](https://cran.r-project.org/) within Stata interactively, pass data or a matrix to R, 
and access the results (numeric, matrix, character, lists) wutomatically within Stata which simply brings the power of [__R__](https://cran.r-project.org/) as well as all other programming languages that can be used interactively in R (e.g. C++ using [Rcpp](http://rcpp.org/) or JavaScript using [V8](https://cran.r-project.org/web/packages/V8/index.html)) in Stata. 

Installation
------------

The [__`github package`__](https://github.com/haghish/github) can be used to install __rcall__ from GitHub conveniently. 

```js
github install haghish/rcall
```

Author
------
  **E. F. Haghish**  
  Center for Medical Biometry and Medical Informatics    
  University of Freiburg, Germany        
  _haghish@imbi.uni-freiburg.de_       
  _http://www.haghish.com/packages/Rcall.php_      
  _[@Haghish](https://twitter.com/Haghish)_      
  


Examples
------------

The [__examples__](https://github.com/haghish/rcall/tree/master/examples) directory includes the torture test file that can serve as a good example. 
