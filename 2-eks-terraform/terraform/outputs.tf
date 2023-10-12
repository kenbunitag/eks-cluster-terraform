# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

# Only available on Kubernetes version 1.13 and 1.14 clusters created or upgraded on or after September 3, 2019.
output "identity-oidc-issuer" {
  value = "${data.aws_eks_cluster.clusterinfo.identity.0.oidc.0.issuer}"
}

output "identity-oidc-id" {
  value = "${substr(data.aws_eks_cluster.clusterinfo.identity.0.oidc.0.issuer, -32, -1)}"
}

output "identity-oidc" {
  value = "${data.aws_eks_cluster.clusterinfo.identity.0.oidc}"
}
