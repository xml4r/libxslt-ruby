#!/usr/bin/env ruby

require 'rubygems'
require 'rake/extensiontask'
require 'rake/testtask'
require 'rdoc/task'
require 'yaml'

GEM_NAME = 'libxslt-ruby'
SO_NAME  = 'libxslt_ruby'

# Read the spec file
spec = Gem::Specification.load("#{GEM_NAME}.gemspec")

# Setup compile tasks.  Configuration can be passed via EVN.
# Example:
#  rake compile with_xml2_include=C:/MinGW/local/include/libxml2
#               with_xslt_include=C:/MinGW/local/include/libxslt
#               with_exslt_include=C:/MinGW/local/include/libexslt
Rake::ExtensionTask.new do |ext|
  ext.gem_spec = spec
  ext.name = SO_NAME
  ext.ext_dir = "ext/libxslt"
  ext.lib_dir = "lib/#{RUBY_VERSION.sub(/\.\d$/, '')}"
  
  ext.config_options << "--with-zlib-dir=C:/MinGW64/local"
  ext.config_options << "--with-xml2-include=C:/MinGW64/local/include/libxml2"
  ext.config_options << "--with-xslt-include=C:/MinGW64/local/include/libxslt"
  ext.config_options << "--with-exslt-include=C:/MinGW64/local/include/libexslt"

  ENV.each do |key, val|
    next unless key =~ /\Awith_(\w+)\z/i
    opt = $1.downcase.tr('_', '-')
    if File.directory?(path = File.expand_path(val))
      ext.config_options << "--with-#{opt}=#{path}"
    else
      warn "No such directory: #{opt}: #{path}"
    end
  end
end

# Setup generic gem
Gem::PackageTask.new(spec) do |pkg|
  pkg.package_dir = 'pkg'
  pkg.need_tar    = false
end

# Setup Windows Gem
if RUBY_PLATFORM.match(/win32|mingw32/)
  binaries = (FileList['lib/**/*.so',
                       'lib/**/*dll'])

  # Windows specification
  win_spec = spec.clone
  win_spec.platform = Gem::Platform::CURRENT
  win_spec.files += binaries.to_a
  win_spec.instance_variable_set(:@cache_file, nil)

  # Unset extensions
  win_spec.extensions = nil

  # Rake task to build the windows package
  Gem::PackageTask.new(win_spec) do |pkg|
    pkg.package_dir = 'pkg'
    pkg.need_tar = false
  end
end

# RDoc Task
desc "Generate rdoc documentation"
RDoc::Task.new("rdoc") do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = "libxml-xslt"
  # Show source inline with line numbers
  rdoc.options << "--line-numbers"
  # Make the readme file the start page for the generated html
  rdoc.options << '--main' << 'README.rdoc'
  rdoc.rdoc_files.include('doc/*.rdoc',
                          'ext/**/*.c',
                          'lib/**/*.rb',
                          'CHANGES',
                          'README.rdoc',
                          'LICENSE')
end

# Test Task
Rake::TestTask.new do |t|
  t.libs << "test"
  t.verbose = true
end
