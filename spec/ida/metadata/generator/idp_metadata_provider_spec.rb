require 'verify/metadata/generator/idp_metadata_provider'
require File.expand_path('../../../../spec_helper', __FILE__)
module Verify
  module Metadata
    module Generator
      describe IdpMetadataProvider do
        let(:environment){"test_env"}
        let(:fake_yaml_loader){double(:yaml_loader)}
        let(:fake_schema_validator){double(:yaml_schema_validator)}
        let(:fake_entity_descriptor_converter){double(:fake_entity_descriptor_converter)}
        it "throws an error if there are no yaml files" do
          expect(fake_yaml_loader).to receive(:load).with("test_env/idps/*.yml").and_return([])
          expect{IdpMetadataProvider.new(fake_yaml_loader, fake_schema_validator, fake_entity_descriptor_converter).provide(environment)}.to raise_error IdpMetadataNotFoundError
        end

        context "when idps aren't enabled" do
          it "excludes content from IDPs that aren't enabled" do
            an_idp_hash = double(:idp_hash)
            converted_idp = double(:converted_idp)
            an_other_idp_hash = double(:idp_hash)
            expect(fake_yaml_loader).to receive(:load).with("test_env/idps/*.yml").and_return([LoadedYaml.new(an_idp_hash, double(:name)), LoadedYaml.new(an_other_idp_hash, double(:name))])
            expect(an_idp_hash).to receive(:[]).with("enabled").and_return(true)
            expect(an_other_idp_hash).to receive(:[]).with("enabled").and_return(false)
            expect(fake_entity_descriptor_converter).to receive(:generate).with(an_idp_hash, nil).and_return(converted_idp)
            expect(fake_entity_descriptor_converter).to_not receive(:generate).with(an_other_idp_hash, nil)
            expect(fake_schema_validator).to receive(:validate!)
            metadata = IdpMetadataProvider.new(fake_yaml_loader, fake_schema_validator, fake_entity_descriptor_converter).provide(environment)
            expect(metadata).to eq [converted_idp]
          end

          it "raises an error when no IDPs are enabled" do
            an_idp_hash = double(:idp_hash)
            expect(fake_yaml_loader).to receive(:load).with("test_env/idps/*.yml").and_return([LoadedYaml.new(an_idp_hash, double(:name))])
            expect(an_idp_hash).to receive(:[]).with("enabled").and_return(false)
            expect(fake_entity_descriptor_converter).to_not receive(:generate)
            expect(fake_schema_validator).to receive(:validate!)
            expected_message = "No enabled IDPs were found for #{environment}"
            expect{
              IdpMetadataProvider.new(fake_yaml_loader, fake_schema_validator, fake_entity_descriptor_converter).provide(environment) 
            }.to raise_error NoEnabledIdpMetadataError, expected_message
          end
        end

        it "receives an environment and returns metadata for IDPs" do
          an_idp_hash = double(:idp_hash)
          converted_idp = double(:converted_idp)
          expect(fake_yaml_loader).to receive(:load).with("test_env/idps/*.yml").and_return([LoadedYaml.new(an_idp_hash, double(:name))])
          expect(an_idp_hash).to receive(:[]).with("enabled").and_return(true)
          expect(fake_entity_descriptor_converter).to receive(:generate).with(an_idp_hash, nil).and_return(converted_idp)
          expect(fake_schema_validator).to receive(:validate!)
          metadata = IdpMetadataProvider.new(fake_yaml_loader, fake_schema_validator, fake_entity_descriptor_converter).provide(environment)
          expect(metadata).to eq [converted_idp]
        end
      end

      class IdpMetadataProvider
        describe IdpSourceToEntityDescriptorConverter do
          it "correctly creates a single entity descriptor from a config file" do
            id = 'experian'
            entity_id = 'http://stub_idp.acme.org/experian/SSO/POST'
            sso_uri = 'https://idp-stub-staging.ida.digital.cabinet-office.gov.uk:443/experian/SAML2/SSO'
            source_data = {
              'entity_id' => 'http://stub_idp.acme.org/experian/SSO/POST',
              'organization' => {
              'name' => 'experian',
              'display_name' => 'Experian',
              'url' => 'http://experian.com',
            },
            'sso_uri' => sso_uri,
            'id' => 'experian',
            'enabled' => true,
            'signing_certificates' => [{'x509' => encoded_certificate }]
            }
            store = double(:store)
            signing_certificates = [Certificate.new('signing_1', 'signing', encoded_certificate, store)]
            idp_descriptor = IdpDescriptor.new(signing_certificates, sso_uri)
            expected_descriptor = EntityDescriptor.new(id, entity_id, idp_descriptor, Organization.new('experian', 'Experian', 'http://experian.com'))
            fake_store_loader = double(:fake_store_loader)
            expect(fake_store_loader).to receive(:provide).and_return(store)
            expect(IdpSourceToEntityDescriptorConverter.new(fake_store_loader).generate(source_data)).to eq expected_descriptor
          end

          it "correctly creates multiple entity descriptors from a config file" do
            id = 'experian'
            entity_id = 'http://stub_idp.acme.org/experian/SSO/POST'
            sso_uri = 'https://idp-stub-staging.ida.digital.cabinet-office.gov.uk:443/experian/SAML2/SSO'
            source_data = {
                'entity_id' => 'http://stub_idp.acme.org/experian/SSO/POST',
                'organization' => {
                    'name' => 'experian',
                    'display_name' => 'Experian',
                    'url' => 'http://experian.com',
                },
                'sso_uri' => sso_uri,
                'id' => 'experian',
                'enabled' => true,
                'signing_certificates' => [{'x509' => encoded_certificate }, {'x509' => encoded_certificate_2 }]
            }
            store = double(:store)
            signing_certificates = [Certificate.new('signing_1', 'signing', encoded_certificate, store), Certificate.new('signing_2', 'signing', encoded_certificate_2, store)]
            idp_descriptor = IdpDescriptor.new(signing_certificates, sso_uri)
            expected_descriptor = EntityDescriptor.new(id, entity_id, idp_descriptor, Organization.new('experian', 'Experian', 'http://experian.com'))
            fake_store_loader = double(:fake_store_loader)
            expect(fake_store_loader).to receive(:provide).and_return(store)
            expect(IdpSourceToEntityDescriptorConverter.new(fake_store_loader).generate(source_data)).to eq expected_descriptor
          end
        end


      end

    end
  end
end
