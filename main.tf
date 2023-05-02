terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = ">= 1.0"

  #  backend "remote" {
  #    organization = "Oleksii_Demo_ToDo_project"
  #
  #    workspaces {
  #      name = "To_Do_instance_setup"
  #    }
  #  }
}


provider "aws" {
  region     = var.region
  access_key = var.key
  secret_key = var.secret
}

#resource "tls_private_key" "test_key" {
#  algorithm = "RSA"
#  rsa_bits  = 4096
#}
#
#resource "aws_key_pair" "generated_key" {
#  key_name   = "test_key"
#  public_key = tls_private_key.test_key.public_key_openssh
#}

resource "random_pet" "sg" {}

resource "aws_security_group" "web-sg" {
  name = "${random_pet.sg.id}-sg"
  egress {
    from_port   = 0
    to_port     = 65000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 65000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "test" {
  ami                    = "ami-0a695f0d95cefc163"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  #  key_name               = "test_ssh_access"
  #  user_data = <<-EOF
  #  #!/bin/bash
  #  yum -y update
  #  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash . ~/.nvm/nvm.sh
  #  nvm install 16.13.1
  #  yum -y install git
  #  EOF
  tags = {
    Name = "Test insta"
  }
}
# resource "aws_instance" "ansible_on_ubuntu" {
#   ami                    = "ami-00874d747dde814fa"
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.web-sg.id]
#   key_name               = "test_ssh_access"
#   user_data              = <<-EOF
#   #!/bin/bash
#   sudo apt-get update -y && sudo apt-get upgrade -y
#   sudo apt-get install ansible -y
# 
#   EOF
#   tags = {
#     Name = "Ansible_Ubuntu"
#   }
# }



output "web-address_test_instance" {
  value = aws_instance.test.public_dns
}
# output "web-address_ansible_instance" {
#  value = aws_instance.ansible_on_ubuntu.public_dns
#}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

variable "region" {
  default = "us-east-2"
}