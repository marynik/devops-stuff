# ---------------------- Helm Ingress-Nginx -----------------------

resource "helm_release" "ingress-nginx" {
  name = local.ingress_release_name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart = local.ingress_helm_chart
  create_namespace = true
  namespace = local.ingress_namespace

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }

  # set {
  #   name = "controller.healthCheckPath"
  #   value = "/"
  # }
}

data "kubernetes_service" "ingress-nginx" {
  metadata {
    name = "${local.ingress_release_name}-controller"
    namespace = local.ingress_namespace
  }
  depends_on = [helm_release.ingress-nginx]
}

