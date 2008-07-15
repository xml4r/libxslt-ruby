require 'libxslt'
require 'test/unit'

class TextLibXslt < Test::Unit::TestCase
  def test_constants
    assert_instance_of(Fixnum, LibXSLT::MAX_DEPTH)
    assert_instance_of(Fixnum, LibXSLT::MAX_SORT)
    assert_instance_of(String, LibXSLT::ENGINE_VERSION)
    assert_instance_of(Fixnum, LibXSLT::LIBXSLT_VERSION)
    assert_instance_of(Fixnum, LibXSLT::LIBXML_VERSION)
    assert_instance_of(String, LibXSLT::XSLT_NAMESPACE)
    assert_instance_of(String, LibXSLT::DEFAULT_URL)
    assert_instance_of(String, LibXSLT::DEFAULT_VENDOR)
    assert_instance_of(String, LibXSLT::DEFAULT_VERSION)
    assert_instance_of(String, LibXSLT::NAMESPACE_LIBXSLT)
    assert_instance_of(String, LibXSLT::NAMESPACE_SAXON)
    assert_instance_of(String, LibXSLT::NAMESPACE_XT)
    assert_instance_of(String, LibXSLT::NAMESPACE_XALAN)
    assert_instance_of(String, LibXSLT::NAMESPACE_NORM_SAXON)
  end
end
