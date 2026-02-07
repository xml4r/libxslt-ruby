#!/usr/local/bin/ruby -w

# See the LICENSE file for copyright and distribution information

require 'mkmf'
require 'rbconfig'

require 'rubygems'

def crash(str)
  print(" extconf failure: %s\n", str)
  exit 1
end

# Directories
dir_config('xml2')
dir_config('xslt')
dir_config('exslt')

unless (have_library('xml2', 'xmlXPtrNewContext') or
        have_library('libxml2', 'xmlXPtrNewContext') or
        find_library('xml2', 'xmlXPtrNewContext', '/opt/lib', '/usr/local/lib', '/usr/lib')) and
       (have_header('libxml/xmlversion.h') or
        find_header('libxml/xmlversion.h',
                    '/opt/include/libxml2',
                    '/usr/local/include/libxml2',
                    '/usr/include/libxml2'))
  crash(<<-EOL)
Cannot find libxml2.

        Install the library or try one of the following options to extconf.rb:

        --with-xml2-dir=/path/to/libxml2
        --with-xml2-lib=/path/to/libxml2/lib
        --with-xml2-include=/path/to/libxml2/include
EOL
end

unless (have_library('xslt','xsltApplyStylesheet') or
        have_library('libxslt','xsltApplyStylesheet') or
        find_library('xslt', 'xsltApplyStylesheet', '/opt/lib', '/usr/local/lib', '/usr/lib')) and
       (have_header('xslt.h') or
        find_header('xslt.h',
                    '/opt/include/libxslt',
                    '/usr/local/include/libxslt',
                    '/usr/include/libxslt'))
  crash(<<-EOL)
need libxslt.

        Install the library or try one of the following options to extconf.rb:

        --with-xslt-dir=/path/to/libxslt
        --with-xslt-lib=/path/to/libxslt/lib
        --with-xslt-include=/path/to/libxslt/include
EOL
end

unless (have_library('exslt','exsltRegisterAll') or
        have_library('libexslt','exsltRegisterAll') or
        find_library('exslt', 'exsltRegisterAll', '/opt/lib', '/usr/local/lib', '/usr/lib')) and
       (have_header('exslt.h') or
        find_header('exslt.h',
                    '/opt/include/libexslt',
                    '/usr/local/include/libexslt',
                    '/usr/include/libexslt'))
  crash(<<-EOL)
    Need libexslt.
        Install the library or try one of the following options to extconf.rb:
        --with-exslt-dir=/path/to/libexslt
        --with-exslt-lib=/path/to/libexslt/lib
        --with-exslt-include=/path/to/libexslt/include
   EOL
end

# Figure out where libxml-ruby is installed
unless gem_spec = Gem::Specification.find_by_name('libxml-ruby')
  crash(<<-EOL)
    libxml-ruby gem must be installed
  EOL
end

# Tell gcc where to find ruby_libxml.h
$INCFLAGS << " -I\"#{gem_spec.full_gem_path}/ext/libxml\""

RUBY_VERSION =~ /^(\d+.\d+)/
minor_version = $1
paths = ["#{gem_spec.full_gem_path}/lib",
         "#{gem_spec.full_gem_path}/lib/#{minor_version}",
         "#{gem_spec.full_gem_path}/ext/libxml"]

# No need to link xml_ruby on OS X
unless RbConfig::CONFIG['host_os'].match(/darwin|linux/)
  libraries = ["xml_ruby", # Linux
               ":libxml_ruby.so",  # mingw
               "libxml_ruby-#{RbConfig::CONFIG["arch"]}"] # mswin

  libxml_library = libraries.detect do |library|
    find_library(library, "Init_libxml_ruby", *paths)
  end

  unless libxml_library
    crash(<<-EOL)
      Need libxml-ruby
      Please install libxml-ruby or specify the path to the gem via:
        --with-libxml-ruby=/path/to/libxml-ruby gem
    EOL
  end
  $LIBS.gsub!($LIBRUBYARG_STATIC,'')
end

create_header()
create_makefile("libxslt_ruby")
