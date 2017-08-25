require 'verify/metadata/generator/idp_descriptor'
require 'verify/metadata/generator/organization'
require 'verify/metadata/generator/certificate'
require File.expand_path('../../../../spec_helper', __FILE__)
require 'nokogiri'
module Verify
  module Metadata
    module Generator
      describe IdpDescriptor do
        let(:sso_uri) {"http://uri.com"}
        context "#valid?" do
          let(:signing_certificates) do
            [signing_certificate_one, signing_certificate_two]
          end
          let(:signing_certificate_one){ double(:certificate, :valid? => true) }
          let(:signing_certificate_two){ double(:certificate, :valid? => true) }
          let(:invalid_certificate){ double(:invalid_certificate, :valid? => false, :errors => certificate_errors) } 
          let(:certificate_errors){ double(:errors, :messages => {"name" => ["can't be blank"]}) }

          it "is false when sso_uri isn't present" do
            descriptor = IdpDescriptor.new()
            expect(descriptor).to_not be_valid
            expect(descriptor.error_messages).to include("sso_uri can't be blank")
          end

          it "is false when signing_certificates isn't present" do
            descriptor = IdpDescriptor.new()
            expect(descriptor).to_not be_valid
            expect(descriptor.error_messages).to include("signing_certificates can't be blank")
          end

          it "is false when a signing certificate is invalid" do
            descriptor = IdpDescriptor.new([invalid_certificate], sso_uri)
            expect(descriptor).to_not be_valid
            expect(descriptor.error_messages).to include("signing_certificate name can't be blank")
          end
        end
        
        context "produces xml" do
          subject {
            signing_certificates = [Certificate.new('signing_one', 'signing', encoded_certificate),Certificate.new('signing_two', 'signing', encoded_certificate)]
            Nokogiri::XML::Builder.new do |builder|
              IdpDescriptor.new(signing_certificates, sso_uri).append_xml(builder)
            end.to_xml
          }
          let(:expected_xml) {<<-XML
<?xml version="1.0"?>
<md:IDPSSODescriptor xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol" xsi:type="md:IDPSSODescriptorType">
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
  <md:SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="#{sso_uri}"/>
</md:IDPSSODescriptor>
            XML
          }
          specify { is_expected.to eql expected_xml }
          specify { is_expected.to conform_to_schema METADATA_XSD }
        end
      end
    end
  end
end
