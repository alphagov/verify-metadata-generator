Feature: write metadata to file

  In order to have control over how I produce metadata,
  As a yak,
  I want to be able to specify a file to write the metadata.

  Background:
    Given there is an IDP CA file called idp_ca.pem
    Given there is a Hub CA file called hub_ca.pem

  Scenario: write metadata when -w flag given
    Given there is a environment called local 
    And local has a source file describing the hub
    And local has some idps defined
    When I successfully run `generate_metadata -e local --idpCA idp_ca.pem --hubCA hub_ca.pem -w`
    Then the metadata for local will be written to a file

  Scenario: write metadata to prefix output directory when -o flag given
    Given there is a environment called local 
    And local has a source file describing the hub
    And local has some idps defined
    When I successfully run `generate_metadata -e local -w --idpCA idp_ca.pem --hubCA hub_ca.pem -o output`
    Then the metadata for local in output will be written to a file

