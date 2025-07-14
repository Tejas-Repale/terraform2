resource "aws_lb" "this" {
  name               = var.name
  internal           = var.is_internal
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets
  enable_deletion_protection = false
  tags               = var.tags_alb

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }

  depends_on = [
    aws_security_group.this
  ]
}