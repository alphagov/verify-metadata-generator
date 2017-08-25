Feature: Validates Hub Input
  In order to produce metadata that is valid
  As a yak,
  I want the metadata generator to peform validation of hub input

  Background:
    Given there is an IDP CA file called idp_ca.pem
    Given there is a Hub CA file called hub_ca.pem

  Scenario: When the input file is not found
    Given there is a environment called local 
    When I run `generate_metadata -e local`
    Then the exit status should be 1
    And the stderr should contain "HubMetadataNotFoundError"

  Scenario: When the input file is empty
    Given there is a environment called local 
    And local has a source file describing the hub:
    """
    ---
    """
    When I run `generate_metadata -e local`
    Then the exit status should be 1
    And the stderr should contain
    """
    file with name 'hub.yml' had the following errors:
    The property '#/' of type null did not match the following type: object in schema 63bfb93a-fc9f-5141-a13f-0f81f5fdfeef
    """

  Scenario: When the input file is missing keys
    Given there is a environment called local 
    And local has a source file describing the hub:
    """
    ---
    foo: baz
    """
    And local has some idps defined
    When I run `generate_metadata -e local`
    Then the exit status should be 1
    And the stderr should contain
    """
    file with name 'hub.yml' had the following errors:
    The property '#/' did not contain a required property of 'id' in schema 63bfb93a-fc9f-5141-a13f-0f81f5fdfeef
    The property '#/' did not contain a required property of 'entity_id' in schema 63bfb93a-fc9f-5141-a13f-0f81f5fdfeef
    The property '#/' did not contain a required property of 'assertion_consumer_service_uri' in schema 63bfb93a-fc9f-5141-a13f-0f81f5fdfeef
    The property '#/' did not contain a required property of 'organization' in schema 63bfb93a-fc9f-5141-a13f-0f81f5fdfeef
    The property '#/' did not contain a required property of 'signing_certificates' in schema 63bfb93a-fc9f-5141-a13f-0f81f5fdfeef
    The property '#/' did not contain a required property of 'encryption_certificate' in schema 63bfb93a-fc9f-5141-a13f-0f81f5fdfeef
    """

  Scenario: When the IDP has a bad certificate
    Given there is a environment called local 
    And local has a source file describing the hub with a badly signed certificate
    And local has some idps defined
    When I run `generate_metadata -e local --idpCA idp_ca.pem --hubCA hub_ca.pem`
    Then the exit status should be 1
    And the stderr should contain
    """
    HUB_ID had the following errors:
      * role_descriptor encryption_certificate x509 could not establish trust anchor
      * role_descriptor signing_certificate x509 could not establish trust anchor
      * role_descriptor signing_certificate x509 could not establish trust anchor
    """
