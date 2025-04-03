
resource "kubernetes_namespace" "mattermost" {
  metadata {
    name = local.namespace
  }
}

resource "helm_release" "mattermost-operator" {
  name = "mattermost-operator"
  repository = "https://helm.mattermost.com"
  chart = local.mattermost_operator_helm_chart
  namespace = local.mattermost_operator_namespace
  create_namespace = true
  force_update = true
  cleanup_on_fail = true
  replace = true
  depends_on = [ helm_release.minio ]
}

resource "kubernetes_secret" "storage-secret" {
  metadata {
    name = "storage-secret"
    namespace = local.namespace
  }
  data = {
    accesskey = local.minio_access_key
    secretkey = local.minio_secret_key
  }
}

resource "helm_release" "mattermost-installation" {
  name = local.resource_name
  chart = local.chart_path
  namespace = kubernetes_namespace.mattermost.metadata[0].name
  set {
    name = "host"
    value = var.domain
  }
  # set {
  #   name = "loadbalancer_ip"
  #   value = azurerm_public_ip.mattermost_ip.ip_address
  # }
  set {
    name = "database_secret"
    value = kubernetes_secret.mattermost_db_auth.metadata[0].name
  }
  set {
    name = "accessKey"
    value = local.minio_access_key
  }
  set {
    name = "secretKey"
    value = local.minio_secret_key
  }
  set {
    name = "bucket"
    value = local.minio_bucket
  }
  set {
    name = "fileStore_url"
    value = "minio.${local.minio_namespace}.svc.cluster.local"
  }
  set {
    name = "bucket_secret"
    value = kubernetes_secret.storage-secret.metadata[0].name
  }
  depends_on = [ helm_release.mattermost-operator ]
}
