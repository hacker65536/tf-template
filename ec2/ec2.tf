locals {
  instance_type = "t2.micro"
}

locals {
  os = {
    amz2     = data.aws_ami.amazonlinux2.id
    amz      = data.aws_ami.amazonlinux.id
    cent7    = data.aws_ami.centos7.id
    cent6    = data.aws_ami.centos6.id
    ubuntu18 = data.aws_ami.ubuntu18.id
  }
}
resource "aws_instance" "ec2" {
  count                  = length(local.os)
  instance_type          = local.instance_type
  key_name               = aws_key_pair.key_pair.key_name
  ami                    = element(values(local.os), count.index)
  subnet_id              = tolist(data.aws_subnet_ids.pub.ids)[0]
  vpc_security_group_ids = [data.aws_security_group.def.id]
  volume_tags            = local.tags

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "20"
    delete_on_termination = true
  }

  tags = merge(
    local.tags,
    map("Name", "${terraform.workspace}-${element(keys(local.os), count.index)}"),
  )
}


output "sub" {
  value = tolist(data.aws_subnet_ids.pub.ids)[0]
}
output "ips" {
  #  value = aws_instance.ec2[*].private_ip
  value = {
    for inst in aws_instance.ec2 :
    inst.tags["Name"] => inst.private_ip
  }
}
