terraform {
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
    }
  }
}

# Create a key
resource "tls_private_key" "snowflake_rsa_key" {
    algorithm = "RSA"
    rsa_bits  = 2048
}

locals {
    snowflake_organization_name = "VNYUEIJ"
    snowflake_account_name      = "PV17486"
    snowflake_authenticator		= "SNOWFLAKE_JWT"
	# snowflake_private_key		= substr(tls_private_key.snowflake_rsa_key.private_key_pem, 27, 398)
	snowflake_private_key_path  = "C:\\Users\\ncarlson.MHN\\.ssh\\rsa_private.txt"
	# snowflake_private_key_passphrase = {
	# 	type      = "Passprase here"
	# 	sensitive = true
	# }
}

# Role SYSADMIN
provider "snowflake" {
    organization_name 		= local.snowflake_organization_name
    account_name      		= local.snowflake_account_name
    user              		= "TERRAFORM_SVC"
    role              		= "SYSADMIN"
    authenticator     		= "SNOWFLAKE_JWT"
    private_key       		= file(local.snowflake_private_key_path)
	# private_key_passphrase = local.snowflake_private_key_passphrase
}

# ROLE USERADMIN
provider "snowflake" {
    organization_name 		= local.snowflake_organization_name
    account_name      		= local.snowflake_account_name
    user              		= "TERRAFORM_SVC"
    role              		= "USERADMIN"
    alias                   = "snowflake_useradmin"
    authenticator     		= "SNOWFLAKE_JWT"
    private_key       		= file(local.snowflake_private_key_path)
	# private_key_passphrase = local.snowflake_private_key_passphrase
}
