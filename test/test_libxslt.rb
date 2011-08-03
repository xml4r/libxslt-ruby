# encoding: UTF-8
require 'test/unit'
require './test_helper'

class TextLibXslt < Test::Unit::TestCase
  def test_constants
    assert_instance_of(Fixnum, XSLT::MAX_DEPTH)
    assert_instance_of(Fixnum, XSLT::MAX_SORT)
    assert_instance_of(String, XSLT::ENGINE_VERSION)
    assert_instance_of(Fixnum, XSLT::LIBXSLT_VERSION)
    assert_instance_of(Fixnum, XSLT::LIBXML_VERSION)
    assert_instance_of(String, XSLT::XSLT_NAMESPACE)
    assert_instance_of(String, XSLT::DEFAULT_URL)
    assert_instance_of(String, XSLT::DEFAULT_VENDOR)
    assert_instance_of(String, XSLT::DEFAULT_VERSION)
    assert_instance_of(String, XSLT::NAMESPACE_LIBXSLT)
    assert_instance_of(String, XSLT::NAMESPACE_SAXON)
    assert_instance_of(String, XSLT::NAMESPACE_XT)
    assert_instance_of(String, XSLT::NAMESPACE_XALAN)
    assert_instance_of(String, XSLT::NAMESPACE_NORM_SAXON)
  end
end
