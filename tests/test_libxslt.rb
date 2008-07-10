require 'libxslt'
require 'test/unit'

class TextLibXslt < Test::Unit::TestCase
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
end
