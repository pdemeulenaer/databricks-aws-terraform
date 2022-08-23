// Create the S3 root bucket.
// See https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest
resource "aws_s3_bucket" "root_storage_bucket" {
  bucket = "${local.prefix}-rootbucket"
  acl    = "private"
  versioning {
    enabled = false
  }
  force_destroy = true
  tags = merge(var.tags, {
    Name = "${local.prefix}-rootbucket"
  })
}

// Ignore public access control lists (ACLs) on the S3 root bucket and on any objects that this bucket contains.
// See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "root_storage_bucket" {
  bucket             = aws_s3_bucket.root_storage_bucket.id
  ignore_public_acls = true
  depends_on         = [aws_s3_bucket.root_storage_bucket]
}

// Configure a simple access policy for the S3 root bucket within your AWS account, so that Databricks can access data in it.
// See https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/aws_bucket_policy
data "databricks_aws_bucket_policy" "this" {
  bucket = aws_s3_bucket.root_storage_bucket.bucket
}

// Attach the access policy to the S3 root bucket within your AWS account.
// See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
resource "aws_s3_bucket_policy" "root_bucket_policy" {
  bucket     = aws_s3_bucket.root_storage_bucket.id
  policy     = data.databricks_aws_bucket_policy.this.json
  depends_on = [aws_s3_bucket_public_access_block.root_storage_bucket]
}

// Configure the S3 root bucket within your AWS account for new Databricks workspaces.
// See https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_storage_configurations
resource "databricks_mws_storage_configurations" "this" {
  provider                   = databricks.mws
  account_id                 = var.databricks_account_id
  bucket_name                = aws_s3_bucket.root_storage_bucket.bucket
  storage_configuration_name = "${local.prefix}-storage"
}