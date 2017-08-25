require 'json-schema'
require 'verify/metadata/generator/loaded_yaml'
require 'verify/metadata/generator/generator_error'
module Verify
  module Metadata
    module Generator
      class SchemaValidator
        def initialize(schema)
          @schema = schema
        end

        def validate(entity)
          errors = JSON::Validator.fully_validate(@schema, entity.yaml)
          ValidatedYaml.new(entity, errors)
        end

        def validate!(entities)
          bad_yaml = entities.map { |entity|
            validate(entity)
          }.select(&:bad?)

          if bad_yaml.any?
            error_message = bad_yaml.map(&:error_message).join("\n")
            raise SchemaError.new(error_message)
          end
        end
        SchemaError = Class.new(GeneratorError)

        class ValidatedYaml < DelegateClass(LoadedYaml)
          attr_reader :errors
          def initialize(loaded_yaml, errors)
            super(loaded_yaml)
            @errors = errors
          end

          def bad?
            errors.any?
          end

          def error_message
            "file with name '#{name}' had the following errors:\n#{errors.join("\n")}"
          end
        end
      end
    end
  end
end
