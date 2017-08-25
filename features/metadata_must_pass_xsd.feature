Feature: Metadata must pass XSD

  Background:
    Given there is an IDP CA file called idp_ca.pem
    Given there is a Hub CA file called hub_ca.pem

  Scenario: Duplicate entity IDs fail XSD
    Given there is a environment called local 
    And local has a source file describing the hub
    And local has a source file describing an IDP with values:
      | entity_id     | id     | sso_uri            | filename |
      | bob_entity_id | bob_id | http://sso-uri.com | bob      |
    And local has a source file describing an IDP with values:
      | entity_id     | id     | sso_uri            | filename  |
      | bob_entity_id | bob_id | http://sso-uri.com | other_bob |
    When I run `generate_metadata -e local --idpCA idp_ca.pem --hubCA hub_ca.pem`
    Then the exit status should be 1
    And the stderr should contain
    """
    [#<Nokogiri::XML::SyntaxError: 131:0: ERROR: Element '{urn:oasis:names:tc:SAML:2.0:metadata}EntityDescriptor', attribute 'ID': 'bob_id' is not a valid value of the atomic type 'xs:ID'.>]
    """
