Feature: Validates Idp Input
  In order to produce metadata that is valid
  As a yak,
  I want the metadata generator to peform validation of metadata input

  Background:
    Given there is an IDP CA file called idp_ca.pem
    Given there is a Hub CA file called idp_ca.pem

  Scenario: When the input file is invalid
    Given there is a environment called local 
    And local has a source file describing the hub
    And local has a source file describing an IDP called bob with content:
    """
    ---
    """
    When I run `generate_metadata -e local`
    Then the exit status should be 1
    And the stderr should contain
    """
    file with name 'bob.yml' had the following errors:
    The property '#/' of type null did not match the following type: object in schema f8131360-c16e-533f-9f75-490edbcb5c7d
    """

  Scenario: When the IDP has a bad certificate
    Given there is a environment called local 
    And local has a source file describing the hub
    And local has a source file describing an IDP with a badly signed certificate
    When I run `generate_metadata -e local --idpCA idp_ca.pem`
    Then the exit status should be 1
    And the stderr should contain
    """
    ID had the following errors:
      * role_descriptor signing_certificate x509 could not establish trust anchor
    """
