variable "eks_cluster_name" {
  description = "Name of EKS Cluster"
  type        = string
}

variable "env" {
  description = "Environment Name"
  type        = string
}

variable "app_name" {
  description = "Name of App"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = null
}

variable "policy" {
  description = "App Policy JSON"
  type        = string
}