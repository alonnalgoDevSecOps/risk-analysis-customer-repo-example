variable "custom_domain_name" {
  description = "The domain name of the bucket using the s3 endpoint of the bucket's region afasdf"
  default     = "test-bucket"
}

variable "aliases" {
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution"
  type        = list(string)
  default     = []
}

variable "default_root_object" {
  description = "The object that you want CloudFront to return (for example, index.html) when an user requests the root URL"
  default     = "index.html"
}

variable "logging_bucket_domain_name" {
  description = "The S3 bucket to store the access logs in, for example, myawslogbucket"
  default     = ""
}

variable "logging_bucket_prefix" {
  description = "An optional prefix key that you want CloudFront to use when writing to the logging bucket, for example, myprefix/"
  default     = "logs"
}

variable "allowed_methods" {
  description = "Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin"
  type        = list(string)
  default     = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
}

variable "allowed_methods_choice" {
  description = "Select which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin"
  default     = "1"
}

variable "query_string" {
  description = "Indicates whether you want CloudFront to forward query strings to the origin"
  default     = false
}

variable "cookies" {
  description = "The forwarded values cookies that specifies how CloudFront handles cookies: all, none or whitelist"
  default     = "none"
}

variable "viewer_protocol_policy" {
  description = "Protocol to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern. One of allow-all, https-only, or redirect-to-https."
  default     = "allow-all"
}

variable "min_ttl" {
  description = "The minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated."
  default     = "0"
}

variable "default_ttl" {
  description = "The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header"
  default     = "3600"
}

variable "max_ttl" {
  description = "The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated."
  default     = "86400"
}

variable "price_class" {
  description = "Price classes provide you an option to lower the prices you pay to deliver content out of Amazon CloudFront. One of PriceClass_All, PriceClass_200, PriceClass_100"
  default     = "PriceClass_All"
}

variable "restriction_type" {
  description = "The method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist."
  default     = "none"
}

variable "cloudfront_default_certificate" {
  description = "Want your viewers to use HTTPS to request your objects and you're using the CloudFront domain name for your distribution. Select true or specify iam_certificate_id"
  default     = "true"
}

variable "acm_certificate_arn" {
  description = "The IAM certificate identifier of the custom viewer certificate for this distribution if you are using a custom domain."
  default     = ""
}

variable "locations" {
  type        = list(string)
  description = "The list of ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content (whitelist) or not distribute your content (blacklist)."
  default     = []
}

variable "cf_log_bucket" {
  description = "The bucket used for logs storing"
  default     = ""
}

variable "origin_path" {
  description = "The origin path"
  default     = ""
}

variable "webapp_s3_bucket" {
  description = "S3 bucket name for webapp deploy"
  default     = "this-is-a-test"
}
