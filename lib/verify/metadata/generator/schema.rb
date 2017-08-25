require 'json'
module Verify
  module Metadata
    module Generator
      module Schema
        HUB = JSON.parse <<JSON
{
  "title":"IDP",
  "description":"The necessary configuration for an IDP",
  "type":"object",
  "required": ["id", "entity_id", "assertion_consumer_service_uri", "organization", "signing_certificates", "encryption_certificate"],
  "definitions": {
    "organization": {
      "type": "object",
      "properties": {
        "name": { "type": "string" },
        "display_name": { "type": "string" },
        "url": { "type": "string", "format": "uri" }
      },
      "required": ["display_name", "name", "url"]
    },
    "certificate": {
      "type": "object",
      "properties": {
        "x509": { "type": "string" },
        "name": { "type": "string" }
      },
      "required": ["x509", "name"]
    }
  },
  "properties": {
    "id": {"type": "string"},
    "entity_id": {"type": "string", "format": "uri" },
    "assertion_consumer_service_uri": {"type": "string", "format": "uri" },
    "organization": { "$ref": "#/definitions/organization" },
    "signing_certificates": {
      "type": "array",
      "minItems": 1,
      "items": { "$ref": "#/definitions/certificate" }
    },
    "encryption_certificate": {
       "$ref": "#/definitions/certificate"
    }
  }
}
JSON

        IDP = JSON.parse <<JSON
{
  "title":"IDP",
  "description":"The necessary configuration for an IDP",
  "type":"object",
  "required": ["id", "entity_id", "sso_uri", "enabled", "organization", "signing_certificates"],
  "definitions": {
    "organization": {
      "type": "object",
      "properties": {
        "name": { "type": "string" },
        "display_name": { "type": "string" },
        "url": { "type": "string", "format": "uri" }
      },
      "required": ["display_name", "name", "url"]
    },
    "certificate": {
      "type": "object",
      "properties": {
        "x509": { "type": "string" }
      },
      "required": ["x509"]
    }
  },
  "properties": {
    "id": {"type": "string"},
    "entity_id": {"type": "string", "format": "uri" },
    "enabled": {"type": "boolean" },
    "sso_uri": {"type": "string", "format": "uri" },
    "organization": { "$ref": "#/definitions/organization" },
    "signing_certificates": {
      "type": "array",
      "minItems": 1,
      "items": { "$ref": "#/definitions/certificate" }
    }
  }
}
JSON
      end
    end
  end
end
