data "aws_ami" "ubuntu24_ami" {
    region = var.region

    owners = ["amazon"]
    most_recent = true
    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
                
    }
}

data "aws_instances" "bastion_instances" {
  instance_tags = {
    Name = "bastion-asg-instance"
  }
  instance_state_names = ["running"] 
}