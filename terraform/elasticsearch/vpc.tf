/*Add a new set of data.aws_iam_policy_document, aws_elasticsearch_domain, aws_elasticsearch_domain_policy. Because currently terraform/aws_elasticsearch_domain 
does not handle properly null/empty "vpc_options" */

data "aws_vpc" "es" {
  count   = var.vpc_config == null ? 0 : 1
  tags = {
    var.vpc_config.env_tag = var.vpc_config.env_value
  }
}

data "aws_subnet_ids" "es" {
  count   = var.vpc_config == null ? 0 : 1
  vpc_id = data.aws_vpc.es[0].id
  tags = {
    var.vpc_config.subnet_tag = var.vpc_config.subnet_value
  }
}

data "aws_security_groups" "es" {
  count   = var.vpc_config == null ? 0 : 1
  tags = {
    var.vpc_config.sg_tag  = var.vpc_config.sg_value,
    var.vpc_config.env_tag = var.vpc_config.env_value
  }
}

data "aws_iam_policy_document" "es_vpc_management_access" {
  count = local.inside_vpc ? 1 : 0

  statement {
    actions = [
      "es:*",
    ]


    resources = [
      aws_elasticsearch_domain.es_vpc[0].arn,
      "${aws_elasticsearch_domain.es_vpc[0].arn}/*",
    ]

    principals {
      type = "AWS"

      identifiers = distinct(compact(var.management_iam_roles))
    }
  }
}

resource "aws_iam_service_linked_role" "es" {
  count            = var.create_iam_service_linked_role ? 1 : 0
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "es_vpc" {
  count = local.inside_vpc ? 1 : 0

  depends_on = [aws_iam_service_linked_role.es]

  domain_name           = local.domain_name
  elasticsearch_version = var.es_version

  encrypt_at_rest {
    enabled    = var.at_rest_encryption_enabled && (substr(var.instance_type, 1, 1) != "2" && substr(var.instance_type, 1, 1) != "3") ? true : false 
    kms_key_id = var.kms_key_id
  }

  cluster_config {
    instance_type            = var.instance_type
    instance_count           = var.instance_count
    dedicated_master_enabled = var.instance_count >= var.dedicated_master_threshold ? true : false
    dedicated_master_count   = var.instance_count >= var.dedicated_master_threshold ? 3 : 0
    dedicated_master_type    = var.instance_count >= var.dedicated_master_threshold ? var.dedicated_master_type != "false" ? var.dedicated_master_type : var.instance_type : ""
    zone_awareness_enabled   = var.instance_count > 1 ? true : false

   
    dynamic "zone_awareness_config" {
      for_each = var.zone_awareness_count == null ? [] : [var.zone_awareness_count]
      content {
        availability_zone_count   = var.zone_awareness_count
      }
    }
  }



  advanced_options = var.advanced_options

  dynamic "log_publishing_options" {
    for_each = var.log_publishing_options
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      cloudwatch_log_group_arn = log_publishing_options.value.cloudwatch_log_group_arn
      enabled                  = lookup(log_publishing_options.value, "enabled", null)
      log_type                 = log_publishing_options.value.log_type
    }
  }

  node_to_node_encryption {
    enabled = var.node_to_node_encryption_enabled
  }

  vpc_options {
    subnet_ids         = slice(tolist(data.aws_subnet_ids.es[0].ids), 0, var.instance_count)
    security_group_ids = data.aws_security_groups.es[0].ids
  }

  ebs_options {
    ebs_enabled = var.ebs_volume_size > 0 ? true : false
    volume_size = var.ebs_volume_size
    volume_type = var.ebs_volume_type
  }

  snapshot_options {
    automated_snapshot_start_hour = var.snapshot_start_hour
  }

  tags = merge(
    {
      "Domain" = local.domain_name
    },
    var.tags,
  )
}

resource "aws_elasticsearch_domain_policy" "es_vpc_management_access" {
  count = local.inside_vpc ? 1 : 0

  domain_name     = local.domain_name
  access_policies = data.aws_iam_policy_document.es_vpc_management_access[0].json
}
