resource "aws_route53recoverycontrol_cluster" "paysecure" {
  name = "paysecure-dr-cluster"
}

resource "aws_route53recoverycontrol_routing_control" "mumbai" {
  cluster_arn = aws_route53recoverycontrol_cluster.paysecure.arn
  name        = "mumbai-routing-control"
}

resource "aws_route53recoverycontrol_routing_control" "hyderabad" {
  cluster_arn = aws_route53recoverycontrol_cluster.paysecure.arn
  name        = "hyderabad-routing-control"
}

resource "aws_route53recoveryreadiness_cell" "mumbai" {
  cell_name = "mumbai-cell"
}

resource "aws_route53recoveryreadiness_cell" "hyderabad" {
  cell_name = "hyderabad-cell"
}

resource "aws_route53recoveryreadiness_recovery_group" "paysecure" {
  recovery_group_name = "paysecure-recovery-group"

  cells = [
    aws_route53recoveryreadiness_cell.mumbai.arn,
    aws_route53recoveryreadiness_cell.hyderabad.arn
  ]
}
