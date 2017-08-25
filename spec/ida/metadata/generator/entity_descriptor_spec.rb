require 'verify/metadata/generator/entity_descriptor'
require 'verify/metadata/generator/organization'
require 'verify/metadata/generator/certificate'
require 'verify/metadata/generator/sp_descriptor'
require 'spec_helper'

module Verify
  module Metadata
    module Generator
      describe EntityDescriptor do
          let(:entity_id){'entity'}
          let(:id){'id'}
          let(:assertion_consumer_service_uri){'http://foo.com'}
          let(:store) { OpenSSL::X509::Store.new}
          let(:encryption_certificate) do
            Certificate.new('encryption', 'encryption', encoded_certificate, store)
          end
          let(:signing_certificates) do
            [Certificate.new('signing_one', 'signing', encoded_certificate, store),Certificate.new('signing_two', 'signing', encoded_certificate, store)]
          end
          let(:role_descriptor) { SpDescriptor.new(signing_certificates, encryption_certificate, assertion_consumer_service_uri) }
          let(:organization){Organization.new('GOV.UK', 'GOV.UK', 'https://www.gov.uk')}
        let(:expected_xml) {
          <<-XML
<md:EntityDescriptor xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ID="id" entityID="entity" xsi:type="md:EntityDescriptorType">
  <md:SPSSODescriptor protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol" xsi:type="md:SPSSODescriptorType">
    <md:KeyDescriptor use="encryption" xsi:type="md:KeyDescriptorType">
      <ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xsi:type="ds:KeyInfoType">
        <ds:KeyName xmlns:xs="http://www.w3.org/2001/XMLSchema">encryption</ds:KeyName>
        <ds:X509Data xsi:type="ds:X509DataType">
          <ds:X509Certificate>#{encoded_certificate}</ds:X509Certificate>
        </ds:X509Data>
      </ds:KeyInfo>
    </md:KeyDescriptor>
    <md:KeyDescriptor use="signing" xsi:type="md:KeyDescriptorType">
      <ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xsi:type="ds:KeyInfoType">
        <ds:KeyName xmlns:xs="http://www.w3.org/2001/XMLSchema">signing_one</ds:KeyName>
        <ds:X509Data xsi:type="ds:X509DataType">
          <ds:X509Certificate>#{encoded_certificate}</ds:X509Certificate>
        </ds:X509Data>
      </ds:KeyInfo>
    </md:KeyDescriptor>
    <md:KeyDescriptor use="signing" xsi:type="md:KeyDescriptorType">
      <ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xsi:type="ds:KeyInfoType">
        <ds:KeyName xmlns:xs="http://www.w3.org/2001/XMLSchema">signing_two</ds:KeyName>
        <ds:X509Data xsi:type="ds:X509DataType">
          <ds:X509Certificate>#{encoded_certificate}</ds:X509Certificate>
        </ds:X509Data>
      </ds:KeyInfo>
    </md:KeyDescriptor>
    <md:AssertionConsumerService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="http://foo.com" index="1" isDefault="true" xsi:type="md:IndexedEndpointType"/>
  </md:SPSSODescriptor>
  <md:Organization xsi:type="md:OrganizationType">
    <md:OrganizationName xml:lang="en-GB" xsi:type="md:localizedNameType">GOV.UK</md:OrganizationName>
    <md:OrganizationDisplayName xml:lang="en-GB" xsi:type="md:localizedNameType">GOV.UK</md:OrganizationDisplayName>
    <md:OrganizationURL xml:lang="en-GB" xsi:type="md:localizedURIType">https://www.gov.uk</md:OrganizationURL>
  </md:Organization>
</md:EntityDescriptor>
          XML
        }
        it "will use its values to build a hub entity descriptor tag" do
          xml = EntityDescriptor.new(id, entity_id, role_descriptor, organization).to_xml
          expect(xml).to eql expected_xml.rstrip
        end
        it "will conform to the schema" do
          xml = EntityDescriptor.new(id, entity_id, role_descriptor, organization).to_xml
          expect(xml).to conform_to_schema(METADATA_XSD)
        end
        context "#valid?" do
          it "is false when entity_id isn't present" do
            descriptor = EntityDescriptor.new()
            expect(descriptor).to_not be_valid
            expect(descriptor.error_messages).to include("id can't be blank")
          end

          it "is false when entity_id isn't present" do
            descriptor = EntityDescriptor.new()
            expect(descriptor).to_not be_valid
            expect(descriptor.error_messages).to include("entity_id can't be blank")
          end

          it "is false when role_descriptor isn't present" do
            descriptor = EntityDescriptor.new()
            expect(descriptor).to_not be_valid
            expect(descriptor.error_messages).to include("role_descriptor can't be blank")
          end

          it "is false when organization isn't present" do
            descriptor = EntityDescriptor.new()
            expect(descriptor).to_not be_valid
            expect(descriptor.error_messages).to include("organization can't be blank")
          end
          
          it "is false when organization name isn't present" do
            descriptor = EntityDescriptor.new(id, entity_id, role_descriptor, Organization.new)
            expect(descriptor).to_not be_valid
            expect(descriptor.error_messages).to include("organization name can't be blank")
          end

          it "is false when organization display name isn't present" do
            descriptor = EntityDescriptor.new(id, entity_id, role_descriptor, Organization.new)
            expect(descriptor).to_not be_valid
            expect(descriptor.error_messages).to include("organization display_name can't be blank")
          end

          it "is false when organization url isn't present" do
            descriptor = EntityDescriptor.new(id, entity_id, role_descriptor, Organization.new)
            expect(descriptor).to_not be_valid
            expect(descriptor.error_messages).to include("organization url can't be blank")
          end

          it "is false when a role_descriptor is invalid" do
            role_descriptor = SpDescriptor.new
            descriptor = EntityDescriptor.new(id, entity_id, role_descriptor, organization)
            expect(descriptor).to_not be_valid
            expect(descriptor.error_messages).to include("role_descriptor signing_certificates can't be blank")
          end
        end
      end
    end
  end
end
