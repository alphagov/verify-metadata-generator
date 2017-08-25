require 'base64'
Given(/^there is a environment called (\w+-?\w+)$/) do |env|
  create_environment(env)
end

Given(/^(\w+-?\w+) has a source file describing the hub$/) do |env|
  write_file_describing_hub(env)
end

Given(/^(\w+-?\w+) has a source file describing the hub with its entity id (.+)$/) do |env, entity_id|
  write_file_describing_hub(env, {hub_entity_id: entity_id})
end

When(/^the metadata is generated for (\w+)$/) do |env|
  write_file("idp_ca.pem", idp_pki.root_ca.to_pem)
  write_file("hub_ca.pem", hub_pki.root_ca.to_pem)
  run_simple("generate_metadata -e #{env} --idpCA idp_ca.pem --hubCA hub_ca.pem")
end

Then(/^the metadata will contain a descriptor for the hub$/) do
  doc = Nokogiri::XML::Document.parse(all_output)    
  expect(doc.xpath('//md:EntityDescriptor')[0]['entityID']).to eq("hub_entity_id")
end

Then(/^the metadata will conform to the xsd$/) do
  expect(all_output).to conform_to_schema(METADATA_XSD)
end

Given(/^(\w+) has a source file describing the hub:$/) do |env, hub_description|
  write_hub_file(env, hub_description)
end

Given(/^(\w+) has a source file describing the hub with a badly signed certificate$/) do |env|
  other_pki = CertificateHelper::PKI.new("OTHER TEST CA")
  certificate = Base64.encode64(other_pki.sign(generate_cert).to_der)
  hub = {
    "certificate" => certificate
  }
  write_file_describing_hub(env, hub)
end

Given(/^(\w+) has a source file describing an IDP with values:$/) do |env, table|
  write_file_describing_idp(env, table.hashes)
end

Given(/^(\w+) has a source file describing an IDP with a badly signed certificate$/) do |env|
  other_pki = CertificateHelper::PKI.new("OTHER TEST CA")
  certificate = Base64.encode64(other_pki.sign(generate_cert).to_der)
  idp = {
    "id" => "ID",
    "entity_id" => "entity id",
    "sso_uri" => "SSO URI",
    "signing_certificate" => certificate
  }
  write_file_describing_idp(env, [idp])
end

Given(/^(\w+) has some idps defined$/) do |env|
  write_default_idps(env)
end

And(/^(\w+-?\w+) has no idps defined$/) do |env|

end

Given(/^(\w+) has a source file describing an IDP called (\w+) with content:$/) do |env, idp_name, idp_source|
  write_idp_file(env, idp_name, idp_source)
end

Given(/^there is a Hub CA file called (.+)$/) do |ca|
  write_file(ca, hub_pki.root_ca.to_pem)
end

Given(/^there is an IDP CA file called (.+)$/) do |ca|
  write_file(ca, idp_pki.root_ca.to_pem)
end

Then(/^the metadata will contain a descriptor$/) do |table|
  doc = Nokogiri::XML::Document.parse(all_output)    
  attributes = table.hashes.first
  expect(doc.xpath('//md:EntityDescriptor').select {|element|
    (element['entityID'] == attributes["entityID"]) && (element['ID'] == attributes["ID"])
  }).to_not be_empty
end

Then(/^(\w+) will have a IDPSSODescriptor$/) do |entity_id, table|
  doc = Nokogiri::XML::Document.parse(all_output)
  doc.remove_namespaces!
  attributes = table.hashes.first
  expect(doc.xpath("//EntityDescriptor[@entityID='#{entity_id}']/IDPSSODescriptor/SingleSignOnService")[0]["Location"]).to eql attributes["sso_uri"]
  expect(doc.xpath("//EntityDescriptor[@entityID='#{entity_id}']/IDPSSODescriptor/KeyDescriptor/KeyInfo/KeyName/text()")[0].to_s).to eql attributes["name"]
end

And(/^there will be an EntityDescriptor root element$/) do
  doc = Nokogiri::XML::Document.parse(all_output)
  expect(doc.xpath('/md:EntityDescriptor[@validUntil]').size).to eql(1)
  expect(doc.xpath('/md:EntityDescriptor/@validUntil').to_s).to_not be_empty
end

And(/^the EntityDescriptor will have an entityID matching the url (.+) where the metadata will be hosted$/) do | url |
  doc = Nokogiri::XML::Document.parse(all_output)
  expect(doc.xpath('/md:EntityDescriptor/@entityID').to_s).to eql(url)
end

And(/^the SSODescriptor will contain the Hub's signing and encryption certificates$/) do
  doc = Nokogiri::XML::Document.parse(all_output)
  doc.remove_namespaces!
  expect(doc.xpath("/EntityDescriptor/SPSSODescriptor/KeyDescriptor[@use='encryption']//X509Certificate/text()").to_s).to eql(@encryption_certificate)
  expect(doc.xpath("/EntityDescriptor/SPSSODescriptor/KeyDescriptor[@use='signing' and KeyInfo/KeyName[text() = 'signing_one']]//X509Certificate/text()").to_s).to eql(@signing_one_certificate)
  expect(doc.xpath("/EntityDescriptor/SPSSODescriptor/KeyDescriptor[@use='signing' and KeyInfo/KeyName[text() = 'signing_two']]//X509Certificate/text()").to_s).to eql(@signing_two_certificate)
end