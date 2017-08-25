require 'aruba/cucumber'
require 'nokogiri'

METADATA_XSD = File.expand_path("../../../lib/verify/metadata/generator/xsd/saml-schema-metadata-2.0.xsd", __FILE__)

$LOAD_PATH << File.expand_path("../../../spec/support", __FILE__)
require 'xsd_matcher'

require 'certificate_helper'
World(CertificateHelper)

