{smcl}
{it:v. 1.0.0} 


{title:rcall_check}

{p 4 4 2}
examines the required version of R and R packages


{title:Syntax}

{p 8 8 2} {bf:rcall_check} [{it:pkgname>=version}] [[...]] [, {it:options}]

{col 5}{it:option}{col 30}{it:Description}
{space 4}{hline 73}
{col 5}{ul:r}version({it:str}){col 30}specify the minimum required R version
{col 5}{ul:rcall}version({it:str}){col 30}specify the minimum required {bf:rcall} version
{space 4}{hline 73}

{title:Description}

{space 1}{bf:rcall_check} can be used to check that R is accessible via {bf:rcall}, 
{space 1}check for the required R packages, and specify a minimum acceptable versions for R, 
{space 1}{bf:rcall} , and all the required R packages. 

{space 1}As showed in the syntax, all of the arguments are optional. If {bf:rcall_check}
is executed without any argument or option, it simply checks whether R is
accessible via {bf:rcall} and returns {bf:r(rc)} and {bf:r(version)} which is the version of
the R that is used by the package. If R is not reachable, an error is returned
accordingly.


{title:Example(s)}

{p 4 4 2}
checking that R is accessuble via rcall

        . rcall_check

{space 1}check that the minimum rcall version 1.3.3, ggplot2 version 2.1.0, and R version of 3.1.0 are installed

        . rcall_check ggplot2>=2.1.0 , r(3.1.0) rcall(1.3.3)


{title:Stored results}

{p 4 4 2}{bf:Scalars}

{p 8 8 2} {bf:r(rc)}: indicates whether R was accessible via {bf:rcall} package

{p 8 8 2} {bf:r(version)}: returns R version accessed by {bf:rcall}



