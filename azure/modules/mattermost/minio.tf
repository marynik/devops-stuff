# resource "kubernetes_secret" "mattermost_minio_auth" {
#   metadata {
#     name = "mattermost-minio-auth"
#     namespace = local.namespace
#   }
#   data = {
#     accesskey = google_storage_hmac_key.hmac-key.access_id
#     secretkey = google_storage_hmac_key.hmac-key.secret
#   }
# }

resource "helm_release" "minio-operator" {
  name = "minio-operator"
  repository = "https://operator.min.io"
  chart = local.minio_operator_helm_chart
  namespace = local.minio_operator_namespace
  create_namespace = true
  force_update = true
  cleanup_on_fail = true
  replace = true
}

resource "helm_release" "minio" {
  name = "minio"
  repository = "https://operator.min.io"
  chart = local.minio_helm_chart
  namespace = local.minio_namespace
  create_namespace = true
  cleanup_on_fail = true
  values = [
    file("${path.module}/values.yaml")
  ]
  depends_on = [ helm_release.minio-operator ]
}

