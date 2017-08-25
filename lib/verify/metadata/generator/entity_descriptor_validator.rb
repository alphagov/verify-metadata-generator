require 'verify/metadata/generator/generator_error'
module Verify
  module Metadata
    module Generator
      class EntityDescriptorValidator
        def validate(descriptors)
          invalid_descriptors = descriptors.select(&:invalid?)
          if invalid_descriptors.any?
            raise InputValidationError, format_message(invalid_descriptors)
          end
        end

        def format_message(descriptors)
          descriptors.map { |descriptor|
            formatted_errors = descriptor.error_messages.map { |message|
              "  * #{message}"
            }.join("\n")
            "#{descriptor.id} had the following errors:\n#{formatted_errors}"
          }.join("\n")
        end
      end
      InputValidationError = Class.new(GeneratorError)
    end
  end
end
