# This file loads libxslt and adds the LibXSLT namespace
# to the toplevel for conveneience. The end result
# is to have XSLT:: universally exposed.
#
# It is recommend that you only load this file for libs
# that do not have their own namespace, eg. administrative
# scripts, personal programs, etc. For other applications
# require 'libxslt' instead and include LibXSLT into your 
# app/libs namespace.

require 'libxslt'

include LibXML
include LibXSLT

