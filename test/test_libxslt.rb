# encoding: UTF-8
require_relative './test_helper'

class TextLibXslt < Minitest::Test
  def test_constants
    assert_instance_of(Fixnum, LibXSLT::XSLT::MAX_DEPTH)
    assert_instance_of(Fixnum, LibXSLT::XSLT::MAX_SORT)
    assert_instance_of(String, LibXSLT::XSLT::ENGINE_VERSION)
    assert_instance_of(Fixnum, LibXSLT::XSLT::LIBXSLT_VERSION)
    assert_instance_of(Fixnum, LibXSLT::XSLT::LIBXML_VERSION)
    assert_instance_of(String, LibXSLT::XSLT::XSLT_NAMESPACE)
    assert_instance_of(String, LibXSLT::XSLT::DEFAULT_URL)
    assert_instance_of(String, LibXSLT::XSLT::DEFAULT_VENDOR)
    assert_instance_of(String, LibXSLT::XSLT::DEFAULT_VERSION)
    assert_instance_of(String, LibXSLT::XSLT::NAMESPACE_LIBXSLT)
    assert_instance_of(String, LibXSLT::XSLT::NAMESPACE_SAXON)
    assert_instance_of(String, LibXSLT::XSLT::NAMESPACE_XT)
    assert_instance_of(String, LibXSLT::XSLT::NAMESPACE_XALAN)
  end
end
