require 'verify/metadata/generator/aggregator'

module Verify
  module Metadata
    module Generator
      describe Aggregator do
        context("when there are no entity descriptors") do
          it "will have no entity descriptor nodes" do
            datetime = DateTime.now
            xml = Aggregator.new.aggregate([], datetime)
            expect(xml).to eql <<-xml
<?xml version="1.0" encoding="UTF-8"?>
<md:EntitiesDescriptor xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Name="VERIFY-FEDERATION" ID="_entities" validUntil="#{datetime.iso8601}"/>
            xml
          end
          it "will not be valid for the xsd" do
            xml = Aggregator.new.aggregate([], DateTime.new)
            expect(xml).to_not conform_to_schema(METADATA_XSD)
          end
        end
        context("when there are entity descriptors") do
          it "send to_xml to it" do
            entity_descriptor = instance_double("entity_descriptor")
            foo_tag = '<foo/>'
            expect(entity_descriptor).to receive(:to_xml).and_return foo_tag
            datetime = DateTime.now
            xml = Aggregator.new.aggregate([entity_descriptor], datetime)
            expect(xml).to eql <<-xml
<?xml version="1.0" encoding="UTF-8"?>
<md:EntitiesDescriptor xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Name="VERIFY-FEDERATION" ID="_entities" validUntil="#{datetime.iso8601}">
  <md:foo/>
</md:EntitiesDescriptor>
            xml
          end
        end
      end
    end
  end
end
