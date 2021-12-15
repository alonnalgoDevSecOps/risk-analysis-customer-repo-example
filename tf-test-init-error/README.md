# Terraform Module - CloudFront Distribution

## Overview

Generic module for creating a CloudFront Distribution.

### Variables

* `bucket_name` - Name of the bucket that will be used as origin for this CloudFront distribution.
* `aliases` - Extra CNAMEs (alternate domain names), if any, for this distribution.
* `default_root_object` - The object that you want CloudFront to return (for example, index.html) when an user requests the root URL.
* `logging_bucket_name` - The S3 bucket to store the access logs in, for example, myawslogbucket.
* `logging_bucket_prefix` - An optional prefix key that you want CloudFront to use when writing to the logging bucket, for example, `myprefix/`.
* `allowed_methods` - Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin.
* `query_string` - Indicates whether you want CloudFront to forward query strings to the origin.
* `cookies` - The forwarded values cookies that specifies how CloudFront handles cookies: `all`, `none` or `whitelist`.
* `viewer_protocol_policy` - Protocol to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern. One of allow-all, https-only, or redirect-to-https.
* `min_ttl` - The minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated.
* `default_ttl` - The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header.
* `max_ttl` - The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated.
* `price_class` - Price classes provide you an option to lower the prices you pay to deliver content out of Amazon CloudFront. One of PriceClass_All, PriceClass_200, PriceClass_100.
* `restriction_type` - The method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist.
* `cloudfront_default_certificate` - Want your viewers to use HTTPS to request your objects and you're using the CloudFront domain name for your distribution. Select true or specify iam_certificate_id.
* `iam_certificate_id` - The IAM certificate identifier of the custom viewer certificate for this distribution if you are using a custom domain.
* `locations` - The list of ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content (whitelist) or not distribute your content (blacklist).

### Resources Created

* CloudFront Distribution
* CloudFront Origin Access Identity
* Bucket policy to control the Origin Access Identity

### Outputs

* `domain_name` - CloudFront Distribution Domain Name.

## Prerequisites and Dependencies

* **Developed on Terraform 0.9.1**

## Usage

This module should be declared as a Terraform module in your main `.tf` file. Example:

    module "<tf-module-cloudfront-distribution>" {
      source = "git::ssh://git@bitbucket.org/emindsys/tf-module-cloudfront-distribution.git"
      
      bucket_name              = "${var.bucket_name}"
      logging_bucket_name      = "${var.logging_bucket_name}"
    } 

## Maintainer

This module is maintained by [Virgil Niculescu](mailto:virgil.niculescu@allcloud.io).
