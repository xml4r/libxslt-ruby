# encoding: utf-8

# Determine the current version of the software
version = File.read('ext/libxslt/version.h').match(/\s*RUBY_LIBXSLT_VERSION\s*['"](\d.+)['"]/)[1]

FILES = FileList[
  'CHANGES',
  'LICENSE',
  'Rakefile',
  'README',
  'libxslt-ruby.gemspec',
  'setup.rb',
  'doc/**/*',
  'lib/**/*.rb',
  'ext/libxslt/*.h',
  'ext/libxslt/*.c',
  'ext/vc/*.sln',
  'ext/vc/*.vcxproj',
  'test/**/*'
]

# Default GEM Specification
Gem::Specification.new do |spec|
  spec.name = "libxslt-ruby"

  spec.homepage = "http://libxslt.rubyforge.org/"
  spec.summary = "Ruby libxslt bindings"
  spec.description = <<-EOF
    The Libxslt-Ruby project provides Ruby language bindings for the GNOME
    XSLT C library.  It is free software, released under the MIT License.
  EOF

  # Determine the current version of the software
  spec.version = version
  spec.author = "Charlie Savage"
  spec.email = "libxml-devel@rubyforge.org"
  spec.add_dependency('libxml-ruby','>=2.0.2')
  spec.platform = Gem::Platform::RUBY
  spec.require_paths = ["lib", "ext/libxslt"]

  spec.bindir = "bin"
  spec.extensions = ["ext/libxslt/extconf.rb"]
  spec.files = FILES.to_a
  spec.test_files = Dir.glob("test/tc_*.rb")

  spec.required_ruby_version = '>= 1.8.4'
  spec.date = DateTime.now
  spec.rubyforge_project = 'libxslt-ruby'
end
