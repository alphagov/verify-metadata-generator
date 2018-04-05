require 'verify/metadata/generator/hub_metadata_provider'
require File.expand_path('../../../../spec_helper', __FILE__)
module Verify
  module Metadata
    module Generator
      describe HubMetadataProvider do
        before(:each) do
          create_dir(environment)
        end
        let(:environment){"test_env"}

        it "receives an environment and returns the hubmetadata" do
          yaml_loader = double(:yaml_loader)
          hub_hash = double(:hub_hash)
          loaded_yamls = [LoadedYaml.new(hub_hash, 'hub.yml')]
          expect(yaml_loader).to receive(:load).with(File.join(environment, "hub.yml")).and_return(loaded_yamls)
          schema_validator = double(:schema_validator)
          expect(schema_validator).to receive(:validate!).with(loaded_yamls)
          converter = double(:converter)
          idp_saml = double(:idp_saml)
          expect(converter).to receive(:generate).with(hub_hash, nil).and_return(idp_saml)
          expect(HubMetadataProvider.new(yaml_loader, schema_validator, converter).provide(environment, nil)).to eq(idp_saml)
        end

        it "throws an error if there is not a yaml file" do
          yaml_loader = double(:yaml_loader)
          expect(yaml_loader).to receive(:load).with(File.join(environment, "hub.yml")).and_return([])
          schema_validator = double(:schema_validator)
          converter = double(:converter)
          expect{HubMetadataProvider.new(yaml_loader, schema_validator, converter).provide(environment, nil)}.to raise_error HubMetadataNotFoundError
        end
      end

      describe HubEntityDescriptorGenerator do
        it "stores values correctly" do
          id = 'stub-idp-one'
          entity_id = 'http://stub_idp.acme.org/stub-idp-one/SSO/POST'
          source_data = {
            'entity_id' => 'http://stub_idp.acme.org/stub-idp-one/SSO/POST',
            'organization' => {
            'name' => 'stub-idp-one',
            'display_name' => 'Stub IDP One',
            'url' => 'http://stub-idp-one.test',
          },
          'id' => 'stub-idp-one',
          'enabled' => true,
          'signing_certificates' => [{'x509' => encoded_certificate, 'name' => 'signing_1' }],
          'encryption_certificate' => {'x509' => encoded_certificate, 'name' => 'encryption_1' },
          'assertion_consumer_service_uri' => 'http://foo.com',
          }
          store = double(:store)
          signing_certificates = [Certificate.new('signing_1', 'signing', encoded_certificate, store)]
          encryption_certificate = Certificate.new('encryption_1', 'encryption', encoded_certificate, store)
          role_descriptor = SpDescriptor.new(signing_certificates, encryption_certificate, 'http://foo.com')
          expected_descriptor = EntityDescriptor.new(id, entity_id, role_descriptor, Organization.new('stub-idp-one', 'Stub IDP One', 'http://stub-idp-one.test'))
          store_provider = double(:store_provider)
          expect(store_provider).to receive(:provide).and_return store
          expect(HubEntityDescriptorGenerator.new(store_provider).generate(source_data, nil)).to eq expected_descriptor end
      end
    end
  end
end
