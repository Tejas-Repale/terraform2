cidr_vpc = "10.0.0.0/16"

public_subnet_1_cidr = "10.0.1.0/24"
public_subnet_2_cidr = "10.0.2.0/24"
private_subnet_1_cidr = "10.0.3.0/24"
private_subnet_2_cidr = "10.0.4.0/24"
az1 = "ap-south-1a"
az2 = "ap-south-1b"

alb_name = "dev-alb"
is_internal = false

tg_name = "dev-tg"
tg_port = 80
tg_protocol = "HTTP"

lt_name_prefix = "dev-lt"
image_id = "ami-0e670eb768a5fc3d4"
instance_type = "t3.micro"
key_name = "my-key"
user_data = "#!/bin/bash\necho Hello"

db_identifier = "devdb"
db_name = "mydb"
db_username = "admin"

allocated_storage = 20

# Tags
tags_vpc = {
  Name = "dev-vpc"
}
tags_public_subnet_1 = {
  Name = "dev-public-1"
}
tags_public_subnet_2 = {
  Name = "dev-public-2"
}
tags_private_subnet_1 = {
  Name = "dev-private-1"
}
tags_private_subnet_2 = {
  Name = "dev-private-2"
}
tags_igw = {
  Name = "dev-igw"
}
tags_route_table = {
  Name = "dev-rt"
}
tags_sg = {
  Name = "dev-sg"
}
tags_tg = {
  Name = "dev-tg"
}
tags_alb = {
  Name = "dev-alb"
}
tags_subnet_group = {
  Name = "dev-subnet-group"
}
tags_rds = {
  Name = "dev-rds"
}
tags_eip = {
  Name = "dev-eip"
}
tags_nat = {
  Name = "dev-nat"
}
tags_lt = {
  Name = "dev-lt"
}

# Auto Scaling
desired_capacity = 2
max_size = 3
min_size = 1

# Security Rules
ingress_rules = [
  {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "HTTP"
    security_groups = null
  }
]

egress_rules = [
  {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "Allow All"
    security_groups = null
  }
]

sg_name = "dev-sg"
sg_description = "Allow HTTP access"

subnet_group_name = "dev-subnet-group"
profile = "default"
region = "ap-south-1"
