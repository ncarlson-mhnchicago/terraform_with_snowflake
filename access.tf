

# Create a new user
resource "snowflake_user" "snowflake_tf_user" {
    provider          = snowflake.snowflake_useradmin
    name              = "TF_USER"
    default_warehouse = snowflake_warehouse.snowflake_tf_wh.name
    default_role      = snowflake_account_role.snowflake_tf_role.name
    default_namespace = "${snowflake_database.snowflake_tf_db.name}.${snowflake_schema.snowflake_tf_sc.fully_qualified_name}"
    rsa_public_key    = substr(tls_private_key.snowflake_rsa_key.public_key_pem, 27, 398)
}

# Create a new role
resource "snowflake_account_role" "snowflake_tf_role" {
    provider          = snowflake.snowflake_useradmin
    name              = "TF_ROLE"
    comment           = "My Terraform role"
}

# Grant the snowflake_tf_role to SYSADMIN (best practice)
resource "snowflake_grant_account_role" "grant_snowflake_tf_role_to_sysadmin" {
    provider         = snowflake.snowflake_useradmin
    role_name        = snowflake_account_role.snowflake_tf_role.name
    parent_role_name = "SYSADMIN"
}

# Grant the snowflake_tf_role to snowflake_tf_user
resource "snowflake_grant_account_role" "grant_snowflake_tf_role_to_snowflake_tf_user" {
    provider          = snowflake.snowflake_useradmin
    role_name         = snowflake_account_role.snowflake_tf_role.name
    user_name         = snowflake_user.snowflake_tf_user.name
}

# Grant the snowflake_tf_role usage on the database
resource "snowflake_grant_privileges_to_account_role" "grant_snowflake_tf_role_usage_snowflake_tf_db" {
    provider          = snowflake.snowflake_useradmin
    privileges        = ["USAGE"]
    account_role_name = snowflake_account_role.snowflake_tf_role.name
    on_account_object {
        object_type = "DATABASE"
        object_name = snowflake_database.snowflake_tf_db.name
  }
}

# Grant the snowflake_tf_role usage on the schema
resource "snowflake_grant_privileges_to_account_role" "grant_snowflake_tf_role_usage_snowflake_tf_sc" {
    provider          = snowflake.snowflake_useradmin
    privileges        = ["USAGE"]
    account_role_name = snowflake_account_role.snowflake_tf_role.name
    on_schema {
        schema_name = snowflake_schema.snowflake_tf_sc.fully_qualified_name
  }
}

# Grant the snowflake_tf_role select on all tables in the schema (even if the schema is empty)
resource "snowflake_grant_privileges_to_account_role" "grant_snowflake_tf_role_usage_snowflake_tf_sc_all_tables" {
    provider          = snowflake.snowflake_useradmin
    privileges        = ["SELECT"]
    account_role_name = snowflake_account_role.snowflake_tf_role.name
    on_schema_object {
        all {
            object_type_plural = "TABLES"
            in_schema          = snowflake_schema.snowflake_tf_sc.fully_qualified_name
    }
  }
}

# Grant the snowflake_tf_role select on the future tables in the schema
resource "snowflake_grant_privileges_to_account_role" "grant_snowflake_tf_role_usage_snowflake_tf_sc_all_future_tables" {
    provider          = snowflake.snowflake_useradmin
    privileges        = ["SELECT"]
    account_role_name = snowflake_account_role.snowflake_tf_role.name
    on_schema_object {
        future {
            object_type_plural = "TABLES"
            in_schema          = snowflake_schema.snowflake_tf_sc.fully_qualified_name
    }
  }
}