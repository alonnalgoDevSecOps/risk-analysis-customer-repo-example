terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.31.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "google" {
  project = "cloudflow-qa-gcp1"
  region  = "us-east1"
  zone    = "us-east1-c"
}
provider "azurerm" {
  features {}
}

variable "for_test" {
  type    = string
  default = "test"
}

######################### AWS Start ##########################

resource "aws_cloudfront_distribution" "cloudfront_distribution" {

  enabled             = true
  retain_on_delete    = false
  is_ipv6_enabled     = false
  default_root_object = var.default_root_object

  logging_config {
    bucket = var.logging_bucket_domain_name
    prefix = var.logging_bucket_prefix
  }

  aliases     = var.aliases
  price_class = var.price_class

  origin {
    domain_name = var.webapp_s3_bucket
    origin_id   = "${var.webapp_s3_bucket}/cloudflow"
  }

  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.webapp_s3_bucket

    forwarded_values {
      query_string = var.query_string

      cookies {
        forward = var.cookies
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
  }

  restrictions {
    geo_restriction {
      restriction_type = var.restriction_type
      locations        = var.locations
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }
}

resource "aws_security_group" "devsecops_test" {
  name        = "devsecops_test"
  description = "Display devsecops "
  vpc_id      = "vpc-12345678"
  ingress {
    from_port   = 1080
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
    description = "web app"
  }

  egress {
    from_port   = 7654
    to_port     = 7655
    protocol    = "tcp"
    cidr_blocks = ["10.20.30.0/24"]
  }
  tags = {
    Name = "cool_application"
  }
}

resource "aws_security_group" "AutoSecurityGroupSSHBase" {
  name        = "AutoSecurityGroup_SSH_123"
  description = "AutoSecurityGroup_SSH"
  vpc_id      = "vpc-014ba11d74c3fad72"
  provider    = aws

  ingress {
    cidr_blocks = [
      "10.10.7.0/24",
      "10.9.0.0/16",
      "10.8.8.123/32",
      "10.8.8.156/32",
      "10.8.11.7/32",
      "31.154.25.138/32"
    ]
    description = "ssh incoming"
    from_port   = "22"
    protocol    = "tcp"
    to_port     = "22"
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups  = ["sg-0b132d6143ddd6435"]

  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "ssh to anywhere"
    from_port   = "22"
    protocol    = "tcp"
    to_port     = "22"
  }
}
resource "aws_security_group" "CommitFailures" {
  name        = "AutoSecurityGroup_CommitFailures_234"
  description = "AutoSecurityGroup_CommitFailures"
  vpc_id      = "vpc-014ba11d74c3fad72"
  provider    = aws

  ingress {
    cidr_blocks = [
      "10.10.0.0/16"
    ]
    description = "ssh incoming"
    from_port   = "22"
    protocol    = "tcp"
    to_port     = "22"
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "ssh to anywhere"
    from_port   = "22"
    protocol    = "tcp"
    to_port     = "22"
  }
}

resource "aws_security_group" "AutoSecurityGroupUnAssignedTest2" {
  name        = "AutoSecurityGroupUnAssignedTest2_345"
  description = "AutoSecurityGroupUnAssignedTest2"
  vpc_id      = "vpc-014ba11d74c3fad72"
  provider    = aws

  ingress {
    cidr_blocks = [
      "31.154.25.139/32"
    ]
    description = ""
    from_port   = 3389
    protocol    = "tcp"
    to_port     = 3389
  }
  ingress {
    cidr_blocks = [
      "10.9.8.9/32",
      "10.11.9.7/32"
    ]
    description = ""
    from_port   = -1
    protocol    = "icmp"
    to_port     = -1
  }
  egress {
    cidr_blocks = [
      "31.154.25.138/32"
    ]
    description = "#rk65j43po.Acg,mfr$56#@!(){}[]"
    from_port   = "7080"
    protocol    = "udp"
    to_port     = "7080"
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "custom tcp allow to any"
    from_port   = "8081"
    protocol    = "tcp"
    to_port     = "10002"
  }
  egress {
    ipv6_cidr_blocks = ["::/0"]
    description      = "custom tcp allow to any"
    from_port        = "8081"
    protocol         = "tcp"
    to_port          = "10002"
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "ssh allow"
    from_port   = "11000"
    protocol    = "udp"
    to_port     = "11000"
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "UDP 11000 allow"
    from_port   = "-1"
    protocol    = "icmp"
    to_port     = "-1"
  }
  ingress {
    cidr_blocks = [
      "31.154.25.138/32"
    ]
    description = "All TCP"
    from_port   = "0"
    protocol    = "tcp"
    to_port     = "65535"
  }
  egress {
    cidr_blocks = [
      "31.154.25.138/32"
    ]
    description = "387-389 allow to me"
    from_port   = "387"
    protocol    = "tcp"
    to_port     = "389"
  }


  egress {
    cidr_blocks = [
      "7.7.7.7/32"
    ]
    description = "ICMP all allow to 7.7.7.7"
    from_port   = "-1"
    protocol    = "icmp"
    to_port     = "-1"
  }

  ingress {
    cidr_blocks = [
      "10.12.14.15/32"
    ]
    description = "CMP_IPV6_rules"
    from_port   = "-1"
    protocol    = "icmpv6"
    to_port     = "-1"
  }

  ingress {
    cidr_blocks = [
      "31.154.25.138/32"
    ]
    description = "ICMP_Traceroute_to_MyIP"
    from_port   = "30"
    protocol    = "icmp"
    to_port     = "-1"
  }

  ingress {
    cidr_blocks = [
      "10.0.0.0/24",
      "10.0.3.0/24",
      "10.0.4.0/24"
    ]
    description = "UDP_Range_to_SubnetsAndIp"
    from_port   = "20000"
    protocol    = "udp"
    to_port     = "20124"
  }

  ingress {
    cidr_blocks = [
      "10.7.0.0/16"
    ]
    description = "ALL UDP"
    from_port   = "0"
    protocol    = "udp"
    to_port     = "65535"
  }
}

resource "aws_security_group" "AutoSecurityGroupUnAssignedTest3" {
  name        = "AutoSecurityGroupUnAssignedTest3_456"
  description = "AutoSecurityGroupUnAssignedTest3"
  vpc_id      = "vpc-014ba11d74c3fad72"
  provider    = aws

  ingress {
    cidr_blocks = [
      "31.154.25.138/32"
    ]
    description = ""
    from_port   = 3389
    protocol    = "tcp"
    to_port     = 3389
  }
  ingress {
    cidr_blocks = [
      "10.9.8.9/32",
      "10.11.9.7/32"
    ]
    description = ""
    from_port   = -1
    protocol    = "icmp"
    to_port     = -1
  }
  egress {
    cidr_blocks = [
      "31.154.25.138/32"
    ]
    description = "#rk65j43po.Acg,mfr$56#@!(){}[]"
    from_port   = "7080"
    protocol    = "udp"
    to_port     = "7080"
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "custom tcp allow to any"
    from_port   = "8081"
    protocol    = "tcp"
    to_port     = "10002"
  }
  egress {
    ipv6_cidr_blocks = ["::/0"]
    description      = "custom tcp allow to any"
    from_port        = "8081"
    protocol         = "tcp"
    to_port          = "10002"
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "ssh allow"
    from_port   = "11000"
    protocol    = "udp"
    to_port     = "11000"
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "UDP 11000 allow"
    from_port   = "-1"
    protocol    = "icmp"
    to_port     = "-1"
  }
  ingress {
    cidr_blocks = [
      "31.154.25.138/32"
    ]
    description = "All TCP"
    from_port   = "0"
    protocol    = "tcp"
    to_port     = "65535"
  }
  egress {
    cidr_blocks = [
      "31.154.25.138/32"
    ]
    description = "LDAP allow to me"
    from_port   = "389"
    protocol    = "tcp"
    to_port     = "389"
  }


  egress {
    cidr_blocks = [
      "7.7.7.7/32"
    ]
    description = "ICMP all allow to 7.7.7.7"
    from_port   = "-1"
    protocol    = "icmp"
    to_port     = "-1"
  }

  ingress {
    cidr_blocks = [
      "10.12.14.15/32"
    ]
    description = "CMP_IPV6_rules"
    from_port   = "-1"
    protocol    = "icmpv6"
    to_port     = "-1"
  }

  ingress {
    cidr_blocks = [
      "31.154.25.138/32"
    ]
    description = "ICMP_Traceroute_to_MyIP"
    from_port   = "30"
    protocol    = "icmp"
    to_port     = "-1"
  }

  ingress {
    cidr_blocks = [
      "10.0.0.0/24",
      "10.0.3.0/24"
    ]
    description = "UDP_Range_to_SubnetsAndIp"
    from_port   = "20000"
    protocol    = "udp"
    to_port     = "20124"
  }

  ingress {
    cidr_blocks = [
      "10.7.0.0/16"
    ]
    description = "ALL UDP"
    from_port   = "0"
    protocol    = "udp"
    to_port     = "65535"
  }
}
######################### AWS End ##########################

######################### GCP Start ##########################

resource "google_compute_firewall" "o01-ni-gcp" {
  name               = "o01-ni-gcp"
  network            = "terraform-network"
  direction          = "EGRESS"
  destination_ranges = ["192.168.1.1/32"]
  allow {
    protocol = "tcp"
  }
}

resource "google_compute_firewall" "o02-ni-gcp" {
  name               = "o02-ni-gcp"
  network            = "terraform-network"
  direction          = "EGRESS"
  destination_ranges = ["192.168.1.1/32"]
  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "o03-ni-gcp" {
  name               = "o03-ni-gcp"
  network            = "terraform-network"
  direction          = "EGRESS"
  destination_ranges = ["192.168.1.1/32"]
  allow {
    protocol = "udp"
  }
}

resource "google_compute_firewall" "o04-ni-gcp" {
  name               = "o04-ni-gcp"
  network            = "terraform-network"
  direction          = "EGRESS"
  destination_ranges = ["192.168.1.1/32"]
  allow {
    protocol = "tcp"
    ports    = ["135", "139", "445", "539"]
  }
}
resource "google_compute_firewall" "disabled-rule" {
  name               = "disabled-rule"
  network            = "network-with-disabled-rule"
  direction          = "EGRESS"
  destination_ranges = ["7.7.7.7/32"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  disabled = true
}

resource "google_service_account" "qa_auto_service_account" {
  account_id   = "qa-service-account-id"
  display_name = "QA Auto Service Account"
}

resource "google_compute_firewall" "qa-auto-service-account-rule" {
  name                    = "qa-auto-service-account-rule"
  network                 = "terraform-network"
  direction               = "EGRESS"
  target_service_accounts = ["qa-service-account-id@cloudflow-qa-gcp1.iam.gserviceaccount.com"]
  destination_ranges      = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["8888"]
  }
}
resource "google_compute_firewall" "risk-to-rule1" {
  name          = "risk-to-rule1"
  network       = "terraform-network"
  direction     = "INGRESS"
  source_ranges = ["192.168.1.1/32"]
  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "i02-ni-gcp" {
  name          = "i02-ni-gcp"
  network       = "terraform-network"
  direction     = "INGRESS"
  source_ranges = ["192.168.1.1/32"]
  allow {
    protocol = "tcp"
  }
}

resource "google_compute_firewall" "risk-to-rule2" {
  name          = "risk-to-rule2"
  network       = "terraform-network"
  direction     = "INGRESS"
  source_ranges = ["192.168.1.1/32"]
  allow {
    protocol = "udp"
  }
}

resource "google_compute_firewall" "i04-ni-gcp" {
  name          = "i04-ni-gcp"
  network       = "terraform-network"
  direction     = "INGRESS"
  source_ranges = ["192.168.1.1/32"]
  allow {
    protocol = "tcp"
    ports    = ["389"]
  }
  allow {
    protocol = "udp"
    ports    = ["389"]
  }
}

resource "google_compute_firewall" "i05-ni-gcp" {
  name          = "i05-ni-gcp"
  network       = "terraform-network"
  direction     = "INGRESS"
  source_ranges = ["192.168.1.1/32"]
  allow {
    protocol = "tcp"
    ports    = ["3020"]
  }
  allow {
    protocol = "udp"
    ports    = ["3020"]
  }
}
resource "google_compute_firewall" "i13-ni-gcp" {
  name          = "i13-ni-gcp"
  network       = "terraform-network"
  direction     = "INGRESS"
  source_ranges = ["192.168.1.1/32"]
  allow {
    protocol = "tcp"
    ports    = ["135", "139", "445", "593"]
  }
}
resource "google_compute_firewall" "i18-ni-gcp" {
  name          = "i18-ni-gcp"
  network       = "terraform-network"
  direction     = "INGRESS"
  source_ranges = ["192.168.1.1/32"]
  allow {
    protocol = "tcp"
    ports    = ["111"]
  }
  allow {
    protocol = "udp"
    ports    = ["111"]
  }
}

resource "google_compute_network" "network-with-disabled-rule" {
  auto_create_subnetworks = true
  name                    = "network-with-disabled-rule"
}


########################### GCP End ############################
########################### Azure Start ############################
resource "azurerm_resource_group" "example" {
  name     = "devsecops-resources"
  location = "East US"
}

resource "azurerm_virtual_network" "example" {
  name                = "devsecops-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = azurerm_resource_group.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "example" {
  name                = "devsecops-nsg"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

resource "azurerm_network_security_group" "example2" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "test1234"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}
resource "azurerm_network_security_rule" "testrules" {
  for_each                    = local.nsgrules
  name                        = each.key
  direction                   = each.value.direction
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.example.name
}
########################### Azure End ############################
