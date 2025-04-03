resource "random_password" "redmine_db_password" {
  length  = 16
  special = false
}

resource "azurerm_postgresql_flexible_server_database" "redmine_db" {
  name      = local.redminedb_name
  server_id = var.dbserver_id
  collation = "en_US.utf8"
  charset   = "UTF8"
  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = false
  }
}

resource "kubernetes_secret" "redmine_db_auth" {
  metadata {
    name = "redmine-db-auth"
  }

  data = {
    username = local.redminedb_user
    password = random_password.redmine_db_password.result
  }

  type = "kubernetes.io/basic-auth"
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
            PGPASSWORD=${var.dbserver_admin_password} psql -h ${var.dbserver_host} -U ${var.dbserver_admin_login} -d ${local.redminedb_name} -c "
            DO \$\$
            BEGIN
              IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${local.redminedb_user}') THEN
                CREATE USER ${local.redminedb_user} WITH PASSWORD '${random_password.redmine_db_password.result}';
              END IF;
            END \$\$;
            GRANT CONNECT ON DATABASE ${local.redminedb_name} TO ${local.redminedb_user};"
            EOT
          ]
        }
      }
    }
    ttl_seconds_after_finished = 60
  }
}
