Feature: be able to specify the valid until length

 As a yak,
 I want to be able to generate metadata with a particular valid until date
 So members of the federation maintain an up-to-date view of the federation

  Background:
    Given there is an IDP CA file called idp_ca.pem
    Given there is a Hub CA file called hub_ca.pem

  Scenario: metadata is produced valid for one week
    Given I know the time
    And there is sufficient input data for local
    When I run `generate_metadata -e local --idpCA idp_ca.pem --hubCA hub_ca.pem --valid-until=7`
    Then the metadata will expire in 7 days

  Scenario: attempt to produce valid metadata for a year
    Given I know the time
    And there is sufficient input data for local
    When I run `generate_metadata -e local --idpCA idp_ca.pem --hubCA hub_ca.pem --valid-until=365`
    Then the exit status should be 0
    And the metadata will expire in 365 days
