#!/usr/bin/env ruby

require "rubygems"
require "uri"
require "nokogiri"
require "open-uri"
require "fileutils"
require "optparse"

require_relative "defaultloader"
require_relative "argumentsparser"

defaultsLoader = DefaultsLoader.new
defaults = defaultsLoader.getDefaults()

argumentsParser = ArgumentsParser.new(defaults)
options = argumentsParser.parse(ARGV)

p defaults
p options


