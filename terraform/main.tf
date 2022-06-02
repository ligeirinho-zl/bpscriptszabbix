provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

resource "aws_config_config_rule" "rule" {
  for_each = var.resource_tags
  name             = resource_tags.Key
  description      = "Checks whether your resources have the tags that you specify."
  input_parameters = var.tags_json_input

  scope {
    compliance_resource_types = resource_tags.Value
  }

  source {
    owner             = "AWS"
    source_identifier = "REQUIRED_TAGS"
  }
  
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.key
      value = tags.value
    }
  }
}

resource "aws_config_config_rule" "bp-s3-encryption" {
  name        = "bp-s3-encryption"
  description = "Checks whether the Amazon S3 buckets are encrypted with AWS Key Management Service(AWS KMS). The rule is NON_COMPLIANT if the Amazon S3 bucket is not encrypted with AWS KMS key."

  scope {
    compliance_resource_types = ["AWS::S3::Bucket"]
  }

  source {
    owner             = "AWS"
    source_identifier = "S3_DEFAULT_ENCRYPTION_KMS"
  }

  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.key
      value = tags.value
    }
  }
}