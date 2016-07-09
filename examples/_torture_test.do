
// Install the package from GitHub
// -------------------------------
* net install Rcall, force  from("https://raw.githubusercontent.com/haghish/Rcall/master/")


R: q()
R: rm(list=ls())
R: attach(cars)

//Stata interprets $ sign in the middle of a word as global macro, use backslash
R: head(cars\$speed)
R: LIST <- lm(cars\$dist~cars\$speed)
