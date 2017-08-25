require 'active_model'
module Verify
  module Metadata
    module Generator
      IdpDescriptor = Struct.new(:signing_certificates, :sso_uri) do
        include ActiveModel::Validations
        validates_presence_of(*self.members)
        validate :well_formed_signing_certificates

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
          builder["md"].IDPSSODescriptor("xmlns:md" => "urn:oasis:names:tc:SAML:2.0:metadata", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "protocolSupportEnumeration" => "urn:oasis:names:tc:SAML:2.0:protocol", "xsi:type"=>"md:IDPSSODescriptorType") {
            signing_certificates.each { |signing_certificate|
              signing_certificate.append_xml(builder)
            }
            builder.SingleSignOnService("Binding" => "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST", "Location" => sso_uri)
          }
        end
      end
    end
  end
end
