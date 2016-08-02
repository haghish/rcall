
*cap program drop echo
program echo
	Rcall vanilla: cat(`0')
end


// test
echo "how about some \nmulti-line \nstring?"
echo 'Hello World'




