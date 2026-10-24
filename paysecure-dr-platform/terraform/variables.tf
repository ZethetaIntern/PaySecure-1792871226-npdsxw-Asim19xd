variable "primary_region" {
  type    = string
  default = "ap-south-1"
}

variable "secondary_region" {
  type    = string
  default = "ap-south-2"
}

variable "environment" {
  type    = string
  default = "production"
}

variable "aurora_database_name" {
  type    = string
  default = "paysecure"
}

variable "aurora_instance_class" {
  type    = string
  default = "db.r6g.2xlarge"
}

variable "kafka_topic_replication_factor" {
  type    = number
  default = 3
}

variable "kafka_min_insync_replicas" {
  type    = number
  default = 2
}
