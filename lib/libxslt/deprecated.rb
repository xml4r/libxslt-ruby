# :enddoc:
# These classes provide provide backwards compatibility with 
# versions of libxslt-ruby prior to version 0.7.0

module XML
  module XSLT
    MAX_DEPTH = LibXSLT::MAX_DEPTH
    MAX_SORT = LibXSLT::MAX_SORT
    ENGINE_VERSION = LibXSLT::ENGINE_VERSION
    LIBXSLT_VERSION = LibXSLT::LIBXSLT_VERSION
    LIBXML_VERSION = LibXSLT::LIBXML_VERSION
    XSLT_NAMESPACE = LibXSLTLibXSLT_NAMESPACE
    DEFAULT_VENDOR = LibXSLT::DEFAULT_VENDOR
    DEFAULT_VERSION = LibXSLT::DEFAULT_VERSION
    DEFAULT_URL = LibXSLT::DEFAULT_URL
    NAMESPACE_LIBXSLT = LibXSLT::NAMESPACE_LIBXSLT
    NAMESPACE_NORM_SAXON = LibXSLT::NAMESPACE_NORM_SAXON
    NAMESPACE_SAXON = LibXSLT::NAMESPACE_SAXON
    NAMESPACE_XT = LibXSLT::NAMESPACE_XT
    NAMESPACE_XALAN = LibXSLT::NAMESPACE_XALAN
    
    def self.new
      Stylesheet.new(nil)
    end
    
    def self.file(filename)
      doc = Document.file(filename)
      stylesheet = LibXSLT::Stylesheet.new(doc)
      
      result = Stylesheet.new(stylesheet)
      result.filename = filename
      result
    end
    
    class Stylesheet
      attr_accessor :doc, :filename
      
      def initialize(stylesheet)
        @stylesheet = stylesheet
      end
      
      def filename=(value)
        @doc = Document.file(value)
        @filename = value
      end
      
      def parse
        self
      end
      
      def apply
        @result = @stylesheet.apply(@doc)
      end
      
      def save(filename)
        raise(ArgumentError) unless @result
        @result.save(filename)
      end
      
      def print(filename)
        raise(ArgumentError) unless @result
      end
    end
  end
end
  
