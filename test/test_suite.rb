# encoding: UTF-8

# Change to current directory so relative
# requires work.
dir = File.dirname(__FILE__)
Dir.chdir(dir)

require './test_libxslt'
require './test_stylesheet'
require './test_deprecated'
require './test_exslt'
