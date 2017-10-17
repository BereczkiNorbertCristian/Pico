# Pico
CLI tester for competitive programming contests.

Be careful, there is still work to be done.

## How to install?
	
- clone git repo 
	
	`git clone https://github.com/BereczkiNorbertCristian/Pico.git`
	
- run install script (which will create a folder .pico in your home directory)
	`./install.rb`
- also in your bashrc or zshrc put an alias to pico.sh with the name pico

## How it works?

- select a codeforces contest (e.g. http://codeforces.com/contest/876)
- for a contest you should create an environment and specify the number of the contest and the contest type
	```
		pico --env=foo441 --number=876
		or
		pico -e=foo441 -n=876 [--contest=contestName(default is codeforces)]
		pico env=foo441 n=876
	```
- your program should read from input.in and should print to the standard output(the default template does that)
- test a problem (for now works only with cpp sources)
- MUST cd environment to run tests in that environment!
	```
		pico --test --problem=a.cpp
		or
		pico -t -p=a.cpp
		pico -t -p=a
		pico -t -p=a.cpp --diff (for should the expected output and execution output)
		pico -t=0 -p=a.cpp -d (test problem a using test number 0 and show the difference between expected and actual output)
		pico test p=a.cpp
	```
- show current status variables
	```
		pico --status
		or
		pico -s
		pico status
		(env shows the current environment,)
	```
- reload tests in current environment
	```
		pico --reload
		or
		pico -r
		pico reload
	```
	

