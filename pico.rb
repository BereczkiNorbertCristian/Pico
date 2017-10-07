#!/usr/bin/env ruby

require "rubygems"
require "uri"
require "nokogiri"
require "open-uri"
require "fileutils"
require "optparse"

#---------------------------- CONSTANTS ----------------------------

@@PATH_TO_PICO_CONFIG 	= "#{Dir.home}/.pico"
@@PICO_DIR_KEY 		= "picodir"
@@ENV_KEY 		= "env"
@@CURRENT_DIR_KEY	= "currdir"

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
PATH_TO_PICO_HOME_DIR = configOptions[@@PICO_DIR_KEY]

require "#{PATH_TO_PICO_HOME_DIR}/argumentsparser.rb"
require "#{PATH_TO_PICO_HOME_DIR}/envCreator.rb"

#----------------------------- PROCESSING --------------------------

argumentsParser = ArgumentsParser.new(configOptions)

begin
	options = argumentsParser.parse(ARGV)
rescue ArgumentError => ae
	puts ae
	exit
end


if options.has_key?(@@ENV_KEY) then
	creator = EnvCreator.new
	creator.createEnv()
end


p configOptions
p options


