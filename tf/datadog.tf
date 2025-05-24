# Integración AWS-Datadog
resource "datadog_integration_aws" "sandbox" {
  account_id  = data.aws_caller_identity.current.account_id
  role_name   = "DatadogAWSIntegrationRole"
}

# Obtener información de la cuenta AWS actual
data "aws_caller_identity" "current" {}

# Role IAM para Datadog
resource "aws_iam_role" "datadog_integration_role" {
  name = "DatadogAWSIntegrationRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::464622532012:root"
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = datadog_integration_aws.sandbox.external_id
          }
        }
      }
    ]
  })
}

# Política para Datadog
resource "aws_iam_role_policy" "datadog_aws_integration" {
  name = "DatadogAWSIntegrationPolicy"
  role = aws_iam_role.datadog_integration_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:Describe*",
          "budgets:ViewBudget",
          "cloudfront:GetDistributionConfig",
          "cloudfront:ListDistributions",
          "cloudtrail:DescribeTrails",
          "cloudtrail:GetTrailStatus",
          "cloudtrail:LookupEvents",
          "cloudwatch:Describe*",
          "cloudwatch:Get*",
          "cloudwatch:List*",
          "codedeploy:List*",
          "codedeploy:BatchGet*",
          "directconnect:Describe*",
          "dynamodb:List*",
          "dynamodb:Describe*",
          "ec2:Describe*",
          "ecs:Describe*",
          "ecs:List*",
          "elasticache:Describe*",
          "elasticache:List*",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeTags",
          "elasticloadbalancing:Describe*",
          "elasticmapreduce:List*",
          "elasticmapreduce:Describe*",
          "es:ListTags",
          "es:ListDomainNames",
          "es:DescribeElasticsearchDomains",
          "health:DescribeEvents",
          "health:DescribeEventDetails",
          "health:DescribeAffectedEntities",
          "kinesis:List*",
          "kinesis:Describe*",
          "lambda:AddPermission",
          "lambda:GetPolicy",
          "lambda:List*",
          "lambda:RemovePermission",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DeleteLogGroup",
          "logs:DeleteLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:FilterLogEvents",
          "logs:PutLogEvents",
          "logs:PutRetentionPolicy",
          "rds:Describe*",
          "rds:List*",
          "redshift:DescribeClusters",
          "redshift:DescribeLoggingStatus",
          "route53:List*",
          "s3:GetBucketLogging",
          "s3:GetBucketLocation",
          "s3:GetBucketNotification",
          "s3:GetBucketTagging",
          "s3:ListAllMyBuckets",
          "s3:PutBucketNotification",
          "ses:Get*",
          "sns:List*",
          "sns:Publish",
          "sqs:ListQueues",
          "support:*",
          "tag:GetResources",
          "tag:GetTagKeys",
          "tag:GetTagValues",
          "xray:BatchGetTraces",
          "xray:GetTraceSummaries"
        ]
        Resource = "*"
      }
    ]
  })
}

# Dashboard en Datadog
resource "datadog_dashboard" "aws_infrastructure" {
  title         = "AWS Infrastructure Monitoring"
  description   = "Dashboard para monitorear la infraestructura AWS del proyecto"
  layout_type   = "ordered"
  is_read_only  = false

  widget {
    timeseries_definition {
      title       = "EC2 CPU Utilization"
      title_size  = "16"
      title_align = "left"
      request {
        q = "avg:aws.ec2.cpuutilization{*} by {instanceid}"
        display_type = "line"
        style {
          palette = "dog_classic"
          line_type = "solid"
          line_width = "normal"
        }
      }
      yaxis {
        label = "CPU %"
        scale = "linear"
        min   = "0"
        max   = "100"
      }
    }
  }

  widget {
    timeseries_definition {
      title       = "EC2 Network In/Out"
      title_size  = "16"
      title_align = "left"
      request {
        q = "avg:aws.ec2.networkin{*} by {instanceid}"
        display_type = "line"
        style {
          palette = "cool"
          line_type = "solid"
          line_width = "normal"
        }
      }
      request {
        q = "avg:aws.ec2.networkout{*} by {instanceid}"
        display_type = "line"
        style {
          palette = "warm"
          line_type = "solid"
          line_width = "normal"
        }
      }
      yaxis {
        label = "Bytes/sec"
        scale = "linear"
      }
    }
  }

  widget {
    query_value_definition {
      title       = "Total EC2 Instances"
      title_size  = "16"
      title_align = "left"
      request {
        q = "count:aws.ec2.cpuutilization{*} by {instanceid}"
        aggregator = "last"
      }
      autoscale = true
      precision = 0
    }
  }

  widget {
    toplist_definition {
      title       = "Top EC2 Instances by CPU"
      title_size  = "16"
      title_align = "left"
      request {
        q = "top(avg:aws.ec2.cpuutilization{*} by {instanceid}, 10, 'mean', 'desc')"
      }
    }
  }
} 