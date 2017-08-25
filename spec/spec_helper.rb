require 'aruba/api'
require 'aruba/reporting'
require 'support/certificate_helper'
require 'support/xsd_matcher'

RSpec.configure do |config|
  config.include Aruba::Api
  config.include CertificateHelper

  config.before(:each) do
    restore_env
    clean_current_dir
  end
end

METADATA_XSD = File.expand_path("../../lib/verify/metadata/generator/xsd/saml-schema-metadata-2.0.xsd", __FILE__)
PO_XSD = File.expand_path("../../spec/support/files/po.xsd", __FILE__)
PO_XML = File.expand_path("../../spec/support/files/po.xml", __FILE__)
