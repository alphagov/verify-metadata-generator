require 'verify/metadata/generator/certificate'
require File.expand_path('../../../../spec_helper', __FILE__)
require 'nokogiri'
module Verify
  module Metadata
    module Generator
      describe Certificate do
        context "#valid?" do
          let(:fake_store){ double(:store, :verify => true) }
          it "is true when all fields are present" do
            certificate = Certificate.new("name", "signing", encoded_certificate, fake_store)
            certificate.valid?
            expect(certificate.errors.messages).to be_empty
          end

          it "is false when name isn't present" do
            certificate = Certificate.new(nil, "signing", "x509")
            expect(certificate).to_not be_valid
            expect(certificate.errors.messages).to include(:name => ["can't be blank"])
          end

          it "is false when display name isn't present" do
            certificate = Certificate.new("name", "signing", nil)
            expect(certificate).to_not be_valid
            expect(certificate.errors.messages).to include(:x509 => ["can't be blank"])
          end
          
          it "is false when the certificate data isn't valid x509" do
            certificate = Certificate.new("name", "signing", "some bad cert")
            expect(certificate).to_not be_valid
            expect(certificate.errors.messages).to include(:x509 => ["is not valid x509 (header too long)"])
          end
          it "is true when the certificate data doesn't have whitespace" do
            certificate = Certificate.new("name", "signing", encoded_certificate.split("\n").join, fake_store)
            expect(certificate).to be_valid
          end

          it "is false when the store can't verify the certificate" do
            store = OpenSSL::X509::Store.new
            store.add_cert CertificateHelper::PKI.new.root_ca
            certificate = Certificate.new("name", "signing", encoded_certificate, store)
            expect(certificate).to_not be_valid
            expect(certificate.errors.messages).to include(:x509 => ["could not establish trust anchor"])
          end

          it "is true when the store can verify the certificate" do
            pki = CertificateHelper::PKI.new
            cert = pki.sign(generate_cert)
            inline_cert = Base64.encode64(cert.to_der)
            store = OpenSSL::X509::Store.new
            store.add_cert pki.root_ca
            certificate = Certificate.new("name", "signing", inline_cert, store)
            expect(certificate).to be_valid
          end

          context "#use" do
            it "can be signing" do
              certificate = Certificate.new("name", "signing", encoded_certificate, fake_store)
              expect(certificate).to be_valid
            end
            it "can be encryption" do
              certificate = Certificate.new("name", "encryption", encoded_certificate, fake_store)
              expect(certificate).to be_valid
            end
            it "can't be something else" do
              certificate = Certificate.new("name", "not encryption", encoded_certificate, fake_store)
              expect(certificate).to_not be_valid
              expect(certificate.errors.messages).to include(:use => ["must be either encryption or signing"])
            end
          end
        end
        context "produces xml" do
          subject { 
                    Nokogiri::XML::Builder.new do |builder|
                      Certificate.new("name", "encryption", encoded_certificate).append_xml(builder)
                    end.to_xml
          }
          let(:expected_xml) { <<-XML
<?xml version="1.0"?>
<md:KeyDescriptor xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" use="encryption" xsi:type="md:KeyDescriptorType">
  <ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xsi:type="ds:KeyInfoType">
    <ds:KeyName xmlns:xs="http://www.w3.org/2001/XMLSchema">name</ds:KeyName>
    <ds:X509Data xsi:type="ds:X509DataType">
      <ds:X509Certificate>#{encoded_certificate}</ds:X509Certificate>
    </ds:X509Data>
  </ds:KeyInfo>
</md:KeyDescriptor>
          XML
          }
          specify { is_expected.to eql expected_xml }
          specify { is_expected.to conform_to_schema METADATA_XSD }
        end
      end
    end
  end
end
