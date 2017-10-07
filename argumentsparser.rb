

class ArgumentsParser

	@@OPTION_NAMES_FILE = "optionNames.config"
	@@PICO_DIR_KEY = "picodir"
	@@UNIX_DELIMITER = "/"

	#options represents the default options
	def initialize(configOptions)
		@options  = deepcopy(configOptions)
		@options.delete(@@PICO_DIR_KEY)
		@argNames = initArgNames(configOptions)
	end

	def parse(cliArguments)

		ret = deepcopy(@options)
		cliArguments.each do |arg|
			key,val = arg.split(/=/)
			raise ArgumentError,
				"Option #{key} not valid." unless @argNames.has_key?(key)
			if val == nil then next
			end
			ret[@argNames[key]] = val
		end	
		return ret
	end

	def initArgNames(options)

		ret = {}
		absolutePathToOptionNames = prepareAbsolutePathToFile(@@OPTION_NAMES_FILE,options)
		puts absolutePathToOptionNames
		File.open(absolutePathToOptionNames).each do |line|
			key,val = line.strip.split(/=/)
			ret[key] = val
		end
		return ret
	end

	def prepareAbsolutePathToFile(file,options)
	
		return options[@@PICO_DIR_KEY] + @@UNIX_DELIMITER + file
	end

	def deepcopy(obj)
		return Marshal.load(Marshal.dump(obj))
	end

end

