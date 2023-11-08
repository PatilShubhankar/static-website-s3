#s3 static website bucket 

resource "aws_s3_bucket" "static-website-bucket" {
  bucket = "subhankar-portfolio-bucket"
  tags = {
    Name = "Static website bucket"
  }
}


resource "aws_s3_bucket_website_configuration" "my-static-website-config" {
  bucket = aws_s3_bucket.static-website-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_versioning" "my-s3-bucket-versioning" {
  bucket = aws_s3_bucket.static-website-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "my-static-website-control" {
  bucket = aws_s3_bucket.static-website-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "my-static-website" {
  bucket = aws_s3_bucket.static-website-bucket.id
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "my-static-website-bucket-acl" {
  acl = "public-read"
  bucket = aws_s3_bucket.static-website-bucket.id
  depends_on = [ aws_s3_bucket_ownership_controls.my-static-website-control, aws_s3_bucket_public_access_block.my-static-website ]
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.static-website-bucket.id
  policy = <<POLICY
{
  "Id": "Policy",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.static-website-bucket.bucket}/*",
      "Principal": {
        "Service": "cloudfront.amazonaws.com"
      }
    }
  ]
}
POLICY
}
