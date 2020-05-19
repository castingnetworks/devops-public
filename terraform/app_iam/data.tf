data "aws_eks_cluster" "eks" {
  name = var.eks_cluster_name
}

resource "aws_iam_openid_connect_provider" "eks" {
  url = data.aws_eks_cluster.eks.identity.0.oidc.0.issuer
}

data "aws_iam_policy_document" "app-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      identifiers = ["${aws_iam_openid_connect_provider.eks.arn}"]
      type        = "Federated"
    }
  }
}
