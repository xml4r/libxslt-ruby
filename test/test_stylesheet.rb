require 'libxslt'
require 'test/unit'

class TestStylesheet < Test::Unit::TestCase
  def setup
    filename = File.join(File.dirname(__FILE__), 'files/fuzface.xsl')
    doc = XML::Document.file(filename)
    @stylesheet = XSLT::Stylesheet.new(doc)
  end
  
  def tear_down
    @stylesheet = nil
  end
  
  def doc
    filename = File.join(File.dirname(__FILE__), 'files/fuzface.xml')
    XML::Document.file(filename)
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
    filename = File.join(File.dirname(__FILE__), 'files/params.xsl')
    sdoc = XML::Document.file(filename)
    
    filename = File.join(File.dirname(__FILE__), 'files/params.xml')
    stylesheet = XSLT::Stylesheet.new(sdoc)
    doc = XML::Document.file(filename)
    
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
  
  # -- Memory Tests ----
  def test_doc_ownership
    10.times do 
      filename = File.join(File.dirname(__FILE__), 'files/fuzface.xsl')
      sdoc = XML::Document.file(filename)
      stylesheet = XSLT::Stylesheet.new(sdoc)
      
      stylesheet = nil
      GC.start
      assert_equal(156, sdoc.to_s.length)
    end
  end 
     
  def test_stylesheet_ownership
    10.times do 
      filename = File.join(File.dirname(__FILE__), 'files/fuzface.xsl')
      sdoc = XML::Document.file(filename)
      stylesheet = XSLT::Stylesheet.new(sdoc)
      
      sdoc = nil
      GC.start
      
      rdoc = stylesheet.apply(doc)
      assert_equal(5993, rdoc.to_s.length)
    end
  end
      
  def test_result_ownership
    10.times do 
      filename = File.join(File.dirname(__FILE__), 'files/fuzface.xsl')
      sdoc = XML::Document.file(filename)
      stylesheet = XSLT::Stylesheet.new(sdoc)
      
      rdoc = stylesheet.apply(doc)
      rdoc = nil
      GC.start
    end
  end    
end
