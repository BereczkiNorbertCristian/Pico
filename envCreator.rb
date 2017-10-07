
require "nokogiri"
require "open-uri"

class EnvCreator

	@@ENV_KEY 		= "env"
	@@LANG_KEY 		= "lang"
	@@CONTEST_KEY 		= "contest"
	@@NUMBER_KEY 		= "number"
	@@TMP_FILE_NAME 	= "tmp.config"
	@@PICO_DIR_KEY  	= "picodir"
	@@CURRENT_DIR_KEY 	= "currdir"
	
	@@EQ_DELIM 	= "="
	@@NEW_LINE 	= "\n"
	@@UNIX_DELIM 	= "/"
	@@IN_SUFFIX 	= "in"
	@@OUT_SUFFIX 	= "out"
	@@FIRST_CHAR 	= 0
	@@a		= 97
	@@IN_CLASS	= "input"
	@@OUT_CLASS	= "output"

	def initialize(configOptions,options)
		@configOptions = configOptions
		@options = options
	end

	def createEnv()
		
		processEnvPath()
		numberOfProblems = getNumberOfProblems()
		createEmptySources(numberOfProblems)
		createTests(numberOfProblems)
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
		doc.xpath("//div[@class='#{type}']").each do |el|
			toPut = el.children[1].to_s.gsub("<br>","\n").gsub(/<\/{0,1}pre>/,"")
			File.write("#{options[@@ENV_KEY]}/#{pb}#{nr}.#{suffix}")
			nr+=1	
		end
	end

	def processEnvPath()

		currentEnvPath = options[@@ENV_KEY]
		if currentEnvPath[@@FIRST_CHAR] != @@UNIX_DELIM then
			currentEnvPath = configOptions[@@CURRENT_DIR_KEY]
		end
		options[@@ENV_KEY] = currentEnvPath
		Dir.mkdir(currentEnvPath) unless File.exists?(currentEnvPath)
	end

	def createEmptySources(numberOfProblems)
		
		numberOfProblems.times { |i|
			pb = (@@a + i).chr
			File.write("#{options[@@ENV_KEY]}/#{pb}.#{options[@@LANG_KEY]}",'')
		}
	end

	def saveEnvConfig()
		toPut = ""
		toPut += @@CONTEST_KEY + @@EQ_DELIM + options[@@CONTEST_KEY] + @@NEW_LINE
		toPut += @@ENV_KEY + @@EQ_DELIM + options[@@CONTEST_KEY] + @@NEW_LINE
		toPut += @@NUMBER_KEY + @@EQ_DELIM + options[@@NUMBER_KEY] + @@NEW_LINE
		toPus += @@LANG_KEY + @@EQ_DELIM + options[@@LANG_KEY] + @@NEW_LINE

		File.write("#{configOptions[@@PICO_DIR_KEY]}/#{@@TMP_FILE_NAME}",toPut)
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

