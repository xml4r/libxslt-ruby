# encoding: UTF-8
# :enddoc:
# These classes provide provide backwards compatibility with
# versions of libxslt-ruby prior to version 0.7.0

module LibXML
  module XML
    module XSLT
      MAX_DEPTH            = LibXSLT::XSLT::MAX_DEPTH
      MAX_SORT             = LibXSLT::XSLT::MAX_SORT
      ENGINE_VERSION       = LibXSLT::XSLT::ENGINE_VERSION
      LIBXSLT_VERSION      = LibXSLT::XSLT::LIBXSLT_VERSION
      LIBXML_VERSION       = LibXSLT::XSLT::LIBXML_VERSION
      XSLT_NAMESPACE       = LibXSLT::XSLT::XSLT_NAMESPACE
      DEFAULT_VENDOR       = LibXSLT::XSLT::DEFAULT_VENDOR
      DEFAULT_VERSION      = LibXSLT::XSLT::DEFAULT_VERSION
      DEFAULT_URL          = LibXSLT::XSLT::DEFAULT_URL
      NAMESPACE_LIBXSLT    = LibXSLT::XSLT::NAMESPACE_LIBXSLT
      NAMESPACE_NORM_SAXON = LibXSLT::XSLT::NAMESPACE_NORM_SAXON
      NAMESPACE_SAXON      = LibXSLT::XSLT::NAMESPACE_SAXON
      NAMESPACE_XT         = LibXSLT::XSLT::NAMESPACE_XT
      NAMESPACE_XALAN      = LibXSLT::XSLT::NAMESPACE_XALAN

      def self.new
        Stylesheet.new(nil)
      end

      def self.file(filename)
        doc = ::LibXML::XML::Document.file(filename)
        stylesheet = LibXSLT::XSLT::Stylesheet.new(doc)

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
          @doc = ::LibXML::XML::Document.file(value)
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
end
