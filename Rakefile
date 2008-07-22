require 'rubygems'
require 'date'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'date'

# ------- Default Package ----------
FILES = FileList[
  'Rakefile',
  'README',
  'LICENSE',
  'setup.rb',
  'doc/**/*',
  'lib/**/*',
  'ext/libxslt/*.h',
  'ext/libxslt/*.c',
  'ext/mingw/Rakefile',
  'ext/vc/*.sln',
  'ext/vc/*.vcproj',
  'tests/**/*'
]

# Default GEM Specification
default_spec = Gem::Specification.new do |spec|
  spec.name = "libxslt-ruby"
  
  spec.homepage = "http://libxslt.rubyforge.org/"
  spec.summary = "Ruby libxslt bindings"
  spec.description = <<-EOF
    The Libxslt-Ruby project provides Ruby language bindings for the GNOME  
    XSLT C library.  It is free software, released under the MIT License.
  EOF

  # Determine the current version of the software
  spec.version = 
    if File.read('ext/libxslt/version.h') =~ /\s*RUBY_LIBXSLT_VERSION\s*['"](\d.+)['"]/
      CURRENT_VERSION = $1
    else
      CURRENT_VERSION = "0.0.0"
    end
  
  spec.author = "Charlie Savage"
  spec.email = "libxml-devel@rubyforge.org"
  spec.add_dependency('libxml-ruby','>=0.8.2')
  spec.platform = Gem::Platform::RUBY
  spec.require_paths = ["lib", "ext/libxslt"] 
 
  spec.bindir = "bin"
  spec.extensions = ["ext/libxslt/extconf.rb"]
  spec.files = FILES.to_a
  spec.test_files = Dir.glob("test/tc_*.rb")
  
  spec.required_ruby_version = '>= 1.8.4'
  spec.date = DateTime.now
  spec.rubyforge_project = 'libxslt-ruby'
  
  spec.has_rdoc = true
end

# Rake task to build the default package
Rake::GemPackageTask.new(default_spec) do |pkg|
  pkg.package_dir = 'admin/pkg'
  pkg.need_tar = true
  pkg.need_zip = true
end

# ------- Windows Package ----------
binaries = (FileList['ext/mingw/*.so',
                     'ext/mingw/*.dll'])

# Windows specification
win_spec = default_spec.clone
win_spec.extensions = []
win_spec.platform = Gem::Platform::CURRENT
win_spec.files += binaries.map {|binaryname| "lib/#{File.basename(binaryname)}"}

desc "Create Windows Gem"
task :create_win32_gem do
  # Copy the win32 extension built by MingW - easier to install
  # since there are no dependencies of msvcr80.dll
  current_dir = File.expand_path(File.dirname(__FILE__))

  binaries.each do |binaryname|
    target = File.join(current_dir, 'lib', File.basename(binaryname))
    cp(binaryname, target)
  end

  # Create the gem, then move it to pkg
  Gem::Builder.new(win_spec).build
  gem_file = "#{win_spec.name}-#{win_spec.version}-#{win_spec.platform}.gem"
  mv(gem_file, "admin/pkg/#{gem_file}")

  # Remove win extension from top level directory  
  binaries.each do |binaryname|
    target = File.join(current_dir, 'lib', File.basename(binaryname))
    rm(target)
  end
end

# ---------  RDoc Documentation ------
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

task :package => :rdoc
task :package => :create_win32_gem
task :default => :package

Rake::TestTask.new do |t|
  t.libs << "test"
  t.libs << "ext"
end

if not RUBY_PLATFORM.match(/mswin32/i)
  Rake::Task[:test].prerequisites << :extensions
end
