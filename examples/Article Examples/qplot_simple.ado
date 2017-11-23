// summary program
// ===============
//
// carring the "summary" function in R to summarize data in Stata

program qplot
	version 12
	rcall vanilla : library(ggplot2); qplot(data=st.data(), `0')
end

// Examples
sysuse auto, clear
qplot mpg, price
qplot mpg, price, colour=foreign, shape = foreign
