# encoding: utf-8

# Determine the current version of the software
version = File.read('ext/libxslt/version.h').match(/\s*RUBY_LIBXSLT_VERSION\s*['"](\d.+)['"]/)[1]

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
  spec.add_dependency('libxml-ruby','>=2.4.0')
  spec.platform = Gem::Platform::RUBY
  spec.require_paths = ["lib", "ext/libxslt"]

  spec.bindir = "bin"
  spec.extensions = ["ext/libxslt/extconf.rb"]
  spec.files = Dir.glob(['CHANGES',
                         'LICENSE',
                         'Rakefile',
                         'README.rdoc',
                         'libxslt-ruby.gemspec',
                         'setup.rb',
                         'doc/**/*',
                         'lib/**/*.rb',
                         'ext/libxslt/*.h',
                         'ext/libxslt/*.c',
                         'ext/vc/*.sln',
                         'ext/vc/*.vcxproj',
                         'test/**/*'])
  spec.test_files = Dir.glob("test/test_*.rb")
  spec.add_development_dependency 'rdoc'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rake-compiler'
  spec.required_ruby_version = '>= 1.8.7'
  spec.date = DateTime.now
  spec.rubyforge_project = 'libxslt-ruby'
end
