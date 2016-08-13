{smcl}
{right:version 1.0.0}
{title:Title}

{phang}
{cmd:commandname} {hline 2} explain your command briefly. You can use simplified syntax to make text {it:italic}, {bf:bold}, or {ul:underscored} or 
 add  {browse "http://www.haghish.com/markdoc":hyperlink} 
 

{title:Syntax}

{p 8 16 2}
{cmd: XXX} {varlist} {cmd:=}{it}{help exp}{sf} {ifin} {weight} 
{help using} {it:filename} [{cmd:,} {it:options}]
{p_end}

{* the new Stata help format of putting detail before generality}{...}
{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt min:abbrev}}description of what option{p_end}
{synopt:{opt min:abbrev(arg)}}description of another option{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}{* if by is allowed, leave the following}
{cmd:by} is allowed; see {manhelp by D}.{p_end}
{p 4 6 2}{* if weights are allowed, say which ones}
{cmd:fweight}s are allowed; see {help weight}.


{title:Description}

{p 4 4 2}
{bf:XXX} does ... (now put in a one-short-paragraph description 
of the purpose of the command)


{title:Options}

{p 4 4 2}
{bf:whatever} does yak yak

{p 8 8 2}
Use {bf:>} for additional paragraphs within and option 
description to indent the paragraph.

{p 4 4 2}
{bf:2nd option} etc.


{title:Remarks}

{p 4 4 2}
The remarks are the detailed description of the command and its 
nuances. Official documented Stata commands don{c 39}t have much for 
remarks, because the remarks go in the documentation.


{title:Example(s)}

    explain what it does
        . example command

    second explanation
        . example command


{title:Stored results}

{p 4 4 2}
{bf:commandname} stores the following in {bf:r()} or {bf:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}


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
Author Name (2016),  {browse "http://www.haghish.com/markdoc/":title & external link}

    {hline}

{p 4 4 2}
{it:This help file was dynamically produced by {browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package}} 

