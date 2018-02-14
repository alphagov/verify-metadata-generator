require 'yaml'
require 'verify/metadata/generator/certificate'
require 'verify/metadata/generator/organization'
require 'verify/metadata/generator/entity_descriptor'
require 'verify/metadata/generator/idp_descriptor'
require 'verify/metadata/generator/yaml_loader'
require 'verify/metadata/generator/schema_validator'
require 'verify/metadata/generator/schema'
require 'verify/metadata/generator/generator_error'
require 'json-schema'
module Verify
  module Metadata
    module Generator
      class IdpMetadataProvider
        def initialize(yaml_loader, schema_validator, idp_source_to_entity_descriptor)
          @idp_yaml_loader = yaml_loader
          @idp_source_to_entity_descriptor = idp_source_to_entity_descriptor
          @schema_validator = schema_validator
        end

        def provide(environment, valid_until = nil)
          idp_yaml = @idp_yaml_loader.load(File.join(environment, "idps", "*.yml"))
          if idp_yaml.empty?
            raise IdpMetadataNotFoundError, "No IDP metadata source files were found in #{environment}"
          end
          @schema_validator.validate!(idp_yaml)
          enabled_idps = idp_yaml.select { |idp|
            idp.yaml["enabled"]
          }
          if enabled_idps.empty?
            raise NoEnabledIdpMetadataError, "No enabled IDPs were found for #{environment}"
          end
          enabled_idps.map { |idp|
            @idp_source_to_entity_descriptor.generate(idp.yaml, valid_until)
          }
        end
      end

      class IdpSourceToEntityDescriptorConverter
        USE = 'signing'

        def initialize(store_provider)
          @store_provider = store_provider
        end

        def generate(idp_data, valid_until = nil)
          store = @store_provider.provide
          signing_certs = idp_data['signing_certificates'].each_with_index.map{|cert_data, i|
            name = "#{USE}_#{i + 1}"
            Certificate.new(name, USE, cert_data['x509'], store)
          }
          idp_descriptor = IdpDescriptor.new(signing_certs, idp_data['sso_uri'])
          EntityDescriptor.new(idp_data['id'], idp_data['entity_id'], idp_descriptor, Organization.new(*idp_data['organization'].values_at('name', 'display_name', 'url')), valid_until)
        end
      end

      IdpMetadataNotFoundError = Class.new(GeneratorError)
      NoEnabledIdpMetadataError = Class.new(GeneratorError)
    end
  end
end
