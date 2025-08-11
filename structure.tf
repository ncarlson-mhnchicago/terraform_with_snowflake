

resource "snowflake_warehouse" "snowflake_tf_wh" {
  name                      = "TF_WH"
  warehouse_type            = "STANDARD"
  warehouse_size            = "SMALL"
  max_cluster_count         = 1
  min_cluster_count         = 1
  auto_suspend              = 60
  auto_resume               = true
  enable_query_acceleration = false
  initially_suspended       = true
}

resource "snowflake_database" "snowflake_tf_db" {
  name         = "TF_DB"
  is_transient = false
}

resource "snowflake_schema" "snowflake_tf_sc" {
  name                = "TF_SC"
  database            = snowflake_database.snowflake_tf_db.name
  with_managed_access = false
}
