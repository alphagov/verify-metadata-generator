require 'nokogiri'
require 'securerandom'
require 'active_model'

module Verify
  module Metadata
    module Generator
      EntityDescriptor = Struct.new(:id, :entity_id, :role_descriptor, :organization, :valid_until) do
        include ActiveModel::Validations

        validates_presence_of(:id, :role_descriptor, :entity_id, :organization)
        validate :well_formed_organization
        validate :well_formed_role_descriptor

        def well_formed_organization
          return if organization.nil? || organization.valid?
          organization.errors.messages.each do |attribute, messages|
            messages.each do |message|
              errors.add("organization #{attribute}", message)
            end
          end
        end

        def well_formed_role_descriptor
          return if role_descriptor.nil? || role_descriptor.valid?
          role_descriptor.errors.messages.each do |attribute, messages|
            messages.each do |message|
              errors.add("role_descriptor #{attribute}", message)
            end
          end
        end

        def error_messages
          errors.map {|k,v| "#{k} #{v}"}
        end

        def to_xml
          entity_descriptor_params = {
              'xmlns:md' => 'urn:oasis:names:tc:SAML:2.0:metadata',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
              'ID' => self.id,
              'entityID' => self.entity_id,
              'xsi:type' => 'md:EntityDescriptorType'
          }
          entity_descriptor_params['validUntil'] = self.valid_until unless (valid_until.nil?)
          Nokogiri::XML::Builder.new { |xml|
            xml['md'].EntityDescriptor(entity_descriptor_params) {
              role_descriptor.append_xml(xml)
              organization.append_xml(xml)
            }
          }.doc.root.to_xml
        end
      end
    end
  end
end
