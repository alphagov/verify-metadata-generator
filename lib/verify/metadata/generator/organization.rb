require 'active_model'
module Verify
  module Metadata
    module Generator
      Organization = Struct.new(:name, :display_name, :url) do
        include ActiveModel::Validations
        validates_presence_of :name, :display_name, :url

        def append_xml(builder)
          builder["md"].Organization("xmlns:md" => "urn:oasis:names:tc:SAML:2.0:metadata", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "xsi:type" => "md:OrganizationType") {
            builder.OrganizationName(self.name, "xml:lang" => "en-GB", "xsi:type" => "md:localizedNameType")
            builder.OrganizationDisplayName(self.display_name, "xml:lang" => "en-GB", "xsi:type" => "md:localizedNameType") 
            builder.OrganizationURL(self.url, "xml:lang" => "en-GB", "xsi:type" => "md:localizedURIType") {}
          }
        end
      end
    end
  end
end
