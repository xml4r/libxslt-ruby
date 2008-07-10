require 'libxslt'
require 'test/unit'

class TestStylesheet < Test::Unit::TestCase
  def setup
    doc = XML::Document.file('files/fuzface.xsl')
    @stylesheet = XSLT::Stylesheet.new(doc)
  end
  
  def tear_down
    @stylesheet = nil
  end
  
  def doc
    XML::Document.file('files/fuzface.xml')
  end
      
  def test_class
    assert_instance_of(XSLT::Stylesheet, @stylesheet)
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
  
  def test_params
    sdoc = XML::Document.file('files/params.xsl')
    stylesheet = XSLT::Stylesheet.new(sdoc)
    doc = XML::Document.file('files/params.xml')
    
    # Start with no params
    result = stylesheet.apply(doc)
    assert_equal('<article>failure</article>', result.root.to_s)
    
    # Now try with params as hash.  /doc is evaluated
    # as an xpath expression
    result = stylesheet.apply(doc, 'bar' => "/doc")
    assert_equal('<article>abc</article>', result.root.to_s)
    
    # Now try with params as hash.  Note the double quote
    # on success - we want to pass a literal string and
    # not an xpath expression.
    result = stylesheet.apply(doc, 'bar' => "'success'")
    assert_equal('<article>success</article>', result.root.to_s)
    
    # Now try with params as an array.
    result = stylesheet.apply(doc, ['bar', "'success'"])
    assert_equal('<article>success</article>', result.root.to_s)
    
    # Now try with invalid array.
    result = stylesheet.apply(doc, ['bar'])
    assert_equal('<article>failure</article>', result.root.to_s)
  end
end
