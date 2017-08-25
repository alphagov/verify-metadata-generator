require 'verify/metadata/generator/yaml_loader'
require File.expand_path('../../../../spec_helper', __FILE__)
module Verify
  module Metadata
    module Generator
      describe YamlLoader do
        before(:each) do
          create_dir(idp_dir)
        end
        let(:idp_dir) {
          "idps"
        }
        let(:load_path) {
          "#{idp_dir}/*.yml"
        }
        it "returns an empty array when there are no idps" do
          expect(YamlLoader.new.load(load_path)).to be_empty
        end

        it "throws an Psych::SyntaxError with invalid YAML" do
          write_file(File.join(idp_dir, "idp.yml"), 'bob: "1"\n, 12')
          expect do
            Dir.chdir(current_dir) do
              YamlLoader.new.load(load_path)
            end
          end.to raise_error Psych::SyntaxError
        end

        it "returns an array containing hashes of the yaml files" do
          idp_one = <<-yml
id: IDPONE
entity_id: entity
          yml
          write_file(File.join(idp_dir, "idp_one.yml"), idp_one)
          idp_two = <<-yml
id: IDPTWO
entity_id: entity
          yml
          write_file(File.join(idp_dir, "idp_two.yml"), idp_two)
          expected_loaded_yaml = [
            LoadedYaml.new({"id" => "IDPONE", "entity_id" => "entity"}, "idp_one.yml"), 
            LoadedYaml.new({"id" => "IDPTWO", "entity_id" => "entity"}, "idp_two.yml")
          ]
          Dir.chdir(current_dir) do
            expect(YamlLoader.new.load(load_path)).to match_array expected_loaded_yaml
          end
        end
      end
    end
  end
end
