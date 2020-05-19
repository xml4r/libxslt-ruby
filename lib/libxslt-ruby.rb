# encoding: UTF-8

# Load the libxml bindings
require 'libxml'

# Load the C-based binding.
begin
  RUBY_VERSION =~ /(\d+.\d+)/
  require "#{$1}/libxslt_ruby"
rescue LoadError
  require "libxslt_ruby"
end

require 'libxslt/stylesheet'
