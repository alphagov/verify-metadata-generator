require 'verify/metadata/generator/loaded_yaml'
require 'yaml'
module Verify
  module Metadata
    module Generator
      class YamlLoader
        def load(pattern)
          Dir.glob(pattern).sort.map { |filename|
            load_file(filename)
          }
        end

        def load_file(filename)
          yaml = YAML.load_file(filename)
          LoadedYaml.new(yaml, File.basename(filename))
        end
      end
    end
  end
end
