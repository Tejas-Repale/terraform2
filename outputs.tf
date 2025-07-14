// root outputs.tf

// root outputs.tf
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_arn" {
  value = module.application_load_balancer.alb_arn
}

output "asg_name" {
  value = module.autoscaling_group.asg_name
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "public_subnet_ids" {
  value = [module.public_subnet_1.subnet_id, module.public_subnet_2.subnet_id]
}

output "private_subnet_ids" {
  value = [module.private_subnet_1.subnet_id, module.private_subnet_2.subnet_id]
}

output "security_group_id" {
  value = module.security_group.sg_id
}



