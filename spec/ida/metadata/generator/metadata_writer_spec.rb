require 'verify/metadata/generator/metadata_writer'

module Verify
  module Metadata
    module Generator
      describe MetadataWriter do
        context "when option write_file is false" do
          it "will print to stdout" do
            options = double(:options, :write_file => false, :output_directory => nil)
            expect{MetadataWriter.new(options).write("bob")}.to output("bob\n").to_stdout
          end
        end
        context "when option write_file is true" do
          it "will write to a file in a directory named after the environment" do
            options = double(:options, :write_file => true, :output_directory => nil)
            Dir.chdir(current_dir) do
              MetadataWriter.new(options).write("bob", "foo")
            end
            check_file_content("foo/metadata.xml", "bob\n", true)
          end
          context "when the output directory option is set to baz" do
            it "will write to a file in a directory named after the environment within baz" do
            options = double(:options, :write_file => true, :output_directory => "baz")
            Dir.chdir(current_dir) do
              MetadataWriter.new(options).write("bob", "foo")
            end
            check_file_content("baz/foo/metadata.xml", "bob\n", true)
            end
          end
        end
      end
    end
  end
end
