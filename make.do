// the 'make.do' file is automatically created by 'github' package.
// execute the code below to generate the package installation files.
// DO NOT FORGET to update the version of the package, if changed!
// for more information visit http://github.com/haghish/github

make rcall, replace toc pkg  version(2.5)                                   ///
     license("MIT")                                                         ///
     author("E. F. Haghish")                                                ///
     email("haghish@med.uni-goettingen.de")                                 ///
     url("http://github.com/haghish")                                       ///
     title("seamless R in Stata")                                           ///
     description("call R in Stata and enable automated data communication") ///
     install("call_return.ado;matconvert.ado;matconvert.sthlp;"             ///
             "R.ado;rcall_check.ado;rcall_counter.ado;"                     ///
             "rcall_interactive.ado;rcall_synchronize.ado;rcall.ado;"       ///
             "rcall.sthlp;rprofile.site;stata.output.r;varconvert.ado")     ///
     ancillary("")                                                        
