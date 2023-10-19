# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "clustername" {
  description = "Clustername"
  type        = string
  default     = "monitoring"
}

variable "amazoncontainerimageregistry" {
  description = "See https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html for your region"
  type        = string
  default     = "602401143452.dkr.ecr.eu-central-1.amazonaws.com"
}

variable "clusterdomain" {
  description = "Clusterdomain that will be used"
  type        = string
  default     = "eks.kenbun.de"
}
