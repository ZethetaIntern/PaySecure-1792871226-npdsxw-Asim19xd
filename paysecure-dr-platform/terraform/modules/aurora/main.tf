resource "aws_rds_global_cluster" "paysecure" {
  global_cluster_identifier = "paysecure-global"
  engine                    = "aurora-postgresql"
  engine_version            = "15.4"
  storage_encrypted         = true
}

resource "aws_rds_cluster" "regional" {
  cluster_identifier              = "paysecure-aurora-${var.region}"
  engine                          = "aurora-postgresql"
  engine_version                  = "15.4"
  database_name                   = var.database_name
  master_username                 = "paysecure_admin"
  manage_master_user_password     = true
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.paysecure.name
  storage_encrypted               = true
  backup_retention_period         = 35
  deletion_protection             = true

  global_cluster_identifier = var.global_cluster ? aws_rds_global_cluster.paysecure.id : null
}

resource "aws_rds_cluster_parameter_group" "paysecure" {
  family = "aurora-postgresql15"
  name   = "paysecure-aurora-${var.region}"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }
}

resource "aws_rds_cluster_instance" "writer" {
  identifier         = "paysecure-aurora-${var.region}-writer"
  cluster_identifier = aws_rds_cluster.regional.id
  instance_class     = var.instance_class
  engine             = "aurora-postgresql"
}

resource "aws_rds_cluster_instance" "reader" {
  count              = 2
  identifier         = "paysecure-aurora-${var.region}-reader-${count.index}"
  cluster_identifier = aws_rds_cluster.regional.id
  instance_class     = var.instance_class
  engine             = "aurora-postgresql"
}
