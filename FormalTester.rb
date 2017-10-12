
require "colorize"
require_relative "Tester.rb"
require_relative "Constants.rb"
require_relative "CppExecutor.rb"
require_relative "SourceExecutor.rb"

# PRECONDITION: THE NUMBER OF INPUT FILES FOR A PROBLEM SHOULD BE 
# THE SAME WITH THE NUMBER OF OUTPUT FILES

# TODO: Floating point comparison

class FormalTester < Tester
	
	@@INPUT_FILE 	= "input.in"
	@@CPP_FILE	= "cpp"
	@@PYTHON_FILE	= "py"

	def test(options)
		
		pbSource = prepareProblemName(options)
		pbLetter = getProblemLetter(pbFile)
		
		testsFolder = options[@@ENV_KEY] + @@UNIX_DELIM + @@TESTS_FOLDER

		res = ""
		testNo = 0
		Dir.foreach(testsFolder) do |file|
			if file.include? pbLetter and file.include? @@IN_SUFFIX then
				res += doTest(options,testsFolder,pbSource,pbLetter,testNo)
				testNo+=1
			end
		end
		
		return res
	end

	private
	def doTest(options,testsFolder,pbSource,pbLetter,testNo)
		
		FileUtils.cp("#{testsFolder}/#{file}","#{options[@@ENV_KEY]}/#{@@INPUT_FILE}")
		executionResult = doExecute(options,pbSource,pbLetter)
		expectedOutput = extractExpectedOutput(testsFolder,pbLetter)
		
		return makeComparison(options,executionResult,expectedOutput,pbLetter,testNo)
	end

	private
	def makeComparison(options,executionResult,expectedOutput,pbLetter,testNo)
		
		formattedResult = "Problem: #{pbLetter}, Test #{testNo}: "
		good = "Wrong!".red

		if executionResult.split("\n") == expectedOutput.split("\n") then
			good = "OK!".green
		end
		formattedResult += good + "\n"
		if options.has_key? @@DIFF_KEY then
			formattedResult += "Your Output:\n"
			formattedResult += executionResult + "\n"
			formattedResult += "Expected Output:" + "\n"
			formattedResult += expectedOutput + "\n"
		end
		
		return formattedResult
	end

	private
	def extractExpectedOutput(testsFolder,pbLetter)
		return File.open("#{testsFolder}/#{pbLetter}.#{@@IN_SUFFIX}").read()
	end

	private 
	def doExecute(options,pbSource,pbLetter)
		
		executor = SourceExecutor.new
		case extractLang(pbSource)
		when @@CPP_FILE then
			executor = CppExecutor.new
		else
			raise Exception,"This format cannot be executed!"
		end
			
		return executor.execute(options,pbSource,pbLetter)
	end
	
	private
	def extractLang(pbSource)
		return pbSource.split(".")[1]
	end

	private
	def getProblemLetter(problemFile)
		return problemFile.split(".")[0]
	end

	private
	def prepareProblemName(options)
		rawPb = options[@@PROBLEM_KEY]
		if rawPb.include? "." then
			return rawPb
		else
			return "#{rawPb}.#{options[@@LANG_KEY]}"
		end
	end
end
