Feature: metadata describes hub as an SP

 As a yak,
 I want the metadata to be automatically generated
 So that I do not have to manually create the metadata file

  Scenario: when read from a source
    Given there is a environment called local 
    And local has a source file describing the hub
    And local has some idps defined
    When the metadata is generated for local
    Then the metadata will contain a descriptor for the hub
    Then the metadata will conform to the xsd

