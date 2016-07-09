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
permanently specifies the path to executable R on the machine, if different with the default paths (see below)

{p 8 16 2}
{opt R:call} {cmd:setpath}  {it:"string"}
{p_end}


{title:Description}

{p 4 4 2}
The {opt R:call} package provides ultimate solution for Stata users who wish to run R 
within Stata. The package provides an interactive {bf:R} session within Stata, and    {break}
returns {bf:R} objects into Stata simultaniously, i.e. anytime an R code is executed, 
the R objects are available for further manipulation in Stata. {opt R:call} 
not only returns {it:numeric} and {it:charactor} objects, but also {it:lists} and 
{it:matrices}. 


{title:R path setup}

{p 4 4 2}
The package detects {bf:R} in the default paths based on the operating system. 
If {bf:R} is not accessible, you will be notified. You can also permanently 
setup the path to {bf:R} using the {bf:Rcallsetup} command. For example, the 
path to {bf:R} on Mac 10.10 could be:

    . {cmd:Rcallsetup} "{it:/usr/bin/r}"


{title:Remarks}

{p 4 4 2}
The remarks are the detailed description of the command and its nuances.
Official documented Stata commands don{c 39}t have much for remarks, because the remarks go in the documentation.
Similarly, you can write remarks that do not appear in the Stata help file, 
but appear in the {bf:package vignette} instead. To do so, use the 
/{c 42}{c 42}{c 42}{c 36} sign instead of /{c 42}{c 42}{c 42} sign (by adding a dollar sign) 
to indicate this part of the documentation should be avoided in the 
help file. The remark section can include graphics and mathematical 
notations.

    /{c 42}{c 42}{c 42}$
    ...
    {c 42}{c 42}{c 42}/


{title:Example(s)}

    explain what it does
        . example command

    second explanation
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

