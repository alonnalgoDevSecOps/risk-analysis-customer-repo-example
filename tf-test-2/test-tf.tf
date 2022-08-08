
provider "aws" {
  version = "~> 2.0"
  region = "us-east-1"
  alias="east1"
  access_key = "AKIAXN5RHA6V72BJBJNF"
  secret_key = "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"
}


resource "aws_security_group" "AutoSecurityGroupSSHBase" {
  name        = "AutoSecurityGroup_SSH_test"
  description = "AutoSecurityGroup_SSH"
  vpc_id      = "vpc-014ba11d74c3fad72"
  provider="aws.east1"

  ingress {
    cidr_blocks=[
              "10.10.7.0/24",
              "10.9.0.0/16",
              "10.8.8.123/32",
              "10.8.8.156/32",
              "10.8.11.7/32",
              "31.154.25.138/32"
    ]
            description= "ssh incoming"
            from_port= "22"
            protocol= "tcp"
            to_port= "22"
  }
  egress{
    cidr_blocks= [
              "0.0.0.0/0"
            ]
            description= "ssh to anywhere"
            from_port= "22"
            protocol="tcp"
            to_port= "22"
  }
}