locals {
  instance_type = "t2.micro"
}
data "aws_ami" "amazonlinux2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20*x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "ec2" {
  instance_type = local.instance_type
  key_name      = aws_key_pair.key_pair.key_name
  ami           = data.aws_ami.amazonlinux2.id

  subnet_id = ""

  volume_tags = local.tags

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "20"
    delete_on_termination = true
  }

  tags = merge(
    local.tags,
    map("Name", "${terraform.workspace}-ec2"),
  )
}

