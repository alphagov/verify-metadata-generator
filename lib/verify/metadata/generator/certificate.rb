require 'active_model'
require 'base64'
module Verify
  module Metadata
    module Generator
      Certificate = Struct.new(:name, :use, :x509, :store) do
        include ActiveModel::Validations
        validates_presence_of :name, :use, :x509
        validate :validate_certificate

        validates :use, inclusion: { in: %w{encryption signing}, allow_blank: true, message: "must be either encryption or signing"}

        def validate_certificate
          return if x509.nil?
          der = Base64.decode64(x509)
          certificate = OpenSSL::X509::Certificate.new(der)
          verify_against_store(certificate)
        rescue OpenSSL::X509::CertificateError => e
          errors.add :x509, "is not valid x509 (#{e.message})"
        end

        def verify_against_store(certificate)
          unless store.verify(certificate)
            errors.add :x509, "could not establish trust anchor"
          end
        end


        def append_xml(builder)
          builder["md"].KeyDescriptor("xmlns:md" => "urn:oasis:names:tc:SAML:2.0:metadata", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "use" => self.use, "xsi:type"=> "md:KeyDescriptorType") {
            builder["ds"].KeyInfo("xmlns:ds" => "http://www.w3.org/2000/09/xmldsig#", "xsi:type" => "ds:KeyInfoType") {
              builder.KeyName(self.name, "xmlns:xs" => "http://www.w3.org/2001/XMLSchema")
              builder.X509Data("xsi:type" => "ds:X509DataType") {
                builder.X509Certificate(self.x509)
              }
            }
            if self.use == 'encryption'
              builder["md"].EncryptionMethod("Algorithm" => "http://www.w3.org/2009/xmlenc11#aes256-gcm")
              builder["md"].EncryptionMethod("Algorithm" => "http://www.w3.org/2009/xmlenc11#aes128-gcm")
            end
          }
        end
      end
    end
  end
end
