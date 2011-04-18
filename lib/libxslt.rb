# encoding: UTF-8

# First make sure dl is loaded, we use that
# to access the libxml bindings
require 'dl'

# Next load the libxml bindings
require 'libxml'

# Load the C-based binding.
begin
  RUBY_VERSION =~ /(\d+.\d+)/
  require "#{$1}/libxslt_ruby"
rescue LoadError
  require "libxslt_ruby"
end

# And add support for deprecated functions
require 'libxslt/deprecated'
