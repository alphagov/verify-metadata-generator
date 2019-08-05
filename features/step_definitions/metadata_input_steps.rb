require 'base64'
Given(/^there is a environment called (\w+-?\w+)$/) do |env|
  create_environment(env)
end

Given(/^(\w+-?\w+) has a source file describing the hub$/) do |env|
  write_file_describing_hub(env)
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