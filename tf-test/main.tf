provider "aws" {
  region = "us-east-1"
}

variable "for_test" {
  type    = string
  default = "test"
}

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
    from_port   = 80
    to_port     = 8082
    protocol    = "-1"
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
