require 'libxml'
require 'libxslt_ruby'
require 'libxslt/deprecated'

# Map the LibXSLT module into the XSLT module for both backwards
# compatibility and ease of use.
module XSLT
  include LibXSLT::XSLT
end