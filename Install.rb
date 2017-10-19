
require "fileutils"

END_LINE = "\n"

NAME_PICO_PATH  = "picodir"
NAME_CONTEST   = "contest"
NAME_LANG      = "lang"
NAME_PROBLEM   = "problem"
NAME_USERNAME  = "username"
NAME_PASSWORD  = "password"

DEFAULT_PICO_PATH   = Dir.pwd.to_s
DEFAULT_CONTEST    = "codeforces"
DEFAULT_LANG       = "cpp"
DEFAULT_PROBLEM    = "all"
DEFAULT_USERNAME   = "brcz"
DEFAULT_PASSWORD   = "********"

TO_PUT_IN_FILE = NAME_PICO_PATH + "=" + DEFAULT_PICO_PATH + END_LINE +
	NAME_CONTEST + "=" + DEFAULT_CONTEST + END_LINE +
	NAME_LANG + "=" + DEFAULT_LANG + END_LINE +
	NAME_PROBLEM + "=" + DEFAULT_PROBLEM + END_LINE +
	NAME_USERNAME + "=" + DEFAULT_USERNAME + END_LINE +
	NAME_PASSWORD + "=" + DEFAULT_PASSWORD + END_LINE

PICO_FILE = File.new("#{Dir.home}/.pico","w")

File.write(PICO_FILE,TO_PUT_IN_FILE)


if !Gem::Specification::find_all_by_name('nokogiri').any?
	exec("sudo gem install nokogiri")
end

if !Gem::Specification::find_all_by_name('colorize').any?
	exec("sudo gem install colorize")
end
