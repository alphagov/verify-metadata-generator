require 'yaml'
require 'verify/metadata/generator/entity_descriptor'
require 'verify/metadata/generator/certificate'
require 'verify/metadata/generator/organization'
require 'verify/metadata/generator/sp_descriptor'
require 'verify/metadata/generator/organization_provider'
require 'verify/metadata/generator/yaml_loader'
require 'verify/metadata/generator/generator_error'
module Verify
  module Metadata
    module Generator
      class HubMetadataProvider
        def initialize(yaml_loader, schema_validator, converter)
          @yaml_loader = yaml_loader
          @schema_validator = schema_validator
          @converter = converter
        end

        def provide(environment, valid_until = nil)
          loaded_yamls = @yaml_loader.load(File.join(environment, 'hub.yml'))
          raise HubMetadataNotFoundError if loaded_yamls.empty?
          @schema_validator.validate!(loaded_yamls)
          loaded_yamls.map do |loaded_yaml|
            @converter.generate(loaded_yaml.yaml, valid_until)
          end.first
        end


      end

      class HubEntityDescriptorGenerator

        def initialize(store_provider, organization_provider = OrganizationProvider.new)
          @store_provider = store_provider
          @organization_provider = organization_provider
        end

        def generate(hub_metadata_values, valid_until)
          entity_id = hub_metadata_values['entity_id']
          id = hub_metadata_values['id']
          sp_descriptor = load_sp_descriptor(hub_metadata_values)
          organization = @organization_provider.provide(hub_metadata_values['organization'])
          EntityDescriptor.new(id,
                               entity_id,
                               sp_descriptor,
                               organization,
                               valid_until
          )
        end

        def load_sp_descriptor(hub_metadata_values)
          store = @store_provider.provide
          signing_certificates = Array(hub_metadata_values['signing_certificates']).map do |certificate|
            Certificate.new(certificate["name"], "signing", certificate["x509"], store)
          end
          encryption = hub_metadata_values['encryption_certificate']
          encryption_certificate = Certificate.new(encryption["name"], "encryption", encryption["x509"], store)
          assertion_consumer_service_uri = hub_metadata_values['assertion_consumer_service_uri']
          SpDescriptor.new(signing_certificates, encryption_certificate, assertion_consumer_service_uri)
        end
      end
      HubMetadataNotFoundError = Class.new(GeneratorError)
      HubMetadataEmptyError = Class.new(GeneratorError)
    end
  end
end
