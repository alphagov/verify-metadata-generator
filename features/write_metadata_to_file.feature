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

  Scenario: display metadata without IDP when an environment contains a suffix value connector
    Given there is a environment called local-connector
    And local-connector has a source file describing the hub with its entity id http://my.entity.id.url
    And local-connector has no idps defined
    When I successfully run `generate_metadata --connector -e local-connector --hubCA hub_ca.pem`
    Then there will be an EntityDescriptor root element
    #And the EntityDescriptor will be signed by a Hub Metadata Key
    And the EntityDescriptor will have an entityID matching the url http://my.entity.id.url where the metadata will be hosted
    And the SSODescriptor will contain the Hub's signing and encryption certificates
