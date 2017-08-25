require 'verify/metadata/generator/schema_validator'
module Verify
  module Metadata
    module Generator
      describe SchemaValidator do

        context "#validate!" do
          it "validates the idps and raises if bad" do
            filename = ""
            idp = LoadedYaml.new({}, filename)
            expect {
              (SchemaValidator.new(Schema::IDP).validate!([idp]))
            }.to raise_error SchemaValidator::SchemaError, /file with name '#{filename}' had the following errors:.* did not contain a required property of 'entity_id'/m
          end
        end
      end
    end
  end
end
