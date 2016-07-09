
// Install the package from GitHub
net install Rcall, force  from("https://raw.githubusercontent.com/haghish/Rcall/master/")


R: q()
R: rm(list=ls())
R: attach(cars)
R: head(speed)
R: lm(cars\$dist~cars\$speed)
