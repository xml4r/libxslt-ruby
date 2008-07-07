require 'libxslt'
require 'test/unit'

class TC_XSLT_STYLESHEET < Test::Unit::TestCase
  def setup()
    xsl_file = File.expand_path('fuzface.xsl')
    xml_file = File.expand_path('fuzface.xml')

    @xslt = XML::XSLT.file(xsl_file)
    @xslt.doc = XML::Document.file(xml_file)
    @stylesheet = @xslt.parse
  end
  
  def tear_down()
    @xslt = nil
    @stylesheet = nil
  end
  
  #def test_ruby_xslt_parse()
    #assert_instance_of(XML::XSLT::Stylesheet, @stylesheet)
  #end

  def test_ruby_xslt_stylesheet_to_s()
    @stylesheet.apply
    str = @stylesheet.to_s
    assert_instance_of(String, str)
  end

  #def test_ruby_xslt_stylesheet_save()
    #assert_raises(ArgumentError) do
      #@stylesheet.save("str")
    #end
  #end
  
  #def test_ruby_xslt_stylesheet_print()
    #assert_raises(XML::XSLT::Stylesheet::RequireParsedDoc) do
      #@stylesheet.print
    #end
  #end
end
