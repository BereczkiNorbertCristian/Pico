
require "nokogiri"
require "open-uri"

require_relative "EnvCreator.rb"
require_relative "Constants.rb"

class CodeforcesEnvCreator < EnvCreator
	
	@@FIRST_CHAR 	= 0
	
	def initialize(configOptions,options)
		@configOptions = configOptions
		@options = options
	end

	def createEnv()
		
		processEnvPath()
		numberOfProblems = getNumberOfProblems()
		createEmptyInputFile()
		createEmptySources(numberOfProblems)
		createTests(numberOfProblems)
	end

	def createEmptyInputFile()

		filepath = "#{@options[@@ENV_KEY]}/input.in"
		File.write(filepath,"") unless File.exists?(filepath)
	end

	def createTests(numberOfProblems)

		numberOfProblems.times { |i| 
			pb = (@@a + i).chr.upcase
			doc = Nokogiri::HTML(open(prepareProblemLink(pb)))
			createTestsForProblem(pb,doc,@@IN_CLASS,@@IN_SUFFIX)
			createTestsForProblem(pb,doc,@@OUT_CLASS,@@OUT_SUFFIX)
		}
	end

	def createTestsForProblem(pb,doc,type,suffix)
		nr = 0
		testsDir = "#{@options[@@ENV_KEY]}/#{@@TESTS_FOLDER}"
		Dir.mkdir(testsDir) unless File.exists?(testsDir)
		doc.xpath("//div[@class='#{type}']").each do |el|
			toPut = el.children[1].to_s.gsub("<br>","\n").gsub(/<\/{0,1}pre>/,"")
			File.write("#{@options[@@ENV_KEY]}/#{@@TESTS_FOLDER}/#{pb}#{nr}.#{suffix}",toPut)
			nr+=1	
		end
	end

	def processEnvPath()

		currentEnvPath = @options[@@ENV_KEY]
		if currentEnvPath[@@FIRST_CHAR] != @@UNIX_DELIM then
			currentEnvPath = @configOptions[@@CURRENT_DIR_KEY] + @@UNIX_DELIM + currentEnvPath
		end
		@options[@@ENV_KEY] = currentEnvPath
		Dir.mkdir(currentEnvPath) unless File.exists?(currentEnvPath)
	end

	def createEmptySources(numberOfProblems)
		
		numberOfProblems.times { |i|
			pb = (@@a + i).chr
			File.write("#{@options[@@ENV_KEY]}/#{pb}.#{@options[@@LANG_KEY]}",'')
		}
	end

	def saveEnvConfig()
		toPut = ""
		toPut += @@CONTEST_KEY + @@EQ_DELIM + @options[@@CONTEST_KEY] + @@NEW_LINE
		toPut += @@ENV_KEY + @@EQ_DELIM + @options[@@CONTEST_KEY] + @@NEW_LINE
		toPut += @@NUMBER_KEY + @@EQ_DELIM + @options[@@NUMBER_KEY] + @@NEW_LINE
		toPus += @@LANG_KEY + @@EQ_DELIM + @options[@@LANG_KEY] + @@NEW_LINE

		File.write("#{@configOptions[@@PICO_DIR_KEY]}/#{@@TMP_FILE_NAME}",toPut)
	end

	def getNumberOfProblems()
		doc = Nokogiri::HTML(open(prepareContestLink()))
		return doc.xpath("//td[@class='act']").size
	end
	
	def prepareProblemLink(pb)
		return "#{prepareContestLink()}/problem/#{pb}"
	end

	def prepareContestLink()
		return "http://codeforces.com/contest/#{@options[@@NUMBER_KEY]}"
	end
end

