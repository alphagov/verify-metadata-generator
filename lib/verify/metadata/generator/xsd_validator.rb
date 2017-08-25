require 'nokogiri'
require 'verify/metadata/generator/generator_error'
module Verify
  module Metadata
    module Generator
      class XsdValidator
        def initialize(xsd)
          Dir.chdir(File.dirname(xsd)) do
            @schema = Nokogiri::XML::Schema(File.read(xsd))
          end

          def validate!(xml)
            document = Nokogiri::XML::Document.parse(xml.to_s)
            errors = @schema.validate(document)
            raise(XsdError, errors) if errors.any?
          end
        end
      end
      XsdError = Class.new(GeneratorError)
    end
  end
end
