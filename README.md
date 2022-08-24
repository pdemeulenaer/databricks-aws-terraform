# Databricks Terraform provider sample for AWS

This follows the tutorial found in https://docs.databricks.com/dev-tools/terraform/tutorial-aws.html

The tutorial itself is explained in Provision Databricks workspaces using Terraform (E2): https://docs.databricks.com/dev-tools/terraform/e2-workspace.html

I amended the template to follow more closely https://registry.terraform.io/providers/databricks/databricks/latest/docs/guides/aws-workspace

terraform init
terraform apply -var-file="tutorial.tfvars"
