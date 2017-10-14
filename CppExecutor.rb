
require_relative "SourceExecutor.rb"
require_relative "Constants.rb"

class CppExecutor < SourceExecutor

	include Constants

	def execute(options,pbSource,pbLetter)

		compl = `g++ -std=c++11 #{options[@@ENV_KEY]}/#{pbSource} -o #{options[@@ENV_KEY]}/#{pbLetter}`
		if not !!compl then
			raise Exception,"Could not compile!"
		end

		res = `#{options[@@ENV_KEY]}/#{pbLetter}`
		
		if not !!res then
			raise Exception,"Could not execute!"
		end

		return res
	end
end


