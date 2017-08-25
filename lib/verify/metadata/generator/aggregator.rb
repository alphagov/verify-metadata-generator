require 'nokogiri'
module Verify
  module Metadata
    module Generator
      class Aggregator
        def aggregate(entity_descriptors, valid_until)
          Nokogiri::XML::Builder.new(:encoding => 'UTF-8') { |xml|
            xml['md'].EntitiesDescriptor('xmlns:md' => 'urn:oasis:names:tc:SAML:2.0:metadata', 'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance', 'Name' => 'VERIFY-FEDERATION', 'ID' => '_entities', 'validUntil' => valid_until.iso8601) {
              entity_descriptors.each { |entity_descriptor|
                xml << entity_descriptor.to_xml
              }
            }
          }.to_xml
        end

        def generate_metadata_content(entity_descriptor)
          Nokogiri::XML::Builder.new(:encoding => 'UTF-8') { |xml|
            xml << entity_descriptor.to_xml
          }.to_xml
        end
      end
    end
  end
end
