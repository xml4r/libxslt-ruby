require 'libxslt'
require 'test/unit'

class TestDeprecated < Test::Unit::TestCase
  def setup()
    xsl_file = File.expand_path('files/fuzface.xsl')
    xml_file = File.expand_path('files/fuzface.xml')

    @xslt = XML::XSLT.file(xsl_file)
    @xslt.doc = XML::Document.file(xml_file)
    @stylesheet = @xslt.parse
  end
  
  def tear_down()
    @xslt = nil
    @stylesheet = nil
  end
  
  def test_file
    xsl_file = File.expand_path('files/fuzface.xsl')
    xslt = XML::XSLT.file(xsl_file)
    assert_instance_of(XML::XSLT::StylesheetDeprecated, xslt)
  end

  def test_new
    xslt = XML::XSLT.new
    assert_instance_of(XML::XSLT::StylesheetDeprecated, xslt)
    
    xslt.filename = File.expand_path('files/fuzface.xsl')
    assert_instance_of(String, xslt.filename)
  end

  def test_doc
    xsl_file = File.expand_path('files/fuzface.xsl')
    xml_file = File.expand_path('files/fuzface.xml')
    
    xslt = XML::XSLT.file(xsl_file)
    xslt.doc = XML::Document.file(xml_file)
    assert_instance_of(XML::Document, xslt.doc)
  end
  
  def test_parse
    xsl_file = File.expand_path('files/fuzface.xsl')
    xml_file = File.expand_path('files/fuzface.xml')
    
    xslt = XML::XSLT.file(xsl_file)
    stylesheet = xslt.parse
    assert_instance_of(XML::XSLT::StylesheetDeprecated, stylesheet)
  end
  
  def test_parse
    assert_instance_of(XML::XSLT::StylesheetDeprecated, @stylesheet)
  end

  def test_to_s
    @stylesheet.apply
    str = @stylesheet.to_s
    assert_instance_of(String, str)
  end

  def test_save
    @stylesheet.apply
    @stylesheet.save("text.xml")
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
