# encoding: UTF-8
require_relative './test_helper'

class TestStylesheet < Minitest::Test
  def setup
    filename = File.join(File.dirname(__FILE__), 'files/fuzface.xsl')
    doc = LibXML::XML::Document.file(filename)
    @stylesheet = LibXSLT::XSLT::Stylesheet.new(doc)
  end

  def tear_down
    @stylesheet = nil
  end

  def doc
    filename = File.join(File.dirname(__FILE__), 'files/fuzface.xml')
    LibXML::XML::Document.file(filename)
  end

  def test_class
    assert_instance_of(LibXSLT::XSLT::Stylesheet, @stylesheet)
  end

  def test_apply
    result = @stylesheet.apply(doc)
    assert_instance_of(LibXML::XML::Document, result)

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
    sdoc = LibXML::XML::Document.file(filename)

    filename = File.join(File.dirname(__FILE__), 'files/params.xml')
    stylesheet = LibXSLT::XSLT::Stylesheet.new(sdoc)
    doc = LibXML::XML::Document.file(filename)

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
      sdoc = LibXML::XML::Document.file(filename)
      GC.start
      assert_equal(173, sdoc.to_s.length)
    end
  end

  def test_stylesheet_ownership
    10.times do
      filename = File.join(File.dirname(__FILE__), 'files/fuzface.xsl')
      sdoc = LibXML::XML::Document.file(filename)
      stylesheet = LibXSLT::XSLT::Stylesheet.new(sdoc)

      sdoc = nil
      GC.start

      rdoc = stylesheet.apply(doc)
      assert_equal(5963, rdoc.to_s.length)
    end
  end

  def test_result_ownership
    10.times do
      filename = File.join(File.dirname(__FILE__), 'files/fuzface.xsl')
      sdoc = LibXML::XML::Document.file(filename)
      stylesheet = LibXSLT::XSLT::Stylesheet.new(sdoc)

      rdoc = stylesheet.apply(doc)
      rdoc = nil
      GC.start
    end
  end

  #RAF#
  def test_stylesheet_string
    filename = File.join(File.dirname(__FILE__), 'files/params.xsl')
    style = File.open(filename).readline(nil)
    stylesheet = LibXSLT::XSLT::Stylesheet.string(style)
    assert_instance_of(LibXSLT::XSLT::Stylesheet, stylesheet)
  end

  def test_stylesheet_file
    filename = File.join(File.dirname(__FILE__), 'files/params.xsl')
    stylesheet = LibXSLT::XSLT::Stylesheet.file(filename)
    assert_instance_of(LibXSLT::XSLT::Stylesheet, stylesheet)
  end

  def test_stylesheet_io
    filename = File.join(File.dirname(__FILE__), 'files/params.xsl')
    stylesheet = LibXSLT::XSLT::Stylesheet.io(File.open(filename))
    assert_instance_of(LibXSLT::XSLT::Stylesheet, stylesheet)
  end

  def test_output
    filename = File.join(File.dirname(__FILE__), 'files/fuzface.xsl')
    sdoc = LibXML::XML::Document.file(filename)
    stylesheet = LibXSLT::XSLT::Stylesheet.new(sdoc)

    rdoc = stylesheet.apply(doc)

    xml = stylesheet.output(rdoc)

    # output method is html -> no xml decl, empty tags not closed...
    assert xml =~ /^<html>/
    assert xml =~ /<meta http-equiv="Content-Type" content="text\/html; charset=UTF-8">\n<title>/
  end

  def test_transform
    filename = File.join(File.dirname(__FILE__), 'files/fuzface.xsl')
    sdoc = LibXML::XML::Document.file(filename)
    stylesheet = LibXSLT::XSLT::Stylesheet.new(sdoc)

    xml = stylesheet.transform(doc)

    assert xml =~ /<meta http-equiv="Content-Type" content="text\/html; charset=UTF-8">\n<title>/
  end

  def test_entities
    style = <<EOF
<!DOCTYPE xsl:stylesheet [
<!ENTITY foo 'bar'>
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="a">
    <out><xsl:text>&foo;</xsl:text>
    <xsl:apply-templates/></out>
  </xsl:template>
</xsl:stylesheet>
EOF

    styledoc = LibXML::XML::Parser.string(style, :options => LibXSLT::XSLT::Stylesheet::PARSE_OPTIONS).parse
    stylesheet = LibXSLT::XSLT::Stylesheet.new(styledoc)

    xml = "<!DOCTYPE a [<!ENTITY bla 'fasel'>]><a>&bla;</a>"
    doc = LibXML::XML::Parser.string(xml, :options => LibXSLT::XSLT::Stylesheet::PARSE_OPTIONS).parse

    out = stylesheet.apply( doc )
    dump = stylesheet.output( out )
    assert_match( /<out>barfasel<\/out>/, dump)

    # no entity replacement in document
    doc = LibXML::XML::Parser.string(xml, :options => 0).parse
    out = stylesheet.apply( doc )
    dump = stylesheet.output( out )

    assert_match(/<out>bar<\/out>/, dump) # entity content is missing

    # note: having entities in your stylesheet that are not replaced during
    # parse, will crash libxslt (segfault)
    # seems to be a libxslt problem; you should not do that anyway
    # styledoc = LibXML::XML::Parser.string(style, : options => 0).parse
    # stylesheet = LibXSLT::XSLT::Stylesheet.new(styledoc)
  end

  def test_cdatasection
    doc = LibXML::XML::Parser.string("<a/>").parse

    style = <<EOF
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="a">
    <out><xsl:text disable-output-escaping="yes"><![CDATA[<>]]></xsl:text></out>
  </xsl:template>
</xsl:stylesheet>
EOF

    styledoc = LibXML::XML::Parser.string(style, :options => LibXSLT::XSLT::Stylesheet::PARSE_OPTIONS).parse
    stylesheet = LibXSLT::XSLT::Stylesheet.new(styledoc)

    out = stylesheet.apply( doc )
    dump = stylesheet.output( out )
    assert_match( /<out><><\/out>/, dump)

    # without propper parse options (result is wrong from an xml/xslt point of view)
    styledoc = LibXML::XML::Parser.string(style).parse
    stylesheet = LibXSLT::XSLT::Stylesheet.new(styledoc)

    out = stylesheet.apply( doc )
    dump = stylesheet.output( out )
    assert_match( /<out>&lt;&gt;<\/out>/, dump)
  end
end
