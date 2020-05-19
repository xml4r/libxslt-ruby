# encoding: UTF-8
require_relative './test_helper'

class TestExslt < Minitest::Test
  def setup
    @namespace = 'http://test.ext'
    @name = 'ext-func'
    @func = lambda { |xp| xp.to_a.join('|') }
  end

  def teardown
    LibXSLT::XSLT.instance_variable_get(:@module_function_registry).clear
    # or
    #LibXSLT::XSLT.unregister_module_function(@namespace, @name)
  end

  def test_register
    assert !LibXSLT::XSLT.registered_module_function?(@namespace, @name)
    assert  LibXSLT::XSLT.register_module_function(@namespace, @name, &@func)
    assert  LibXSLT::XSLT.registered_module_function?(@namespace, @name)
  end

  def test_register_no_block
    assert_raises(ArgumentError, 'no block given') {
      LibXSLT::XSLT.register_module_function(@namespace, @name)
    }
  end

  def test_register_repeated
    assert_equal     @func, LibXSLT::XSLT.register_module_function(@namespace, @name, &@func)
    assert_equal     @func, LibXSLT::XSLT.register_module_function(@namespace, @name, &@func)
    refute_equal @func, LibXSLT::XSLT.register_module_function(@namespace, @name) { |*| }
  end

  def test_unregister
    test_register  # need to register before we can unregister
    assert  LibXSLT::XSLT.unregister_module_function(@namespace, @name)
    assert !LibXSLT::XSLT.registered_module_function?(@namespace, @name)
  end

  def test_unregister_no_register
    assert !LibXSLT::XSLT.registered_module_function?(@namespace, @name)
    assert !LibXSLT::XSLT.unregister_module_function(@namespace, @name)
  end

  def test_unregister_repeated
    test_register  # need to register before we can unregister
    assert_equal @func, LibXSLT::XSLT.unregister_module_function(@namespace, @name)
    assert_nil LibXSLT::XSLT.unregister_module_function(@namespace, @name)
  end

  def test_callback
    doc = LibXML::XML::Document.file(File.join(File.dirname(__FILE__), 'files/fuzface.xml'))
    xpath = '/commentary/meta/author/*'
    stylesheet = LibXSLT::XSLT::Stylesheet.new(LibXML::XML::Document.string(<<-EOT))
<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ext="#{@namespace}">
  <xsl:template match="/">
    <xsl:element name="root">
      <xsl:value-of select="ext:#{@name}(#{xpath})" />
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
    EOT

    assert LibXSLT::XSLT.register_module_function(@namespace, @name, &@func)
    assert_equal @func[doc.find(xpath)], stylesheet.apply(doc).root.content
  end
end
