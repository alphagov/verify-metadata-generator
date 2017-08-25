Feature: generate for many environments
  In order to generate metadata for many environments easily 
  As a yak,
  I want to the tool to be able to generate for many environments in a single run

  Background:
    Given there is an IDP CA file called idp_ca.pem
    Given there is a Hub CA file called hub_ca.pem

  Scenario: produce metadata for local and joint
    Given there is a environment called local 
    And local has a source file describing the hub
    And there is a environment called joint
    And joint has a source file describing the hub
    And local has some idps defined
    And joint has some idps defined
    When I successfully run `generate_metadata -e local -e joint -w --idpCA idp_ca.pem --hubCA hub_ca.pem`
    Then the metadata for local will be written to a file
    Then the metadata for joint will be written to a file
