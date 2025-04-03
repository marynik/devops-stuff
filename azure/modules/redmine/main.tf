resource "random_password" "redmine_password" {
  length  = 16
  special = false
}

resource "helm_release" "redmine" {
  name       = local.redmine_service
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "redmine"
  # version    = "32.1.0"

  set {
    name  = "databaseType"
    value = "postgresql"
  }
  set {
    name  = "mariadb.enabled"
    value = "false"
  }
  set {
    name  = "postgresql.enabled"
    value = "false"
  }
  set {
    name  = "externalDatabase.host"
    value = var.dbserver_host
  }
  set {
    name  = "externalDatabase.database"
    value = azurerm_postgresql_flexible_server_database.redmine_db.name
  }
  set {
    name  = "externalDatabase.user"
    value = kubernetes_secret.redmine_db_auth.data.username
  }
  set {
    name  = "externalDatabase.password"
    value = kubernetes_secret.redmine_db_auth.data.password
  }

  set {
    name  = "externalDatabase.existingSecret"
    value = kubernetes_secret.redmine_db_auth.metadata[0].name
  }

  set {
    name = "redmineUsername"
    value = local.redmine_user
  }

  set {
    name = "redminePassword"
    value = random_password.redmine_password.result
  }

  set {
    name = "ingress.enabled"
    value = true
  }

  set {
    name = "ingress.hostname"
    value = var.domain
  }

  set{
    name = "service.loadBalancerIP"
    value = azurerm_public_ip.redmine_ip.ip_address
  }

  # set {
  #   name = "ingress.tls"
  #   value = true
  # }
  # set {
  #   name = "ingress.selfSigned"
  #   value = true
  # }
  # set {
  #   name = "ingress.annotations"
  #   value = "{\"cert-manager.io/cluster-issuer\":\"letsencrypt-prod\"}"
  # }
  # set {
  #   name  = "ingress.annotations.cert-manager\\.io/cluster-issuer"
  #   value = "letsencrypt-prod"
  # }
}

