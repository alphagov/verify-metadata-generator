# Verify Metadata Generator

This tool produces unsigned SAML metadata that can be used to describe the entities within the GOV.UK Verify federation. It is intended to be used as part of the larger Verify metadata pipeline.

## Installation

**Note:** The tool is not currently hosted in any private or public gem repositories.

Add this line to your application's Gemfile:

```ruby
gem 'verify-metadata-generator', git: 'https://github.com/alphagov/verify-metadata-generator.git'
```

And then execute:

    $ bundle

Or clone and build it yourself:
```
    $ git clone https://github.com/alphagov/verify-metadata-generator.git
    $ cd verify-metadata-generator
    $ bundle
    $ bundle exec rake install
```
## Features

Cucumber has been used to document the features of this tool; they may be found within [/features](features).

Key aspects of the tool are:
* Describing the Hub as an SP
* Ability to generate metadata for multiple environments
* Validation of entity details (currently only implemented for IDPs)
* Describing IDPs as IDPs
* Describing RPs as SPs (to be implemented)
* Describing MSAs as AAs (to be implemented)

## Usage

The tool is expected to be run using `generate_metadata` via the command-line. The behaviour of the tool can be modified through the following flags:
* `-e ENV` the environment to generate metadata for (multiple flags may be given);
* `-c INPUT` the input directory to use (default: `.`);
* `-w` whether to write the metadata to a file (default: no) (writes to `OUTPUT/ENV/metadata.xml`);
* `-o OUTPUT` the parent output directory for metadata if `-w` (default: `.`).

### Input Sources
The tool currently expects input in the following layout:

```
    INPUT/
        ENV/
            hub.yml
            idps/
                idp-name.yml
```

An example input directory layout with an environment named `example_environment` is viewable with [/examples](examples)

## Responsible disclosure

If you think you have discovered a security issue in this code please email [disclosure@digital.cabinet-office.gov.uk](mailto:disclosure@digital.cabinet-office.gov.uk) with details.

For non-security related bugs and feature requests please [raise an issue](https://github.com/alphagov/verify-metadata-generator/issues/new) in the GitHub issue tracker.

## Licence

[LICENCE](LICENCE)
