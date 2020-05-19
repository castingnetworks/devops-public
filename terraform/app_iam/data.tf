data "aws_eks_cluster" "eks" {
  name = var.eks_cluster_name
}

data "aws_iam_policy_document" "app-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      identifiers = ["${data.aws_eks_cluster.eks.identity.oidc.0.issuer}"]
      type        = "Federated"
    }
  }
}
