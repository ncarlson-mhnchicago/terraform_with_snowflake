terraform {
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
    }
  }
}

# Variables
locals {
    snowflake_organization_name = "VNYUEIJ"
    snowflake_account_name      = "PV17486"
    snowflake_private_key_path  = "C:\\Users\\ncarlson.MHN\\.ssh\\rsa_private.txt "
	# snowflake_private_key_passphrase = {
	# 	type      = "Passprase here"
	# 	sensitive = true
	# }
}

# ==================================================
# Providers
# ==================================================

provider "snowflake" {
    organization_name 		= local.snowflake_organization_name
    account_name      		= local.snowflake_account_name
    user              		= "TERRAFORM_SVC"
    role              		= "SYSADMIN"
    authenticator     		= "SNOWFLAKE_JWT"
    private_key       		= file(local.snowflake_private_key_path)
	# private_key_passphrase = local.snowflake_private_key_passphrase
}

# ==================================================
# Resources
# ==================================================
resource "snowflake_warehouse" "SNOWFLAKE_TEST_WH" {
  name                      = "TEST_WH"
  warehouse_type            = "STANDARD"
  warehouse_size            = "XSMALL"
  max_cluster_count         = 1
  min_cluster_count         = 1
  auto_suspend              = 60
  auto_resume               = true
  enable_query_acceleration = false
  initially_suspended       = true
}

resource "snowflake_database" "SNOWFLAKE_TF_DB" {
  name         = "TF_DB"
  is_transient = false
}

