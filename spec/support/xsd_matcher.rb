require 'rspec/expectations'

RSpec::Matchers.define :conform_to_schema do |xsd_file|
  errors = []

  match do |actual|
    errors = validate_xml(actual, xsd_file)
    errors.empty?
  end

  description do |actual|
    "conform to xsd schema #{xsd_file}"
  end

  failure_message do |actual|
    [
      "expected #{actual} to conform to schema:",
      errors
    ].flatten.join("\n")
  end

  def validate_xml(xml, xsd)
    Dir.chdir(File.dirname(xsd)) do
      schema = Nokogiri::XML::Schema(File.open(xsd))
      document = Nokogiri::XML::Document.parse(xml.to_s)
      schema.validate(document)
    end
  end
end
