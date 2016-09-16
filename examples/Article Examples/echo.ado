
program echo
	Rcall vanilla: cat(`0')
end




// test ------------------------------------------------------------------------
echo "Greetings from Stata"
echo "how about some \nmulti-line \nstring?"
echo 'Hello World'

sysuse auto, clear
echo st.var(price)



