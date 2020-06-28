require 'nokogiri'
require 'active_model'

module Verify
  module Metadata
    module Generator
      SpDescriptor = Struct.new(:signing_certificates, :encryption_certificate, :assertion_consumer_service_uri) do
        include ActiveModel::Validations
        validates_presence_of(*self.members)
        validate :well_formed_encryption_certificate
        validate :well_formed_signing_certificates
        def well_formed_encryption_certificate
          return if encryption_certificate.nil? || encryption_certificate.valid?
          encryption_certificate.errors.messages.each do |attribute, messages|
            messages.each do |message|
              errors.add("encryption_certificate #{attribute}", message)
            end
          end
        end

        def well_formed_signing_certificates
          return if signing_certificates.nil?
          signing_certificates.each do |signing_certificate|
            unless signing_certificate.valid?
              signing_certificate.errors.messages.each do |attribute, messages|
                messages.each do |message|
                  errors.add("signing_certificate #{attribute}", message)
                end
              end
            end
          end
        end

        def error_messages
          errors.map {|k,v| "#{k} #{v}"}
        end

        def append_xml(builder)
          builder['md'].SPSSODescriptor(
            'xmlns:md' => 'urn:oasis:names:tc:SAML:2.0:metadata',
            'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
            'protocolSupportEnumeration' => 'urn:oasis:names:tc:SAML:2.0:protocol',
            'xsi:type' => 'md:SPSSODescriptorType',
            'WantAssertionsSigned' => true,
            'AuthnRequestsSigned' => true
          ) {
            encryption_certificate.append_xml(builder)
            signing_certificates.each { |signing_certificate|
              signing_certificate.append_xml(builder)
            }
            builder.AssertionConsumerService( "Binding" => "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST", "Location" => assertion_consumer_service_uri, "index" => "1", "isDefault" => "true", "xsi:type" => "md:IndexedEndpointType")
          }
        end
      end
    end
  end
end
