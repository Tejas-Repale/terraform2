
// root main.tf calling all modules

# root main.tf calling all modules

module "vpc" {
  source     = "./modules/vpc"
  cidr_vpc   = var.cidr_vpc
  tags_vpc   = var.tags_vpc
}

module "public_subnet_1" {
  source        = "./modules/subnet"
  vpc_id        = module.vpc.vpc_id
  cidr_subnet   = var.public_subnet_1_cidr
  az_subnet     = var.az1
  public        = true
  tags_subnet   = var.tags_public_subnet_1
}

module "public_subnet_2" {
  source        = "./modules/subnet"
  vpc_id        = module.vpc.vpc_id
  cidr_subnet   = var.public_subnet_2_cidr
  az_subnet     = var.az2
  public        = true
  tags_subnet   = var.tags_public_subnet_2
}

module "private_subnet_1" {
  source        = "./modules/subnet"
  vpc_id        = module.vpc.vpc_id
  cidr_subnet   = var.private_subnet_1_cidr
  az_subnet     = var.az1
  public        = false
  tags_subnet   = var.tags_private_subnet_1
}

module "private_subnet_2" {
  source        = "./modules/subnet"
  vpc_id        = module.vpc.vpc_id
  cidr_subnet   = var.private_subnet_2_cidr
  az_subnet     = var.az2
  public        = false
  tags_subnet   = var.tags_private_subnet_2
}

module "internet_gateway" {
  source   = "./modules/internet_gateway"
  vpc_id   = module.vpc.vpc_id
  tags_igw = var.tags_igw
}

module "route_table" {
  source        = "./modules/route_tables"
  vpc_id        = module.vpc.vpc_id
  rt_cidr_block = "0.0.0.0/0"
  gateway_id    = module.internet_gateway.my_igw_id
  rt_tags       = var.tags_route_table
}

module "rt_association_public_1" {
  source         = "./modules/rt_association"
  subnet_id      = module.public_subnet_1.subnet_id
  route_table_id = module.route_table.rt_id
}

module "rt_association_public_2" {
  source         = "./modules/rt_association"
  subnet_id      = module.public_subnet_2.subnet_id
  route_table_id = module.route_table.rt_id
}

module "security_group" {
  source          = "./modules/security_group"
  sg_name         = var.sg_name
  sg_description  = var.sg_description
  vpc_id          = module.vpc.vpc_id
  ingress_rules   = var.ingress_rules
  egress_rules    = var.egress_rules
  tags_sg         = var.tags_sg
}

module "target_group" {
  source    = "./modules/target_group"
  name      = var.tg_name
  port      = var.tg_port
  protocol  = var.tg_protocol
  vpc_id    = module.vpc.vpc_id
  tags_tg   = var.tags_tg
}

module "application_load_balancer" {
  source            = "./modules/application_load_balancer"
  name              = var.alb_name
  is_internal       = var.is_internal
  security_groups   = [module.security_group.sg_id]
  subnets           = [module.public_subnet_1.subnet_id, module.public_subnet_2.subnet_id]
  tags_alb          = var.tags_alb
}

module "subnet_group" {
  source                   = "./modules/subnet_group"
  subnet_group_name        = var.subnet_group_name
  subnet_ids_subnet_group  = [module.private_subnet_1.subnet_id, module.private_subnet_2.subnet_id]
  tags_subnet_group        = var.tags_subnet_group
}

module "rds" {
  source                = "./modules/rds"
  identifier_name       = var.db_identifier
  allocated_storage     = var.allocated_storage
  db_name               = var.db_name
  username              = var.db_username
  vpc_security_group_ids = [module.security_group.sg_id]
  subnet_group_name     = module.subnet_group.subnet_group_id
  tags_rds              = var.tags_rds
}

module "elastic_ip" {
  source   = "./modules/elastic_ip"
  igw      = module.internet_gateway
  tags_eip = var.tags_eip
}

module "nat_gateway" {
  source        = "./modules/nat_gateway"
  nat_subnet_id = module.public_subnet_1.subnet_id
  eip_id        = module.elastic_ip.eip_id
  tags_nat      = var.tags_nat
}

module "launch_template" {
  source                 = "./modules/launch_template"
  name_prefix            = var.lt_name_prefix
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  user_data              = var.user_data
  vpc_security_group_ids = [module.security_group.sg_id]
  tags_lt                = var.tags_lt
}

module "autoscaling_group" {
  source              = "./modules/autoscaling_group"
  vpc_zone_identifier = [module.private_subnet_1.subnet_id, module.private_subnet_2.subnet_id]
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  target_group_arns   = [module.target_group.tg_arn]
  launch_template     = module.launch_template.lt_id
}

