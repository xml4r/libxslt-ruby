# :enddoc:
# These classes provide provide backwards compatibility with 
# versions of libxslt-ruby prior to version 0.7.0

module XML
  module XSLT
    MAX_DEPTH = ::XSLT::MAX_DEPTH
    MAX_SORT = ::XSLT::MAX_SORT
    ENGINE_VERSION = ::XSLT::ENGINE_VERSION
    LIBXSLT_VERSION = ::XSLT::LIBXSLT_VERSION
    LIBXML_VERSION = ::XSLT::LIBXML_VERSION
    XSLT_NAMESPACE = ::XSLT::XSLT_NAMESPACE
    DEFAULT_VENDOR = ::XSLT::DEFAULT_VENDOR
    DEFAULT_VERSION = ::XSLT::DEFAULT_VERSION
    DEFAULT_URL = ::XSLT::DEFAULT_URL
    NAMESPACE_LIBXSLT = ::XSLT::NAMESPACE_LIBXSLT
    NAMESPACE_NORM_SAXON = ::XSLT::NAMESPACE_NORM_SAXON
    NAMESPACE_SAXON = ::XSLT::NAMESPACE_SAXON
    NAMESPACE_XT = ::XSLT::NAMESPACE_XT
    NAMESPACE_XALAN = ::XSLT::NAMESPACE_XALAN
    
    def self.new
      Stylesheet.new(nil)
    end
    
    def self.file(filename)
      doc = Document.file(filename)
      stylesheet = ::XSLT::Stylesheet.new(doc)
      
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
  
