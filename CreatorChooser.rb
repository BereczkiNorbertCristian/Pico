
require_relative "Constants.rb"
require_relative "CodeforcesEnvCreator.rb"

class EnvCreatorChooser

	@@CODEFORCES_NAME = "codeforces"

	def choose(configOptions,options)

		case options[@@CONTEST_KEY]
		when @@CODEFORCES_NAME
			return CodeforcesEnvCreator.new(configOptions,options)
		else
			raise Exception,"There is no such platform as #{options[@@CONTEST_KEY]}"
		end
	end
end







