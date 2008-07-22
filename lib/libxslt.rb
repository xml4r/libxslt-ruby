# First make sure libxml is loaded
require 'libxml'

# Now if running on Windows, then add the current directory to the PATH
# for the current process so it can find the pre-built libxml2 and 
# iconv2 shared libraries (dlls).
if RUBY_PLATFORM.match(/mswin/i)
  ENV['PATH'] += ";#{File.dirname(__FILE__)}"
end

require 'libxslt_ruby'

require 'libxslt/deprecated'
