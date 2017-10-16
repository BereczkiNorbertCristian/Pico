#!/usr/bin/env ruby

require "rubygems"
require "uri"
require "nokogiri"
require "open-uri"
require "fileutils"
require "optparse"

require_relative "ArgumentsParser.rb"
require_relative "EnvCreator.rb"
require_relative "CodeforcesEnvCreator.rb"
require_relative "Constants.rb"
require_relative "CreatorChooser.rb"
require_relative "FormalTester.rb"

class Main
	include Constants


	def getConfigOptions()
		
		configOptions = {}
		File.open(@@PATH_TO_PICO_CONFIG).each do |line|
			name,value = line.strip.split(/=/)
			configOptions[name] = value
		end
		return configOptions
	end

	def statusPrinter(optionMap)
		
		optionMap.keys().each do |key|
			puts "#{key} = #{optionMap[key]}"
		end
	end

	def run()
	#---------------------------- CONSTANTS ----------------------------

		@@PATH_TO_PICO_CONFIG 	= "#{Dir.home}/.pico"
		@@TMP_CONFIG_FILE	= "Tmp.config"

	#------------------------------ CONFIGS --------------------------------


		configOptions = getConfigOptions()
		configOptions[@@CURRENT_DIR_KEY] = Dir.pwd.to_s
		picoDir = configOptions[@@PICO_DIR_KEY]
	#----------------------------- PROCESSING --------------------------

		argumentsParser = ArgumentsParser.new(configOptions)

		tmpConfigFilePath = "#{picoDir}/#{@@TMP_CONFIG_FILE}"

		unless File.zero? tmpConfigFilePath
		oldOptions = Marshal.load(File.open(tmpConfigFilePath).read())
		end

		begin
			options = argumentsParser.parse(ARGV)
		rescue ArgumentError => ae
			puts ae
			exit
		end

		if options.has_key?(@@ENV_KEY) then
			begin
				chooser = EnvCreatorChooser.new
				creator = chooser.choose(configOptions,options)
				creator.createEnv()
				File.write(tmpConfigFilePath,Marshal.dump(options))
			rescue Exception => e
				puts e
				Dir.delete(options[@@ENV_KEY])
			end
		elsif options.has_key?(@@TEST_KEY) then
			begin
				unless options.has_key? @@ENV_KEY
				options[@@ENV_KEY] = oldOptions[@@ENV_KEY]
				end

				tester = FormalTester.new
				puts tester.test(options)
			rescue Exception => e
				puts e
			end
		elsif options.has_key?(@@RELOAD_KEY) then
			begin
				chooser = EnvCreatorChooser.new
				creator = chooser.choose(configOptions,oldOptions)
				creator.reloadTests()
			rescue Exception => e
				puts e
			end
		elsif options.has_key?(@@STATUS_KEY) then
			statusPrinter(oldOptions)
		end
	end
end

#----MAIN RUNNER----

main = Main.new
main.run()



