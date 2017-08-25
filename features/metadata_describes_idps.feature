Feature: Metadata Describes IDPs

  Scenario: Describe An IDP called bob
    Given there is a environment called local 
    And local has a source file describing the hub
    And local has a source file describing an IDP with values:
      | entity_id     | id     | sso_uri            |
      | bob_entity_id | bob_id | http://sso-uri.com |
    When the metadata is generated for local
    Then the metadata will contain a descriptor
      | entityID      | ID     |
      | bob_entity_id | bob_id |
    And bob_entity_id will have a IDPSSODescriptor
      | sso_uri            | name |
      | http://sso-uri.com | signing_1 |
    And the metadata will conform to the xsd
