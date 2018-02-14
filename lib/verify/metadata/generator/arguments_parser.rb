require 'optparse'
module Verify
  module Metadata
    module Generator
      class ArgumentsParser
        Options = Struct.new(:environments, :input_directory, :write_file, :is_connector, :is_proxy_node, :output_directory, :valid_until, :idp_ca_files, :hub_ca_files) do
          def validate!
            raise "environment must be set!" if environments.empty?
          end
        end

        def parse(argv)
          options = Options.new
          options.write_file = false
          options.is_connector = false
          options.is_proxy_node = false
          options.output_directory = File.absolute_path(Dir.pwd)
          options.environments = []
          options.idp_ca_files = []
          options.hub_ca_files = []
          options.valid_until = 14 # By default metadata is valid for 2 weeks from the date it was generated
          opt_parser = OptionParser.new do |opts|
            opts.banner = "Usage: generate_metadata [options]"

            opts.on("-r", "--connector", "the environment is for eIDAS connector") do
              options.is_connector = true
            end

            opts.on("-p", "--proxy-node", "the environment is for eIDAS proxy node") do
              options.is_proxy_node = true
            end

            opts.on("-eENVIRONMENT", "--env=ENVIRONMENT", String, "environment to generate metadata for") do |env|
              options.environments << env
            end

            opts.on("-cDIRECTORY", "the input directory to use") do |input_directory|
              options.input_directory = input_directory
            end

            opts.on("-w", "write the metadata to a file at ENVIRONMENT/metadata.xml") do
              options.write_file = true
            end

            opts.on("-oDIRECTORY", String, "when writing metadata use this prefix directory") do |o|
              options.output_directory = File.absolute_path(o)
            end

            opts.on("--valid-until=DAYS", Integer, "number of days from today the metadata should be valid for (defaults to 14)") do |valid_until|
              options.valid_until = valid_until
            end

            opts.on("--idpCA CAFILE", String, "a CA file for verifying IDP's certificates") do |file|
              options.idp_ca_files << file
            end

            opts.on("--hubCA CAFILE", String, "a CA file for verifying the Hub's certificates") do |file|
              options.hub_ca_files << file
            end

            opts.on("-h", "--help", "prints this text") do
              puts opts
              exit
            end
          end
          opt_parser.parse!(argv)
          options.validate!
          options
        end
      end
    end
  end
end
