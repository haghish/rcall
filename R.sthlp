{smcl}
{right:version 1.0.0}
{title:Title}

{phang}
{cmd:{opt R:call}} {hline 2} Seemless interactive {bf:R} in  Stata. The command also return rclass {bf:R} objects ({it:numeric}, {it:character}, {it:list}, {it:matrix}, etc). For more  information visit  {browse "http://www.haghish.com/rcall":Rcall} homepage.


{title:Syntax}

{p 4 4 2}
seemless interactive execution of R in Stata

{p 8 16 2}
{opt R:call} [{cmd::}] [{it:R code}]
{p_end}


{p 4 4 2}
specifies the path to executable R on the machine, if different with the default paths (see below)

{p 8 16 2}
{opt Rcallsetup} {it:"string"}
{p_end}


{title:Description}

{p 4 4 2}
The {opt R:call} package provides ultimate solution for Stata users who wish to run R 
within Stata. The package provides an interactive {bf:R} session within Stata, and    {break}
returns {bf:R} objects into Stata simultaniously, i.e. anytime an R code is executed, 
the R objects are available for further manipulation in Stata. {opt R:call} 
not only returns {it:numeric} and {it:charactor} objects, but also {it:lists} and 
{it:matrices}. 



{title:R path}

{p 4 4 2}
{bf:whatever} does yak yak

{p 8 8 2}
Use {bf:>} for additional paragraphs within and option description to indent the paragraph.

{p 4 4 2}
{bf:2nd option} etc.


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


{title:Acknowledgements}

{p 4 4 2}
If you have thanks specific to this command, put them here.


{title:Author}

{p 4 4 2}
Author information here; nothing for official Stata commands
leave 2 white spaces in the end of each line for line break. For example:

{p 4 4 2}
Your Name     {break}
Your affiliation      {break}
Your email address, etc.      {break}


{title:References}

{p 4 4 2}
E. F. Haghish (2014), {help markdoc:MarkDoc: Literate Programming in Stata}

