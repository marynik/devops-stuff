locals {
    chart_path = "${path.module}/mymattermost_chart"
    resource_name = "chat-devops-steps"
    namespace = "mattermost"
    image = "mattermost/mattermost-team-edition"
    size = "100users"
    version = "10.4.2"

    ingress_helm_chart = "ingress-nginx"
    ingress_namespace = local.namespace
    ingress_release_name = "${local.ingress_helm_chart}-release"

    mattermost_operator_helm_chart = "mattermost-operator"
    mattermost_operator_namespace = "mattermost-operator"

    minio_operator_helm_chart = "operator"
    minio_operator_namespace = "minio-operator"

    minio_helm_chart = "tenant"
    minio_namespace = "myminio"
    minio_bucket = "bucket1"
    minio_access_key = "minio"
    minio_secret_key = "minio123"
    minio_s3endpoint = "minio.myminio.svc.cluster.local"

    mattermostdb_name = "mattermost"
    mattermostdb_user = "mattermost"
}
