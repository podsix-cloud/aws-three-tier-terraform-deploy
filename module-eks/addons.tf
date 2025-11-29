provider "helm" {
    kubernetes = {
        host                   = aws_eks_cluster.eks.endpoint
        cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
        token                  = data.aws_eks_cluster_auth.eks.token
    }
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

data "aws_eks_cluster_auth" "eks" {
    name = aws_eks_cluster.eks.name
}

# Create namespaces
resource "kubernetes_namespace" "ingress" {
  provider = kubernetes.eks
  metadata {
    name = "ingress-nginx"
  }
}

resource "kubernetes_namespace" "cert_manager" {
  provider = kubernetes.eks
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_namespace" "argocd" {
  provider = kubernetes.eks
  metadata {
    name = "argocd"
  }
}


resource "helm_release" "nginx_ingress" {
    name       = "nginx-ingress"
    repository = "https://kubernetes.github.io/ingress-nginx"
    chart      = "ingress-nginx"
    version    = "4.12.0"
    namespace  = "ingress-nginx"
    create_namespace = false
    timeout = 600 

    values = [file("${path.module}/nginx-ingress-values.yaml")]
    depends_on = [ aws_eks_node_group.eks_node_group, kubernetes_namespace.ingress ]
}

data "aws_lb" "nginx_ingress" {
  tags = {
    "kubernetes.io/service-name" = "ingress-nginx/nginx-ingress-ingress-nginx-controller"
  }

  depends_on = [helm_release.nginx_ingress]
}

resource "helm_release" "cert_manager" {
    name       = "cert-manager"
    repository = "https://charts.jetstack.io"
    chart      = "cert-manager"
    version    = "1.14.5"
    namespace  = "cert-manager"
    create_namespace = false
    timeout = 600
    wait = true
    wait_for_jobs = true
    
    set = [
        {
            name  = "installCRDs"
            value = "true"
        },
        {
            name  = "global.leaderElection.namespace"
            value = "cert-manager"
        }
    ]
    
    depends_on = [ helm_release.nginx_ingress, kubernetes_namespace.cert_manager ]
}
#==================================================

resource "helm_release" "argocd" {
    name             = "argocd"
    repository       = "https://argoproj.github.io/argo-helm"
    chart            = "argo-cd"
    version          = "5.51.6"
    namespace        = "argocd"
    create_namespace = false
    wait = true
    timeout = 600
    values = [file("${path.module}/argocd-values.yaml")]
    depends_on = [ helm_release.nginx_ingress, helm_release.cert_manager, kubernetes_namespace.argocd ]
}