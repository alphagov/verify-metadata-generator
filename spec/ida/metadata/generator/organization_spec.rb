require 'verify/metadata/generator/organization'
module Verify
  module Metadata
    module Generator
      describe Organization do
        context "#valid?" do
          it "is true when all fields are present" do
            expect(Organization.new("name", "display", "url")).to be_valid
          end

          it "is false when name isn't present" do
            organization = Organization.new(nil, "display", "url")
            expect(organization).to_not be_valid
            expect(organization.errors.messages).to include(:name => ["can't be blank"])
          end

          it "is false when display name isn't present" do
            organization = Organization.new("name", nil, "url")
            expect(organization).to_not be_valid
            expect(organization.errors.messages).to include(:display_name => ["can't be blank"])
          end

          it "is false when url isn't present" do
            organization = Organization.new("name", "display", nil)
            expect(organization).to_not be_valid
            expect(organization.errors.messages).to include(:url => ["can't be blank"])
          end
        end

        context "produces xml" do
          subject {
            Nokogiri::XML::Builder.new do |builder|
              Organization.new("name", "display", "url").append_xml(builder)
            end.to_xml
          }
          let(:expected_xml) {<<-XML
<?xml version="1.0"?>
<md:Organization xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="md:OrganizationType">
  <md:OrganizationName xml:lang="en-GB" xsi:type="md:localizedNameType">name</md:OrganizationName>
  <md:OrganizationDisplayName xml:lang="en-GB" xsi:type="md:localizedNameType">display</md:OrganizationDisplayName>
  <md:OrganizationURL xml:lang="en-GB" xsi:type="md:localizedURIType">url</md:OrganizationURL>
</md:Organization>
          XML
}
          specify { is_expected.to eql expected_xml }
          specify { is_expected.to conform_to_schema METADATA_XSD }
        end
      end
    end
  end
end
