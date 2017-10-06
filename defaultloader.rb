
require "fileutils"

class DefaultsLoader

	@@PATH_TO_CONFIG = "#{Dir.home}/.pico"	

	def getDefaults()
		
		options = {}
		File.open(@@PATH_TO_CONFIG).each do |line|
			name,value = line.strip.split(/=/)
			options[name] = value
		end
		return options
	end
end

