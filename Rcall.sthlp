{smcl}
{right:version 1.0.0}
{title:Title}

{phang}
{cmd:{opt R:call}} {hline 2} Seemless interactive {bf:R} in  Stata. The command also return rclass {bf:R} objects ({it:numeric}, {it:character}, {it:list}, {it:matrix}, etc). For more  information visit  {browse "http://www.haghish.com/rcall":Rcall homepage}.


{title:Syntax}

{p 4 4 2}
seemless interactive execution of R in Stata. the {bf:vanilla} subcommand executes
{bf:R} non-interactively

{p 8 16 2}
{opt R:call} [{cmd:vanilla}] [{cmd::}] [{it:R code}]
{p_end}


{p 4 4 2}
permanently setup the path to executable R on the machine, if different with the 
default paths (see below)

{p 8 16 2}
{opt R:call} {cmd:setpath}  {it:"string"}
{p_end}


{title:Description}

{p 4 4 2}
The {opt R:call} package provides solution for Stata users who wish to run 
{browse "https://cran.r-project.org/":R statistical software} within Stata. 
{browse "https://cran.r-project.org/":R} is a free software environment for statistical 
computing and graphics. 
The package provides an interactive {bf:R} session within Stata, and    {break}
returns {bf:R} objects into Stata simultaniously, i.e. anytime an R code is executed, 
the R objects are available for further manipulation in Stata. {opt R:call} 
not only returns {it:numeric} and {it:charactor} objects, but also {it:lists} and 
{it:matrices}. 


{title:R path setup}

{p 4 4 2}
The package requires  {browse "https://cran.r-project.org/":R} to be installed on the machine. 
The package detects {bf:R} in the default paths based on the operating system. 
The easiest way to see if {bf:R} is accessible is to execute a command in {bf:R__

        . R: print("Hello World") 
        [1] "Hello World" 

{p 4 4 2}
If {bf:R} is not accessible, you can also permanently 
setup the path to {bf:R} using the {bf:setpath} subcommand. For example, the 
path to {bf:R} on Mac 10.10 could be:

    . {cmd:R setpath} "{it:/usr/bin/r}"


{title:Remarks}

{p 4 4 2}
You should be careful with using Stata symbols in {bf:R}. For example, the {bf:$} 
sign in Stata is preserved for global macros. To use this sign in {bf:R}, you 
should place a backslash before it to pass it to {bf:R}. For example:

        . R: head(cars\$speed)

{p 4 4 2}
Also, the object name in {bf:R} can include a dot, for example:

        . R: a.name <- "anything" 
		
{p 4 4 2}
The {opt R:call} package returns scalars and locals which can only include 
underscore in the names (e.g. a_name). {opt R:call} automatically converts 
dots to underscore in the name. In the example above, if you type {cmd:return list}, 
you would get a macro as follos:

        r(a_name) : "anything"
		

{title:Example(s)}

    permanently setup the path to R 
        . R setpath "/usr/bin/r" 

    execute an R code interactively
        . example command


{title:Author}

{p 4 4 2}
{bf:E. F. Haghish}       {break}
Center for Medical Biometry and Medical Informatics       {break}
University of Freiburg, Germany       {break}
{it:and}          {break}
Department of Mathematics and Computer Science         {break}
University of Southern Denmark       {break}
haghish@imbi.uni-freiburg.de       {break}

{p 4 4 2}
{browse "http://www.haghish.com/statistics/stata-blog/reproducible-research/markdoc.php":http://www.haghish.com/markdoc}           {break}
Package Updates on  {browse "http://www.twitter.com/Haghish":Twitter}       {break}

    {hline}

{p 4 4 2}
This help file was dynamically produced by {help markdoc:MarkDoc Literate Programming package}

