resource "helm_release" "descheduler" {
    name                = "descheduler"
    repository          = "https://kubernetes-sigs.github.io/descheduler" 
    chart               = "descheduler"
    namespace           = "kube-system"
    create_namespace    = true


    set {
        name    = "cronJobApiVersion"
        value   = "batch/v1beta1"
    }

    depends_on = [
        aws_eks_cluster.aws_eks,
        aws_eks_node_group.this,
        kubernetes_config_map.aws-auth
    ]
}