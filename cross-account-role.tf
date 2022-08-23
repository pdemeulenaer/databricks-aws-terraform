// Create the required AWS STS assume role policy in your AWS account.
// See https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/aws_assume_role_policy
data "databricks_aws_assume_role_policy" "this" {
  external_id = var.databricks_account_id
}

// Create the required IAM role in your AWS account.
// See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "cross_account_role" {
  name               = "${local.prefix}-crossaccount"
  assume_role_policy = data.databricks_aws_assume_role_policy.this.json
  tags               = var.tags
}

// Create the required AWS cross-account policy in your AWS account.
// See https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/aws_crossaccount_policy
data "databricks_aws_crossaccount_policy" "this" {}

// Create the required IAM role inline policy in your AWS account.
// See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy
resource "aws_iam_role_policy" "this" {
  name   = "${local.prefix}-policy"
  role   = aws_iam_role.cross_account_role.id
  policy = data.databricks_aws_crossaccount_policy.this.json
}

// Properly configure the cross-account role for the creation of new workspaces within your AWS account.
// See https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_credentials
resource "databricks_mws_credentials" "this" {
  provider         = databricks.mws
  account_id       = var.databricks_account_id
  role_arn         = aws_iam_role.cross_account_role.arn
  credentials_name = "${local.prefix}-creds"
  depends_on       = [aws_iam_role_policy.this]
}