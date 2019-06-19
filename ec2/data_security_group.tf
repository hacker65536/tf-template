data "aws_security_group" "def" {
  vpc_id = "${data.aws_vpc.vpc.id}"
  name   = "default"
  /*
  filter {
    name   = "tag-key"
    values = ["sg"]
  }

  filter {
    name   = "tag-value"
    values = ["sec"]
  }
	*/
}

