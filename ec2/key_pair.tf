resource "aws_key_pair" "key_pair" {
  key_name   = "${terraform.workspace}-key"
  public_key = file("./key_pair.pub")
}
