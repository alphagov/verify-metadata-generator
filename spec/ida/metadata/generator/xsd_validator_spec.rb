require 'verify/metadata/generator/xsd_validator'
require 'spec_helper'
module Verify
  module Metadata
    module Generator
      describe XsdValidator do
        it "raises an XSD Error when the XML doesn't conform to the XSD" do
          bad_xml = File.read(PO_XML).sub(/<city>[^<]*<\/city>/, '')
          expect{XsdValidator.new(PO_XSD).validate!(bad_xml)}.to raise_error XsdError, "[#<Nokogiri::XML::SyntaxError: 7:0: ERROR: Element 'state': This element is not expected. Expected is ( city ).>]"
        end

        it "does nothing when xsd is OK" do
          XsdValidator.new(PO_XSD).validate!(File.read(PO_XML))
        end
      end
    end
  end
end
