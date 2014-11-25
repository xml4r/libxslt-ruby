#!/usr/local/bin/ruby -w

# See the LICENSE file for copyright and distribution information

require 'mkmf'
require 'rbconfig'

require 'rubygems'
$preload = nil
$INCFLAGS << " -I/usr/local/include"
$LIBPATH.push(RbConfig::CONFIG['libdir'])

def crash(str)
  print(" extconf failure: %s\n", str)
  exit 1
end

# Directories
dir_config('iconv')
dir_config('zlib')
dir_config('xml2')
dir_config('xslt')
dir_config('exslt')

# Ruby 1.9 has ruby/io.h instead of rubyio.h
have_header('ruby/io.h')

# First get zlib
unless have_library('z', 'inflate') or
       have_library('zlib', 'inflate') or
       have_library('zlib1', 'inflate') or
       have_library('libz', 'inflate')
  crash('need zlib')
else
  $defs.push('-DHAVE_ZLIB_H')
end

unless have_library('iconv','iconv_open') or
       have_library('iconv','libiconv_open') or
       have_library('libiconv', 'libiconv_open') or
       have_library('libiconv', 'iconv_open') or
       have_library('c','iconv_open') or
       have_library('recode','iconv_open') or
       have_library('iconv')
  crash(<<-EOL)
need libiconv.

Install the libiconv or try passing one of the following options
to extconf.rb:

  --with-iconv-dir=/path/to/iconv
  --with-iconv-lib=/path/to/iconv/lib
  --with-iconv-include=/path/to/iconv/include
EOL
end


unless (have_library('xml2', 'xmlXPtrNewRange') or
        have_library('libxml2', 'xmlXPtrNewRange') or
        find_library('xml2', 'xmlXPtrNewRange', '/opt/lib', '/usr/local/lib', '/usr/lib')) and
       (have_header('libxml/xmlversion.h') or
        find_header('libxml/xmlversion.h',
                    '/opt/include/libxml2',
                    '/usr/local/include/libxml2',
                    '/usr/include/libxml2'))
  crash(<<-EOL)
need libxml2.

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
    libxml-ruby bindings must be installed
  EOL
end

unless find_header("ruby_libxml.h", "#{gem_spec.full_gem_path}/ext/libxml")
  crash(<<-EOL)
    Need headers for libxml-ruby.
  EOL
end


RUBY_VERSION =~ /(\d+.\d+)/
minor_version = $1
paths = ["#{gem_spec.full_gem_path}/lib", 
         "#{gem_spec.full_gem_path}/lib/#{minor_version}",
         "#{gem_spec.full_gem_path}/ext/libxml"]

is_osx = RbConfig::CONFIG['host_os'].match(/darwin/)
is_rbx = defined?(RUBY_ENGINE) && (RUBY_ENGINE == "rbx")

# No need to link xml_ruby on OS X
# Also do not link on rubinius
unless (is_osx or is_rbx)
  # Hack to make sure ruby library is *after* xml_ruby library
  $LIBS = "#{$LIBRUBYARG_STATIC} #{$LIBS}"

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
