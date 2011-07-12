# encoding: UTF-8
require 'test/unit'
require 'test_helper'

class TestDeprecated < Test::Unit::TestCase
  def setup()
    xsl_file = File.join(File.dirname(__FILE__), 'files/fuzface.xsl')
    xml_file = File.join(File.dirname(__FILE__), 'files/fuzface.xml')
    
    @xslt = XML::XSLT.file(xsl_file)
    @xslt.doc = XML::Document.file(xml_file)
    @stylesheet = @xslt.parse
  end
  
  def tear_down()
    @xslt = nil
    @stylesheet = nil
  end
  
  def test_constants
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
  
  def test_new
    xslt = XML::XSLT.new
    assert_instance_of(XML::XSLT::Stylesheet, xslt)
    
    xslt.filename = File.join(File.dirname(__FILE__), 'files/fuzface.xsl')
    assert_instance_of(String, xslt.filename)
  end
  
  def test_file_type
    assert_instance_of(XML::XSLT::Stylesheet, @xslt)
  end

  def test_doc
    xsl_file = File.join(File.dirname(__FILE__), 'files/fuzface.xsl')
    xml_file = File.join(File.dirname(__FILE__), 'files/fuzface.xml')
    
    xslt = XML::XSLT.file(xsl_file)
    xslt.doc = XML::Document.file(xml_file)
    assert_instance_of(XML::Document, xslt.doc)
  end
  
  def test_parse
    xsl_file = File.join(File.dirname(__FILE__), 'files/fuzface.xsl')
    xml_file = File.join(File.dirname(__FILE__), 'files/fuzface.xml')
    
    xslt = XML::XSLT.file(xsl_file)
    stylesheet = xslt.parse
    assert_instance_of(XML::XSLT::Stylesheet, stylesheet)
  end
  
  def test_parse
    assert_instance_of(XML::XSLT::Stylesheet, @stylesheet)
  end

  def test_to_s
    @stylesheet.apply
    str = @stylesheet.to_s
    assert_instance_of(String, str)
  end

  def test_save
    @stylesheet.apply
    @stylesheet.save(file = 'text.xml')
  ensure
    File.unlink(file) if file && File.exist?(file)
  end
  
  def test_print_invalid
    @stylesheet.apply
    @stylesheet.print
  end
  
  def test_save_invalid
    assert_raises(ArgumentError) do
      @stylesheet.save("str")
    end
  end
  
  def test_print_invalid
    assert_raises(ArgumentError) do
      @stylesheet.print
    end
  end
end
