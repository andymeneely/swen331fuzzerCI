require 'mechanize' # you'll need Mechanize installed (gem install mechanize)

# Are you getting this error? 
# `<class:Persistent>': uninitialized constant Process::RLIMIT_NOFILE (NameError)
# On Windows there's a known issue at the moment (https://github.com/sparklemotion/mechanize/issues/529)
# You can read about the workaround there

# This is some example code that just grabs all the links on a page
# More docs can be found here: http://docs.seattlerb.org/mechanize

agent = Mechanize.new
url   = 'http://www.se.rit.edu/~swen-331/projects/fuzzer/index.html'
puts "Visiting #{url}"
agent.get(url).links.each do |link|
  puts "Link: #{link.uri}"
end
