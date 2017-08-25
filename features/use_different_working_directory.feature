Feature: be able to specify the working directory

 As a yak,
 I want to be able to specify the working directory
 So that I do not have to run the tool from it each time

  Background:
    Given there is an IDP CA file called idp_ca.pem
    Given there is a Hub CA file called hub_ca.pem

  Scenario: when read from a source
    Given there a directory called working
    And there is an environment called local in working
    And local in working has a source file describing the hub
    And local in working has some idps defined
    When I successfully run `generate_metadata -c working -e local --idpCA ../idp_ca.pem --hubCA ../hub_ca.pem`
    Then the metadata will conform to the xsd
