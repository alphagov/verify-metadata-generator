require 'json-schema'
require 'verify/metadata/generator/schema'
module Verify
  module Metadata
    module Generator
      describe Schema do
        context "::HUB is a schema" do
          context "requires root properties" do
            subject {
              hub = {}
              JSON::Validator::fully_validate(Schema::HUB, hub)
            }
            it{ is_expected.to be_any {|error| error =~ %r{The property '#/' did not contain a required property of 'entity_id'}}}
            it{ is_expected.to be_any {|error| error =~ %r{The property '#/' did not contain a required property of 'id'}}}
            it{ is_expected.to be_any {|error| error =~ %r{The property '#/' did not contain a required property of 'signing_certificates'}}}
            it{ is_expected.to be_any {|error| error =~ %r{The property '#/' did not contain a required property of 'encryption_certificate'}}}
            it{ is_expected.to be_any {|error| error =~ %r{The property '#/' did not contain a required property of 'assertion_consumer_service_uri'}}}
            it{ is_expected.to be_any {|error| error =~ %r{The property '#/' did not contain a required property of 'organization'}}}
          end

          it "must have a id repesented with a string" do
            hub = {"id" => 2}
            errors = JSON::Validator::fully_validate(Schema::HUB, hub)
            expect(errors).to be_any {|error| error =~ %r{The property '#/id' of type integer did not match the following type: string}}
          end

          it "must have a entity_id repesented with a uri" do
            hub = {"entity_id" => 2}
            errors = JSON::Validator::fully_validate(Schema::HUB, hub)
            expect(errors).to be_any {|error| error =~ %r{The property '#/entity_id' of type integer did not match the following type: string}}
          end

          it "must have a assertion_consumer_service_uri repesented with a uri" do
            hub = {"assertion_consumer_service_uri" => 2}
            errors = JSON::Validator::fully_validate(Schema::HUB, hub)
            expect(errors).to be_any {|error| error =~ %r{The property '#/assertion_consumer_service_uri' of type integer did not match the following type: string}}
          end

          context "organization" do
            subject {
              hub = {"organization" => {}}
              JSON::Validator::fully_validate(Schema::HUB, hub)
            }
            it{ is_expected.to be_any {|error| error =~ %r{The property '#/organization' did not contain a required property of 'name'}}}
            it{ is_expected.to be_any {|error| error =~ %r{The property '#/organization' did not contain a required property of 'display_name'}}}
            it{ is_expected.to be_any {|error| error =~ %r{The property '#/organization' did not contain a required property of 'url'}}}
          end

          context "signing_certificates" do
            it "must have atleast one certificate" do
              hub = {"signing_certificates" => []}
              errors = JSON::Validator::fully_validate(Schema::HUB, hub)
              expect(errors).to be_any {|error| error =~ %r{The property '#/signing_certificates' did not contain a minimum number of items 1}}
            end

            it "must have a certificate with x509 data" do
              hub = {"signing_certificates" => [{}]}
              errors = JSON::Validator::fully_validate(Schema::HUB, hub)
              expect(errors).to be_any {|error| error =~ %r{The property '#/signing_certificates/0' did not contain a required property of 'x509'}}
            end

            it "must have a certificate with x509 data repesented with a string" do
              hub = {"signing_certificates" => [{"x509" => 2}]}
              errors = JSON::Validator::fully_validate(Schema::HUB, hub)
              expect(errors).to be_any {|error| error =~ %r{The property '#/signing_certificates/0/x509' of type integer did not match the following type: string}}
            end

            it "must have a certificate with a name" do
              hub = {"signing_certificates" => [{}]}
              errors = JSON::Validator::fully_validate(Schema::HUB, hub)
              expect(errors).to be_any {|error| error =~ %r{The property '#/signing_certificates/0' did not contain a required property of 'name'}}
            end

            it "must have a certificate with a name represented as a string" do
              hub = {"signing_certificates" => [{"name" => 2}]}
              errors = JSON::Validator::fully_validate(Schema::HUB, hub)
              expect(errors).to be_any {|error| error =~ %r{The property '#/signing_certificates/0/name' of type integer did not match the following type: string}}
            end
          end

          context "encryption_certificate" do
            it "must have a certificate with x509 data" do
              hub = {"encryption_certificate" => {}}
              errors = JSON::Validator::fully_validate(Schema::HUB, hub)
              expect(errors).to be_any {|error| error =~ %r{The property '#/encryption_certificate' did not contain a required property of 'x509'}}
            end

            it "must have a certificate with x509 data repesented with a string" do
              hub = {"encryption_certificate" => {"x509" => 2}}
              errors = JSON::Validator::fully_validate(Schema::HUB, hub)
              expect(errors).to be_any {|error| error =~ %r{The property '#/encryption_certificate/x509' of type integer did not match the following type: string}}
            end

            it "must have a certificate with a name" do
              hub = {"encryption_certificate" => {}}
              errors = JSON::Validator::fully_validate(Schema::HUB, hub)
              expect(errors).to be_any {|error| error =~ %r{The property '#/encryption_certificate' did not contain a required property of 'name'}}
            end

            it "must have a certificate with a name represented as a string" do
              hub = {"encryption_certificate" => {"name" => 2}}
              errors = JSON::Validator::fully_validate(Schema::HUB, hub)
              expect(errors).to be_any {|error| error =~ %r{The property '#/encryption_certificate/name' of type integer did not match the following type: string}}
            end
          end
        end
        context "::IDP is a schema" do
          context "requires root properties" do
            subject {
              idp = {}
              JSON::Validator::fully_validate(Schema::IDP, idp)
            }
            it{ is_expected.to be_any {|error| error =~ %r{The property '#/' did not contain a required property of 'entity_id'}}}
            it{ is_expected.to be_any {|error| error =~ %r{The property '#/' did not contain a required property of 'id'}}}
            it{ is_expected.to be_any {|error| error =~ %r{The property '#/' did not contain a required property of 'signing_certificates'}}}
            it{ is_expected.to be_any {|error| error =~ %r{The property '#/' did not contain a required property of 'sso_uri'}}}
            it{ is_expected.to be_any {|error| error =~ %r{The property '#/' did not contain a required property of 'organization'}}}
            it{ is_expected.to be_any {|error| error =~ %r{The property '#/' did not contain a required property of 'enabled'}}}
          end

          it "must have a id repesented with a string" do
            idp = {"id" => 2}
            errors = JSON::Validator::fully_validate(Schema::IDP, idp)
            expect(errors).to be_any {|error| error =~ %r{The property '#/id' of type integer did not match the following type: string}}
          end

          it "must have a entity_id repesented with a uri" do
            idp = {"entity_id" => 2}
            errors = JSON::Validator::fully_validate(Schema::IDP, idp)
            expect(errors).to be_any {|error| error =~ %r{The property '#/entity_id' of type integer did not match the following type: string}}
          end

          it "must have a sso_uri repesented with a uri" do
            idp = {"sso_uri" => 2}
            errors = JSON::Validator::fully_validate(Schema::IDP, idp)
            expect(errors).to be_any {|error| error =~ %r{The property '#/sso_uri' of type integer did not match the following type: string}}
          end

          it "must have a enabled repesented with a boolean" do
            idp = {"enabled" => 3}
            errors = JSON::Validator::fully_validate(Schema::IDP, idp)
            expect(errors).to be_any {|error| error =~ %r{The property '#/enabled' of type integer did not match the following type: boolean}}
          end

          context "organization" do
            subject {
              idp = {"organization" => {}}
              JSON::Validator::fully_validate(Schema::IDP, idp)
            }
            it{ is_expected.to be_any {|error| error =~ %r{The property '#/organization' did not contain a required property of 'name'}}}
            it{ is_expected.to be_any {|error| error =~ %r{The property '#/organization' did not contain a required property of 'display_name'}}}
            it{ is_expected.to be_any {|error| error =~ %r{The property '#/organization' did not contain a required property of 'url'}}}
          end

          context "signing_certificates" do
            it "must have atleast one certificate" do
              idp = {"signing_certificates" => []}
              errors = JSON::Validator::fully_validate(Schema::IDP, idp)
              expect(errors).to be_any {|error| error =~ %r{The property '#/signing_certificates' did not contain a minimum number of items 1}}
            end

            it "must have a certificate with x509 data" do
              idp = {"signing_certificates" => [{}]}
              errors = JSON::Validator::fully_validate(Schema::IDP, idp)
              expect(errors).to be_any {|error| error =~ %r{The property '#/signing_certificates/0' did not contain a required property of 'x509'}}
            end

            it "must have a certificate with x509 data repesented with a string" do
              idp = {"signing_certificates" => [{"x509" => 2}]}
              errors = JSON::Validator::fully_validate(Schema::IDP, idp)
              expect(errors).to be_any {|error| error =~ %r{The property '#/signing_certificates/0/x509' of type integer did not match the following type: string}}
            end
          end
        end
      end
    end
  end
end
