
require_relative "Constants.rb"

class ArgumentsParser

	include Constants

	@@OPTION_NAMES_FILE = "OptionNames.config"

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
			if val == nil and ret.has_key? key then next
			end
			ret[@argNames[key]] = val
		end	
		return ret
	end

	def initArgNames(options)

		ret = {}
		absolutePathToOptionNames = prepareAbsolutePathToFile(@@OPTION_NAMES_FILE,options)
		File.open(absolutePathToOptionNames).each do |line|
			key,val = line.strip.split(/=/)
			ret[key] = val
		end
		return ret
	end

	def prepareAbsolutePathToFile(file,options)
	
		return options[@@PICO_DIR_KEY] + @@UNIX_DELIM + file
	end

	def deepcopy(obj)
		return Marshal.load(Marshal.dump(obj))
	end

end

