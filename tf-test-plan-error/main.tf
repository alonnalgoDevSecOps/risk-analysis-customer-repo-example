resource "aws_cloudfront_distribution" "cloudfront_distribution" {

  enabled             = true
  retain_on_delete    = false
  is_ipv6_enabled     = false
  default_root_object = "${var.default_root_object}"

  logging_config {
    bucket          = "${var.logging_bucket_domain_name}"
    prefix          = "${var.logging_bucket_prefix}"
  }

  aliases = "${var.aliases}"
  price_class = "${var.price_class}"

  origin {
    domain_name = "${var.webapp_s3_bucket}"
    origin_id   = "${var.webapp_s3_bucket}/cloudflow"
  }

/*  origin {
    domain_name = "${var.custom_domain_name}"
    origin_id = "${var.custom_domain_name}/cloudflow"
    origin_path = "${var.origin_path}"

    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port = "80"
      https_port = "443"
      origin_ssl_protocols = [
        "TLSv1.2",
        "TLSv1.1",
        "TLSv1"]
    }
  }
*/
  default_cache_behavior {
    allowed_methods = "${var.allowed_methods}"
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.webapp_s3_bucket}"

    forwarded_values {
      query_string = "${var.query_string}"

      cookies {
        forward = "${var.cookies}"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = "${var.min_ttl}"
    default_ttl            = "${var.default_ttl}"
    max_ttl                = "${var.max_ttl}"
  }

/*  ordered_cache_behavior {
    path_pattern     = "/api/*"
    allowed_methods  = "${var.allowed_methods}"
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.custom_domain_name}"

    forwarded_values {
      query_string = "${var.query_string}"

      cookies {
        forward = "${var.cookies}"
      }
    }

    min_ttl                = "${var.min_ttl}"
    default_ttl            = "${var.default_ttl}"
    max_ttl                = "${var.max_ttl}"
    viewer_protocol_policy = "redirect-to-https"
  } */

  restrictions {
    geo_restriction {
      restriction_type = "${var.restriction_type}"
      locations        = "${var.locations}"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${var.acm_certificate_arn}"
    ssl_support_method = "sni-only"
  }
}


