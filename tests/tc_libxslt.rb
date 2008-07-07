require 'libxslt'
require 'test/unit'

class TC_XSLT < Test::Unit::TestCase
  def test_ruby_xslt_constants()
    assert_instance_of(Fixnum, XML::XSLT::MAX_DEPTH)
    assert_instance_of(Fixnum, XML::XSLT::MAX_SORT)
    assert_instance_of(String, XML::XSLT::ENGINE_VERSION)
    assert_instance_of(Fixnum, XML::XSLT::LIBXSLT_VERSION)
    assert_instance_of(Fixnum, XML::XSLT::LIBXML_VERSION)
    assert_instance_of(String, XML::XSLT::XSLT_NAMESPACE)
    assert_instance_of(String, XML::XSLT::DEFAULT_URL)
    assert_instance_of(String, XML::XSLT::DEFAULT_VENDOR)
    assert_instance_of(String, XML::XSLT::DEFAULT_VERSION)
    assert_instance_of(String, XML::XSLT::NAMESPACE_LIBXSLT)
    assert_instance_of(String, XML::XSLT::NAMESPACE_SAXON)
    assert_instance_of(String, XML::XSLT::NAMESPACE_XT)
    assert_instance_of(String, XML::XSLT::NAMESPACE_XALAN)
    assert_instance_of(String, XML::XSLT::NAMESPACE_NORM_SAXON)
  end

  def test_ruby_xslt_file()
    xsl_file = File.expand_path('fuzface.xsl')
    xslt = XML::XSLT.file(xsl_file)
    assert_instance_of(XML::XSLT, xslt)
  end

  def test_ruby_xslt_new()
    xslt = XML::XSLT.new()
    assert_instance_of(XML::XSLT, xslt)
    
    xslt.filename = File.expand_path('fuzface.xsl')
    assert_instance_of(String, xslt.filename)
  end

  def test_ruby_xslt_doc()
    xsl_file = File.expand_path('fuzface.xsl')
    xml_file = File.expand_path('fuzface.xml')
    
    xslt = XML::XSLT.file(xsl_file)
    xslt.doc = XML::Document.file(xml_file)
    assert_instance_of(XML::Document, xslt.doc)
  end
  
  def test_ruby_xslt_parse()
    xsl_file = File.expand_path('fuzface.xsl')
    xml_file = File.expand_path('fuzface.xml')
    
    xslt = XML::XSLT.file(xsl_file)
    stylesheet = xslt.parse
    assert_instance_of(XML::XSLT::Stylesheet, stylesheet)
  end
end
