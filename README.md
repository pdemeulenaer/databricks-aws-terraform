# Databricks Terraform provider sample for AWS

This follows the tutorial found in https://docs.databricks.com/dev-tools/terraform/tutorial-aws.html

The tutorial itself is explained in Provision Databricks workspaces using Terraform (E2): https://docs.databricks.com/dev-tools/terraform/e2-workspace.html

I amended the template to follow more closely https://registry.terraform.io/providers/databricks/databricks/latest/docs/guides/aws-workspace

Spotted bug: on the first terraform apply, I get an error related to the cross-account role being not properly defined, although an inspection in IAM roles in my AWS account shows that it has been defined. By taking the ARN number and injecting it within the cross-account-role.tf (in the role_arn command within the resource "databricks_mws_credentials"), it then works on the second terraform apply. I need to figure out how to resolve this. 

Update on that bug: actually you can also just run twice the terraform apply command, and the second time will detect the created cross-account role and work. I nonetheless think that the first time could work with a fixed dependency declaration. Think about a PR on that. 

terraform init
terraform apply -var-file="tutorial.tfvars"
