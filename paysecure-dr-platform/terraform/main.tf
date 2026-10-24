terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.primary_region

  default_tags {
    tags = {
      Application = "paysecure-gateway"
      Environment = var.environment
      DataResidency = "india"
      ManagedBy = "terraform"
    }
  }
}

provider "aws" {
  alias  = "secondary"
  region = var.secondary_region

  default_tags {
    tags = {
      Application = "paysecure-gateway"
      Environment = var.environment
      DataResidency = "india"
      ManagedBy = "terraform"
    }
  }
}

module "aurora_primary" {
  source = "../modules/aurora"

  providers = {
    aws = aws
  }

  region          = var.primary_region
  database_name   = var.aurora_database_name
  instance_class  = var.aurora_instance_class
  global_cluster  = true
}

module "aurora_secondary" {
  source = "../modules/aurora"

  providers = {
    aws = aws.secondary
  }

  region          = var.secondary_region
  database_name   = var.aurora_database_name
  instance_class  = var.aurora_instance_class
  global_cluster  = true
}

module "dynamodb_global_tables" {
  source = "../modules/dynamodb"

  providers = {
    aws          = aws
    aws.secondary = aws.secondary
  }

  regions = [var.primary_region, var.secondary_region]
}

module "msk_primary" {
  source = "../modules/msk"

  providers = {
    aws = aws
  }

  region                   = var.primary_region
  replication_factor       = var.kafka_topic_replication_factor
  min_insync_replicas      = var.kafka_min_insync_replicas
}

module "msk_secondary" {
  source = "../modules/msk"

  providers = {
    aws = aws.secondary
  }

  region                   = var.secondary_region
  replication_factor       = var.kafka_topic_replication_factor
  min_insync_replicas      = var.kafka_min_insync_replicas
}

module "route53_arc" {
  source = "../modules/route53-arc"

  primary_region   = var.primary_region
  secondary_region = var.secondary_region
}
