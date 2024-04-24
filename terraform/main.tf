terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

}

provider "aws" {
  region = "us-east-1"
}

locals {
  instance_data = jsondecode(file("${path.module}/instances.json"))
}

resource "aws_key_pair" "ssh" {
  key_name = "ssh"
  # For Linux/Unix public_key = file("~/.ssh/id_ed25519.pub")
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_vpc" "main" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "main" {
  route_table_id         = aws_vpc.main.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_security_group" "allow_all" {
  name   = "allow_all"
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_instance" "examples" {
  count                  = length(local.instance_data["instances"])
  key_name               = aws_key_pair.ssh.key_name
  ami                    = local.instance_data["instances"][count.index]["ami"]
  instance_type          = local.instance_data["instances"][count.index]["instance_type"]
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  #user_data = file("userdata.sh")

  # Run init_script.sh -- currently installs node
  provisioner "remote-exec" {
    script = "${path.module}/init_script.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_ed25519")
      host        = self.public_ip
    }
  }

  tags = {
    Name = local.instance_data["instances"][count.index]["name"]
  }
}
