Then(/^the metadata for (\w+-?\w+)(?: in (\w+-?\w+))? will be written to a file$/) do |env, prefix|
  prefix ||= "."
  metadata_file = File.join(prefix, env, "metadata.xml")
  check_file_presence([metadata_file], true)
  metadata_content = File.read(File.join(current_dir, metadata_file))
  Dir.chdir(File.dirname(METADATA_XSD)) do
    xsd = Nokogiri::XML::Schema(File.read("saml-schema-metadata-2.0.xsd"))
    doc = Nokogiri::XML::Document.parse(metadata_content)    
    expect(xsd.validate(doc)).to be_empty
  end
end
