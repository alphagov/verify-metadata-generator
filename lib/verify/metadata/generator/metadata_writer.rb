require 'fileutils'
module Verify
  module Metadata
    module Generator
      class MetadataWriter
        def initialize(options)
          @write_file = options.write_file
          @output_directory = options.output_directory || '.'
        end

        def write(content, environment = nil)
          if @write_file
            file_directory = File.join(@output_directory, environment)
            FileUtils.mkdir_p(file_directory)
            File.open(File.join(file_directory, "metadata.xml"), 'w') do |io|
              io.puts(content)
            end
          else
            puts content
          end
        end
      end
    end
  end
end
