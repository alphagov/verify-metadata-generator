require "verify/metadata/generator/version"
require "verify/metadata/generator/arguments_parser"
require "verify/metadata/generator/idp_metadata_provider"
require "verify/metadata/generator/hub_metadata_provider"
require "verify/metadata/generator/aggregator"
require "verify/metadata/generator/metadata_writer"
require "verify/metadata/generator/entity_descriptor_validator"
require "verify/metadata/generator/generator_error"
require "verify/metadata/generator/xsd_validator"
require "verify/metadata/generator/store_provider"
require "fileutils"

module Verify
  module Metadata
    module Generator
      METADATA_XSD = File.expand_path("../generator/xsd/saml-schema-metadata-2.0.xsd", __FILE__)

      def self.run!(arguments)
        options = ArgumentsParser.new.parse(arguments)
        Dir.chdir(options.input_directory) unless options.input_directory.nil?
        hub_metadata_provider = create_hub_metadata_provider(options)
        idp_metadata_provider = create_idp_metadata_provider(options)
        aggregator = Aggregator.new
        metadata_writer = MetadataWriter.new(options)
        validator = EntityDescriptorValidator.new
        valid_until = DateTime.now + options.valid_until
        xsd_validator = XsdValidator.new(METADATA_XSD)
        options.environments.each do |environment|
          if options.is_connector
            hub_entity_descriptor = hub_metadata_provider.provide(environment, valid_until)
            validator.validate([hub_entity_descriptor])
            metadata_content = aggregator.generate_metadata_content(hub_entity_descriptor)
          elsif options.is_proxy_node
            proxy_node_entity_descriptor = idp_metadata_provider.provide(environment, valid_until).first
            validator.validate([proxy_node_entity_descriptor])
            metadata_content = aggregator.generate_metadata_content(proxy_node_entity_descriptor)
          else
            hub_entity_descriptor = hub_metadata_provider.provide(environment)
            idp_entity_descriptors = idp_metadata_provider.provide(environment)
            entity_descriptors = [hub_entity_descriptor] + idp_entity_descriptors
            validator.validate(entity_descriptors)
            metadata_content = aggregator.aggregate(entity_descriptors, valid_until)
          end
          xsd_validator.validate!(metadata_content)
          metadata_writer.write(metadata_content, environment)
        end
      rescue GeneratorError => e
        abort e.message
      end

      def self.create_hub_metadata_provider(options)
        yaml_loader = YamlLoader.new
        schema_validator = SchemaValidator.new(Schema::HUB)
        converter = HubEntityDescriptorGenerator.new(StoreProvider.new(options.hub_ca_files))
        HubMetadataProvider.new(yaml_loader, schema_validator, converter)
      end

      def self.create_idp_metadata_provider(options)
        IdpMetadataProvider.new(YamlLoader.new, SchemaValidator.new(Schema::IDP), IdpSourceToEntityDescriptorConverter.new(StoreProvider.new(options.idp_ca_files)))
      end
    end
  end
end
