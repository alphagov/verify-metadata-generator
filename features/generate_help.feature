Feature: generate help
  In order to understand how the metadata generator works
  As a yak
  I want it to describe its options with the -h flag

  Scenario: -h is used
    When I successfully run `generate_metadata -h`
    Then the stdout should contain exactly:
      """
      Usage: generate_metadata [options]
          -r, --connector                  the environment is for eIDAS connector
          -p, --proxy-node                 the environment is for eIDAS proxy node
          -e, --env=ENVIRONMENT            environment to generate metadata for
          -cDIRECTORY                      the input directory to use
          -w                               write the metadata to a file at ENVIRONMENT/metadata.xml
          -oDIRECTORY                      when writing metadata use this prefix directory
              --valid-until=DAYS           number of days from today the metadata should be valid for (defaults to 14)
              --idpCA CAFILE               a CA file for verifying IDP's certificates
              --hubCA CAFILE               a CA file for verifying the Hub's certificates
          -h, --help                       prints this text

      """

