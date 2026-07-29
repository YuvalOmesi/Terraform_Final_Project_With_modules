output "Bastion_Details" {
  value =  {
    ubuntu_ami_id  = data.aws_ami.ubuntu24_ami.id
    host_ip        = data.aws_instances.bastion_instances.public_ips
    public_subnets = module.network_layer.public_subnet_ids
  }
}

output "Network_Details" {
  value = {
    vpc_id             = module.network_layer.vpc_id
    vpc_cidr           = module.network_layer.vpc_cidr
    public_subnet_ids  = module.network_layer.public_subnet_ids
    private_subnet_ids = module.network_layer.private_subnet_ids
    db_subnet_ids = module.network_layer.db_subnet_ids
  }
}