terraform {
  backend "s3" {
    bucket               = "databricks-terraform-infra-bucket"
    workspace_key_prefix = "workspaces"
    key                  = "terraform.tfstate"
    region               = "eu-central-1"
    # encrypt              = true
    # kms_key_id           = "alias/***"
  }
}