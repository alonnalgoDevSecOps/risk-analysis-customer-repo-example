terraform {
  backend "s3" {
    bucket  = "cloudflow-terraform-state"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    profile = "cloudflowdev"
  }
}

variable "for_test" {
  type    = string
  default= "test"
}

variable "offices_external_ips" {
  type    = list(string)
  default = ["86.57.155.118/32", "31.154.25.138/32", "178.124.194.54/32", "18.184.229.113/32", "31.154.25.138/32", "18.184.110.55/32"]
}

variable "users_external_ips1" {
  type    = list(string)
  default = ["86.57.155.118/32", "31.154.25.138/32", "178.124.194.54/32", "18.184.229.113/32", "31.154.25.138/32", "18.184.110.55/32", "103.233.242.0/24", "104.192.136.0/21", "13.228.96.17/32", "13.236.225.70/32", "13.236.240.218/32", "13.236.240.90/32", "13.236.8.128/25", "13.237.203.34/32", "13.237.22.210/32", "13.237.238.24/32", "13.52.5.0/25", "13.54.202.141/32", "13.55.123.56/32", "13.55.145.74/32", "13.55.180.21/32", "18.136.214.0/25", "18.184.99.128/25", "18.194.141.203/32", "18.195.138.66/32", "18.195.94.34/32", "18.196.34.74/32", "18.205.93.0/27", "18.234.32.128/25", "18.246.31.128/25", "185.166.140.0/22", "3.0.33.124/32", "34.192.15.175/32", "34.198.178.64/32", "34.198.203.127/32", "34.198.210.246/32"]
}

variable "users_external_ips2" {
  type    = list(string)
  default = ["34.198.211.97/32", "34.198.32.85/32", "34.199.54.113/32", "34.208.209.12/32", "34.208.237.45/32", "34.208.39.80/32", "34.216.18.129/32", "34.218.156.209/32", "34.218.168.212/32", "34.232.119.183/32", "34.232.25.90/32", "34.236.25.177/32", "34.252.194.82/32", "35.155.178.254/32", "35.156.237.182/32", "35.160.117.30/32", "35.160.177.10/32", "35.161.3.151/32", "35.162.23.98/32", "35.162.54.42/32", "35.164.29.75/32", "35.166.83.147/32", "35.167.86.65/32", "35.171.175.212/32", "52.202.195.162/32", "52.203.14.55/32", "52.204.96.37/32", "52.214.35.33/32", "52.215.192.128/25", "52.220.133.35/32", "52.41.219.63/32", "52.51.80.244/32", "52.52.234.127/32", "52.54.90.98/32", "52.57.143.159/32", "52.63.74.64/32", "52.63.91.5/32", "52.77.104.229/32", "52.77.194.221/32", "52.77.70.205/32", "52.8.252.137/32", "52.8.84.222/32", "52.9.41.1/32", "54.72.233.229/32", "54.76.3.75/32", "54.77.145.185/32"]
}

variable "ecr_registries" {
  type    = list(string)
  default = ["cac", "ceda", "risk", "security", "monitor", "admin", "notify", "policy"]
}

variable "remote_jenkins_policies" {
  type    = list(string)
  default = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess", "arn:aws:iam::aws:policy/AmazonS3FullAccess", "arn:aws:iam::aws:policy/CloudFrontFullAccess", "arn:aws:iam::aws:policy/AmazonCognitoPowerUser", "arn:aws:iam::aws:policy/AmazonSSMFullAccess", "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator"]
}

provider "aws" {
  region  = "us-east-1"
  profile = "cloudflowdev"
}

resource "aws_instance" "jenkins-master" {
  ami                     = "ami-00a0ec1744b47e7e3"
  instance_type           = "t3.small"
  availability_zone       = "us-east-1a"
  cpu_core_count          = 1
  cpu_threads_per_core    = 2
  disable_api_termination = false
  ebs_block_device {
    delete_on_termination = false
    device_name           = "/dev/sdb"
    encrypted             = false
    iops                  = 100
    volume_size           = 10
    volume_type           = "gp2"
  }
  ebs_optimized     = true
  get_password_data = false
  key_name          = "operations"
  monitoring        = false
  root_block_device {
    delete_on_termination = true
    iops                  = 100
    volume_size           = 30
    volume_type           = "gp2"
  }
  source_dest_check      = true
  subnet_id              = "subnet-8f305ca1"
  tenancy                = "default"
  vpc_security_group_ids = [aws_security_group.jenkins_master1.id, aws_security_group.jenkins_master2.id]
  tags = {
    Name          = "jenkins_master",
    "Environment" = "dev"
  }
}

resource "aws_eip" "lb" {
  instance = aws_instance.jenkins-master.id
  vpc      = true
  tags = {
    Name = "jenkins_master"
  }
  depends_on = [aws_instance.jenkins-master]
}

resource "aws_route_table" "jenkins_master" {
  route {
    cidr_block                = "0.0.0.0/0"
    gateway_id                = "igw-ccf617b7"
    instance_id               = ""
    ipv6_cidr_block           = ""
    nat_gateway_id            = ""
    network_interface_id      = ""
    transit_gateway_id        = ""
    vpc_peering_connection_id = ""
  }
  route {
    cidr_block                = "172.22.0.0/16"
    vpc_peering_connection_id = "pcx-0b4fda828602dd55a"
  }
  tags = {
    "Name" = "Jenkins"
  }
  vpc_id = "vpc-236cde59"
}


resource "aws_security_group" "jenkins_master1" {
  name        = "jenkins_master1"
  description = "Access rules for Jenkins server"
  vpc_id      = "vpc-236cde59"

  ingress {
    from_port   = 3422
    to_port     = 3422
    protocol    = "tcp"
    cidr_blocks = var.offices_external_ips
    description = "Ssh port 3422"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Outgoing traffic"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.users_external_ips1
    description = "Jenkins port 8080 for office and Atlassian"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.22.0.0/16"]
    description = "internal traffic"

  }

  tags = {
    Name = "jenkins_master1"
  }
}

resource "aws_security_group" "jenkins_master2" {
  name        = "jenkins_master2"
  description = "Access rules for Jenkins server 2"
  vpc_id      = "vpc-236cde59"
  ingress {
    from_port   = 6080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.users_external_ips2
    description = "Jenkins port 8080 for Atlassian 2"
  }
  tags = {
    Name = "jenkins_master2"
  }
}

resource "aws_security_group" "jenkins_slave" {
  name        = "jenkins_slave"
  description = "Access rules for Jenkins slave"
  vpc_id      = "vpc-236cde59"
  ingress {
    from_port   = 3422
    to_port     = 3422
    protocol    = "tcp"
    cidr_blocks = var.offices_external_ips
    description = "Jenkins port 3422"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Outgoing traffic"
  }

  ingress {
    from_port   = 3422
    to_port     = 3422
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
    description = "Internal ssh port 3422"
  }

  tags = {
    Name = "jenkins_slave"
  }
}

##### To remove later block 

#resource aws_vpc_peering_connection jenkins_to_eks {
#  peer_vpc_id = "vpc-0945f0fe1a4e140b8"
#  tags = {
#    Name = "Jenkins-To-EKS"
#  }
#  vpc_id = "vpc-236cde59"
#}

#resource aws_security_group EKS-dev-demo-worker-nodes-SG-new {
#  description = "Security group for all nodes in the cluster"
#  name = "EKS-dev-demo-worker-nodes-SG-new"
#  tags = {
#    "Name" = "EKS-dev-demo-worker-nodes-SG-new",
#    "kubernetes.io/cluster/dev-demo" = "owned"
#  }
#  vpc_id = "vpc-0945f0fe1a4e140b8"
#  egress {
#    cidr_blocks = ["0.0.0.0/0"]
#    from_port   = 0
#    protocol    = "-1"
#    to_port     = 0
#  }
#
#  ingress {
#    cidr_blocks = ["172.20.0.0/16","192.168.255.0/24","172.31.0.0/16"]
#    from_port   = 0
#    protocol    = "-1"
#    to_port     = 0
#  }
#
#  ingress {
#    cidr_blocks = ["0.0.0.0/0"]
#    description = "kubernetes.io/rule/nlb/mtu=a81fa3551ee3a11e896b802ecc3a5f51"
#    from_port   = 3
#    protocol    = "icmp"
#    to_port     = 4
#  }
#
#  ingress {
#    description     = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
#    from_port       = 1025
#    protocol        = "tcp"
#    security_groups = ["sg-0d3166782a9dde252"]
#    to_port         = 65535
#  }
#
#  ingress {
#    description     = "Allow node to communicate with each other"
#    security_groups = ["sg-0e37bcea696f6363e"]
#    from_port       = 0
#    protocol        = "-1"
#    to_port         = 0
#  }
#}

resource "aws_security_group" "EKS-dev-demo-cluster-SG-new" {
  description = "Cluster communication with worker nodes"
  tags = {
    Name = "EKS-dev-demo-cluster-SG-new"
  }
  vpc_id = "vpc-0945f0fe1a4e140b8"
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
  ingress {
    description     = "Allow pods to communicate with the cluster API Server"
    from_port       = 443
    protocol        = "tcp"
    security_groups = ["sg-0e37bcea696f6363e"]
    to_port         = "443"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow workstation to communicate with the cluster API Server"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }
}

resource "aws_iam_role" "remote_jenkins" {
  name                  = "remote_jenkins"
  assume_role_policy    = <<EOF
{
  "Version":"2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Principal":{
        "AWS": "arn:aws:iam::632452247192:role/remote_jenkins"
      },
      "Action":"sts:AssumeRole",
      "Condition":{}
    }
  ]
}
EOF
  description           = "as-remote role jenkins"
  force_detach_policies = false
  max_session_duration  = 3600
  path                  = "/"
}

resource "aws_iam_role_policy_attachment" "remote_jenkins_attach" {
  count      = 6
  role       = aws_iam_role.remote_jenkins.name
  policy_arn = element(var.remote_jenkins_policies, count.index)
}

resource "aws_iam_instance_profile" "remote_jenkins" {
  name = "remote_jenkins"
  role = aws_iam_role.remote_jenkins.name
}

##### To remove later block 

resource "aws_instance" "jenkins_slave" {
  ami                         = "ami-02eac2c0129f6376b"
  instance_type               = "t3a.large"
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.remote_jenkins.name
  ebs_block_device {
    delete_on_termination = false
    device_name           = "/dev/sdb"
    encrypted             = false
    iops                  = 100
    volume_size           = 10
    volume_type           = "gp2"
  }
  ebs_optimized     = true
  get_password_data = false
  key_name          = "operations"
  monitoring        = false
  root_block_device {
    delete_on_termination = true
    iops                  = 100
    volume_size           = 30
    volume_type           = "gp2"
  }
  source_dest_check      = true
  subnet_id              = "subnet-8f305ca1"
  tenancy                = "default"
  vpc_security_group_ids = [aws_security_group.jenkins_slave.id]
  tags = {
    "Name"        = "jenkins_slave1",
    "Environment" = "dev"
  }
}

resource "aws_instance" "jenkins_slave2" {
  ami                         = "ami-02eac2c0129f6376b"
  instance_type               = "t3a.large"
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.remote_jenkins.name
  ebs_block_device {
    delete_on_termination = false
    device_name           = "/dev/sdb"
    encrypted             = false
    iops                  = 100
    volume_size           = 10
    volume_type           = "gp2"
  }
  ebs_optimized     = true
  get_password_data = false
  key_name          = "operations"
  monitoring        = false
  root_block_device {
    delete_on_termination = true
    iops                  = 100
    volume_size           = 30
    volume_type           = "gp2"
  }
  source_dest_check      = true
  subnet_id              = "subnet-8f305ca1"
  tenancy                = "default"
  vpc_security_group_ids = [aws_security_group.jenkins_slave.id]
  tags = {
    "Name"        = "jenkins_slave2",
    "Environment" = "dev"
  }
}

resource "aws_instance" "jenkins_slave3" {
  ami                         = "ami-02eac2c0129f6376b"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.remote_jenkins.name
  ebs_block_device {
    delete_on_termination = false
    device_name           = "/dev/sdb"
    encrypted             = false
    iops                  = 100
    volume_size           = 10
    volume_type           = "gp2"
  }
  ebs_optimized     = false
  get_password_data = false
  key_name          = "operations"
  monitoring        = false
  root_block_device {
    delete_on_termination = true
    iops                  = 100
    volume_size           = 30
    volume_type           = "gp2"
  }
  source_dest_check      = true
  subnet_id              = "subnet-05950988b4639a917"
  tenancy                = "default"
  vpc_security_group_ids = [aws_security_group.jenkins_slave.id]
  tags = {
    "Name"        = "jenkins_slave3_prod",
    "Environment" = "prod"
  }
}
resource "aws_ecr_repository" "algosec_dev" {
  count = 8
  name  = element(var.ecr_registries, count.index)
}
