provider "aws" {
    
  region = var.region

}

terraform {
  backend "s3" {
    bucket = "tlv-s3-first-bucket"
    key    = "moudle_project/main_tfstate.tfstate"
    region = "il-central-1"
  }
}

##-------------------------------------------------------------------------------------------##
## 1-6 - Nwtwork Project
##-------------------------------------------------------------------------------------------##

module "network_layer" {

  # This block replaces the separate network project.

  source = "./modules/vpc_network"

  env                   = var.env
  vpc_cidr              = var.vpc_cidr
  public_subnet_ciders  = var.public_subnet_ciders
  private_subnet_ciders = var.private_subnet_ciders
  db_subnet_ciders      = var.db_subnet_ciders
}


##-------------------------------------------------------------------------------------------##
## 7 - security group - open port 22 ssh
##-------------------------------------------------------------------------------------------##

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-ssh-sg"
  description = "Allow SSH inbound traffic"
  
  vpc_id      = module.network_layer.vpc_id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

##-------------------------------------------------------------------------------------------##
## 8 - Launch Template
##-------------------------------------------------------------------------------------------##

resource "aws_launch_template" "bastion_template" {
  name_prefix   = "bastion-template-"
  image_id      = data.aws_ami.ubuntu24_ami.id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.bastion_sg.id]
  }

  user_data = base64encode(file("userdata.sh"))

  lifecycle {
    create_before_destroy = true
  }
}

##-------------------------------------------------------------------------------------------##
## 9 - Auto Scaling Group (ASG)
##-------------------------------------------------------------------------------------------##

resource "aws_autoscaling_group" "bastion_asg" {
  name_prefix         = "bastion-asg-"
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = module.network_layer.public_subnet_ids

  launch_template {
    id      = aws_launch_template.bastion_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "bastion-asg-instance"
    propagate_at_launch = true
  }
}