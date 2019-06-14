data "aws_subnet_ids" "pub" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Tier = "testing"
  }
}
