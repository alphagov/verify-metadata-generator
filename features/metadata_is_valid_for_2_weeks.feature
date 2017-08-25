Feature: Metadata is valid for two weeks
  In order to ensure that metadata remains consistant,
  As a yak,
  I want the produced to be valid for two weeks only

  Scenario: metadata is produced
    Given I know the time
    And there is sufficient input data for local
    When the metadata is generated for local
    Then the metadata will expire in two weeks
