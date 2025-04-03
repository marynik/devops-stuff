resource "random_password" "mattermost_db_password" {
  length  = 16
  special = false
}

resource "azurerm_postgresql_flexible_server_database" "mattermost_db" {
  name      = local.mattermostdb_name
  server_id = var.dbserver_id
  collation = "en_US.utf8"
  charset   = "UTF8"
  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = false
  }
}

resource "kubernetes_secret" "mattermost_db_auth" {
  metadata {
    name = "mattermost-db-auth"
    namespace = local.namespace
  }
  data = {
    # username = local.mattermostdb_user
    # password = random_password.mattermost_db_password.result
    DB_CONNECTION_STRING = "postgres://${local.mattermostdb_user}:${random_password.mattermost_db_password.result}@${var.dbserver_host}:5432/${azurerm_postgresql_flexible_server_database.mattermost_db.name}"
  }
}

resource "kubernetes_job" "psql_user_creator" {
  metadata {
    name = "psql-user-creator"
  }

  spec {
    template {
      metadata {
        name = "psql-user-creator"
      }
      spec {
        restart_policy = "Never"

        container {
          name  = "postgres"
          image = "postgres"

          args = [
            "sh", "-c",
            <<EOT
            PGPASSWORD=${var.dbserver_admin_password} psql -h ${var.dbserver_host} -U ${var.dbserver_admin_login} -d ${local.mattermostdb_name} -c "
            DO \$\$
            BEGIN
              IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${local.mattermostdb_user}') THEN
                CREATE USER ${local.mattermostdb_user} WITH PASSWORD '${random_password.mattermost_db_password.result}';
              END IF;
            END \$\$;
            GRANT CONNECT ON DATABASE ${local.mattermostdb_name} TO ${local.mattermostdb_user};"
            EOT
          ]
        }
      }
    }
    ttl_seconds_after_finished = 60
  }
}
