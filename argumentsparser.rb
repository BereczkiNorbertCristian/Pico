

class ArgumentsParser

	def initialize(options)
		@options  = Hash.new(options)
		@argNames = initArgNames()
	end

	def parse(cliArguments)

		cliArguments.each do |arg|
			key,val = arg.split(/=/)
			@options[@argNames[key]] = val
		end	
		return @options
	end

	def initArgNames()
	

		# TODO Move this into a separate file

		ret = {}
		ret["--env"]  		= "env"
		ret["-e"]     		= "env"
		ret["--contest"] 	= "contest"
		ret["-c"] 		= "contest"
		ret["--number"]		= "number"
		ret["-n"]		= "number"
		ret["--lang"] 		= "lang"
		ret["-l"] 		= "lang"
		ret["--make"] 		= "make"
		ret["-m"] 		= "make"
		ret["--reload"] 	= "reload"
		ret["-r"] 		= "reload"
		ret["--problem"] 	= "problem"
		ret["-p"] 		= "problem"
		ret["--test"] 		= "test"
		ret["-t"] 		= "test"
		ret["--auth"] 		= "auth"
		ret["-a"] 		= "auth"
		ret["--username"] 	= "username"
		ret["-u"] 		= "username"
		ret["--password"] 	= "password"
		ret["-pass"] 		= "password"
	end
end
