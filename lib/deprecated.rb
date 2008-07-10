# :enddoc:
# These module and classes provide backwards compatibility with 
# versions of libxslt-ruby prior to version 0.7.0.  New code
# should not use these methods.

module XML
  
  module XSLT
    def self.new
      StylesheetDeprecated.new(nil)
    end
    
    def self.file(filename)
      doc = Document.file(filename)
      stylesheet = Stylesheet.new(doc)
      
      result = StylesheetDeprecated.new(stylesheet)
      result.filename = filename
      result
    end
    
    class StylesheetDeprecated
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
  
