provider "aws" {
  region  = var.region
}

data "aws_vpc" "vpc-seesquared" {
  filter {
    name = "tag:Name"
    values = ["SeeSquared-us-west-2-vpc"]
  }
}

module "ec2vm" {
  source = "./module-ec2"
  vpc_id            = data.aws_vpc.vpc-seesquared.id
  name              = "${var.app}-vm"
  tags              = { Owner = "conrad.corbett@hashicorp.com", Environment = "test", Name = "${var.app}-vm" }
  public_key        = data.aws_key_pair.aws_key.key_name
}