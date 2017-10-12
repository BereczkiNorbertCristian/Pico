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

#---------------------------- CONSTANTS ----------------------------

@@PATH_TO_PICO_CONFIG 	= "#{Dir.home}/.pico"

#---------------------------- FUNCTIONS ----------------------------

def getConfigOptions()
		
	configOptions = {}
	File.open(@@PATH_TO_PICO_CONFIG).each do |line|
		name,value = line.strip.split(/=/)
		configOptions[name] = value
	end
	return configOptions
end

#------------------------------ CONFIGS --------------------------------


configOptions = getConfigOptions()
configOptions[@@CURRENT_DIR_KEY] = Dir.pwd.to_s

#----------------------------- PROCESSING --------------------------

argumentsParser = ArgumentsParser.new(configOptions)

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
	rescue Exception => e
		puts e
		Dir.delete(options[@@ENV_KEY])
	end
else if options.has_key?(@@TEST_KEY) then
	begin
		tester = FormalTester.new
		puts tester.test(options)
	rescue Exception => e
		puts e
	end
end


p configOptions
p options


