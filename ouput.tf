output "website_url" {
  value =  "http://${aws_s3_bucket.static-website-bucket.bucket}.s3-website.${var.region}.amazonaws.com"
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}