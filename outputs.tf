output "snowflake_rsa_public_key" {
    value     = tls_private_key.snowflake_rsa_key.public_key_pem
}


output "snowflake_rsa_private_key" {
    value     = tls_private_key.snowflake_rsa_key.private_key_pem
    sensitive = true
}