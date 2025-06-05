
# Casting Networks DevOps

This repository contains a collection of Terraform modules for provisioning and managing various AWS resources. These modules are designed to be reusable, configurable, and follow best practices for AWS infrastructure deployment.

## Module Structure

Each module follows a consistent file structure:
- `aws.tf` - Standard AWS data sources (account_id, region, partition)
- `main.tf` - Primary resource definitions
- `variables.tf` - Input variable declarations
- `outputs.tf` - Output values following `this_[service]_[attribute]` naming
- `terraform.tf` - Version constraints (all modules require >= 0.12.0)
- Additional service-specific files (e.g., `vpc.tf`, `iam.tf`, `security_groups.tf`)


## Available Modules

The repository includes the following Terraform modules:

- **ALB Webhook**: AWS Application Load Balancer configuration for webhook endpoints
- **API Gateway V2**: REST API Gateway with caching
- **API Gateway V2 No Cache**: REST API Gateway without caching
- **App IAM**: IAM roles and policies for applications
- **Elasticsearch**: AWS Elasticsearch service configuration
- **Kinesis**: AWS Kinesis data streams
- **Lambda**: AWS Lambda functions with configurable parameters
- **Redis**: AWS ElastiCache for Redis
- **S3**: S3 buckets with various configuration options
- **SNS**: Simple Notification Service topics
- **SQS**: Simple Queue Service queues with dead-letter queue support
- **Step Functions**: AWS Step Functions state machines

## Module Categories

**Compute & Functions:**
- `lambda/` - Lambda functions with VPC, IAM, and S3 artifact support
- `stepfunctions/` - Step Functions state machines

**API & Integration:**
- `api_gateway_v2/` - HTTP API Gateway with Route53
- `api_gateway_v2_nocache/` - HTTP API Gateway without caching
- `alb-webhook/` - Application Load Balancer for webhooks

**Storage & Data:**
- `s3/` - S3 buckets with lifecycle rules and encryption
- `elasticsearch/` - Managed Elasticsearch domains
- `redis/` - ElastiCache Redis clusters

**Messaging:**
- `sqs/` - SQS queues with dead-letter queue support
- `sns/` - SNS topics and subscriptions (modular structure)
- `kinesis/` - Kinesis data streams

**Security:**
- `app_iam/` - IAM roles and policies for applications


## Prerequisites

- Terraform >= 0.12
- AWS CLI configured with appropriate credentials
- Basic understanding of AWS services and Terraform

## How to Use

Each module can be used by referencing it in your Terraform configuration:

```hcl
module "lambda_function" {
  source = "github.com/castingnetworks/devops-public//terraform/lambda"
  
  function_name     = "my-lambda-function"
  handler           = "index.handler"
  runtime           = "nodejs20.x"
  artifact_bucket   = "my-artifact-bucket"
  artifact_hash_key = "lambda/my-function/hash.txt"
  artifact_zip_key  = "lambda/my-function/function.zip"
  
  # Optional parameters
  memory_size = 256
  timeout     = 30
  
  environment = {
    variables = {
      ENV_VAR_1 = "value1"
      ENV_VAR_2 = "value2"
    }
  }
  
  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

## Module Documentation

### Lambda Module

Creates an AWS Lambda function with configurable parameters.

**Required Variables:**
- `function_name`: Name of the Lambda function
- `handler`: Function handler (e.g., "index.handler")
- `runtime`: Runtime environment (e.g., "nodejs14.x")
- `artifact_bucket`: S3 bucket containing Lambda artifacts
- `artifact_hash_key`: S3 key for the artifact checksum hash file
- `artifact_zip_key`: S3 key for the artifact zip file

**Optional Variables:**
- `description`: Description of the Lambda function
- `memory_size`: Amount of memory allocated to the function
- `timeout`: Function execution timeout
- `environment`: Environment variables for the function
- `vpc_config`: VPC configuration for the function
- And many more (see variables.tf for details)

### S3 Module

Creates an S3 bucket with various configuration options.

**Required Variables:**
- `bucket`: Name of the S3 bucket

**Optional Variables:**
- `acl`: Access control list for the bucket
- `force_destroy`: Whether to force destroy the bucket even if it contains objects
- `versioning`: Configuration for versioning
- `lifecycle_rules`: Configuration for object lifecycle management
- And many more (see variables.tf for details)

### SQS Module

Creates an SQS queue with a dead-letter queue.

**Required Variables:**
- `name`: Name of the SQS queue

**Optional Variables:**
- `visibility_timeout_seconds`: Visibility timeout for messages
- `message_retention_seconds`: Message retention period
- `max_message_size`: Maximum message size
- `delay_seconds`: Delay before messages become visible
- `message_max_receive`: Maximum number of receives before sending to dead-letter queue
- And many more (see variables.tf for details)

## Best Practices

When using these modules, consider the following best practices:

1. Always specify explicit versions when referencing modules
2. Use variables to make your configurations reusable
3. Follow the principle of least privilege when configuring IAM policies
4. Use tags to organize and track your AWS resources
5. Implement proper error handling and monitoring

