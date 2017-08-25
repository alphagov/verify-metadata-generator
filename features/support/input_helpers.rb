require 'erb'
def create_environment(environment)
  create_dir(environment)
end

def write_file_describing_hub(environment, hub_values = {})
  @signing_one_certificate = hub_values.fetch("signing_one_certificate") { hub_values.fetch("certificate"){
    signed_hub_certificate
  }}
  @signing_two_certificate = hub_values.fetch("signing_two_certificate") { hub_values.fetch("certificate"){
    signed_hub_certificate
  }}
  @encryption_certificate = hub_values.fetch("encryption_certificate") { hub_values.fetch("certificate"){
    signed_hub_certificate
  }}
  hub_entity_id = hub_values[:hub_entity_id] || 'hub_entity_id'
  yml_erb = <<-yml
id: HUB_ID
entity_id: <%= hub_entity_id %>
signing_certificates:
  - x509: |
<% @signing_one_certificate.split("\n").each do |line| -%>
          <%= line %>
<% end -%>
    name: signing_one
  - x509: |
<% @signing_two_certificate.split("\n").each do |line| -%>
          <%= line %>
<% end -%>
    name: signing_two
encryption_certificate:
  x509: |
<% @encryption_certificate.split("\n").each do |line| -%>
        <%= line %>
<% end -%>
  name: encryption
assertion_consumer_service_uri: http://foo.com
organization:
  name: GOV.UK
  display_name: GOV.UK
  url: https://www.gov.uk
  yml
  hub_description = ERB.new(yml_erb, nil, '<->').result binding
  write_hub_file(environment, hub_description)   
end

def write_hub_file(environment, hub_description)
  create_dir(File.join(environment))
  write_file(File.join(environment, "hub.yml"), hub_description)   
end

def write_file_describing_idp(environment, idps)
  idps.each do |idp| 
    id = idp.fetch("id")
    entity_id = idp.fetch("entity_id")
    sso_uri = idp.fetch('sso_uri', "http://foo.com")
    signing_certificate = idp.fetch("signing_certificate"){signed_idp_certificate}
    yml_erb = <<-yml
id: <%= id %>
entity_id: <%= entity_id %>
signing_certificates:
  - x509: |
<% signing_certificate.split("\n").each do |line| -%>
          <%= line %>
<% end -%>
    name: signing_one
sso_uri: <%= sso_uri %>
organization:
  name: IDP
  display_name: IDP
  url: https://www.some-uri.com
enabled: true
    yml
    name = idp.fetch("filename", id)
    idp_description = ERB.new(yml_erb, nil, '<->').result binding
    write_idp_file(environment, name, idp_description)
  end
end

def write_idp_file(environment, idp_name, idp_description)
  create_dir(File.join(environment, "idps"))
  write_file(File.join(environment, "idps", "#{idp_name}.yml"), idp_description)   
end

def write_default_idps(environment)
  idp_defaults = [{"entity_id" => "idp-entity-one.com", "id" => "idp-one"}, {"entity_id" => "idp-entity-two.com", "id" => "idp-two"}]
  write_file_describing_idp(environment, idp_defaults)
end

def create_input(environment)
  create_environment(environment)
  write_file_describing_hub(environment)
  write_default_idps(environment)
end

def signed_hub_certificate
  Base64.encode64(hub_pki.sign(generate_cert).to_der)
end

def signed_idp_certificate
  Base64.encode64(idp_pki.sign(generate_cert).to_der)
end

def unsigned_certificate
  generate_cert
end
