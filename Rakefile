#!/usr/bin/env ruby

require "rubygems"
require "rake/extensiontask"
require "rake/testtask"
require 'hanna/rdoctask'
require "grancher/task"
require "yaml"

GEM_NAME = "libxslt-ruby"
SO_NAME  = "libxslt_ruby"

# Read the spec file
spec = Gem::Specification.load("#{GEM_NAME}.gemspec")

# Setup compile tasks
Rake::ExtensionTask.new do |ext|
  ext.gem_spec = spec
  ext.name = SO_NAME
  ext.ext_dir = "ext/libxslt"
  ext.lib_dir = "lib/#{RUBY_VERSION.sub(/\.\d$/, '')}"
  ext.config_options << "--with-xml2-include=C:/MinGW/local/include/libxml2"
  ext.config_options << "--with-xslt-include=C:/MinGW/local/include/libxslt"
  ext.config_options << "--with-exslt-include=C:/MinGW/local/include/libexslt"
end

# Setup generic gem
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.package_dir = 'pkg'
  pkg.need_tar    = false
end

# Setup Windows Gem
if RUBY_PLATFORM.match(/win32|mingw32/)
  binaries = (FileList['lib/**/*.so'])

  # Windows specification
  win_spec = spec.clone
  win_spec.platform = Gem::Platform::CURRENT
  win_spec.files += binaries.to_a

  # Unset extensions
  win_spec.extensions = nil

  # Rake task to build the windows package
  Rake::GemPackageTask.new(win_spec) do |pkg|
    pkg.package_dir = 'pkg'
    pkg.need_tar = false
  end
end

# RDoc Task
desc "Generate rdoc documentation"
Rake::RDocTask.new("rdoc") do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = "libxml-xslt"
  # Show source inline with line numbers
  rdoc.options << "--inline-source" << "--line-numbers"
  # Make the readme file the start page for the generated html
  rdoc.options << '--main' << 'README'
  rdoc.rdoc_files.include('doc/*.rdoc',
                          'ext/**/*.c',
                          'lib/**/*.rb',
                          'CHANGES',
                          'README',
                          'LICENSE')
end