require 'libxslt'
require 'test/unit'

class TestStylesheet < Test::Unit::TestCase
  include XML::XSLT
  
  def setup()
    doc = XML::Document.file('files/fuzface.xsl')
    @stylesheet = Stylesheet.new(doc)
  end
  
  def tear_down()
    @stylesheet = nil
  end
  
  def doc
    XML::Document.file('files/fuzface.xml')
  end
      
  def test_class
    assert_instance_of(Stylesheet, @stylesheet)
  end

  def test_apply
    result = @stylesheet.apply(doc)
    assert_instance_of(XML::Document, result)
    
    paragraphs = result.find('//p')
    assert_equal(11, paragraphs.length)
  end

  def test_apply_multiple
    10.times do
      test_apply
    end
  end
end
