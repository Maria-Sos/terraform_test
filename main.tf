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
}


provider "aws" {
  region     = var.region
  access_key = var.key
  secret_key = var.secret
}

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
  tags = {
    Name = "Test insta"
  }
}


output "web-address_test_instance" {
  value = aws_instance.test.public_dns
}

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
