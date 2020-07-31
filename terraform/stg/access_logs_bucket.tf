resource "random_pet" "access_logs" {
  length = 3
}

resource "aws_s3_bucket" "access_logs" {
  bucket        = "${local.env}-access-logs-${random_pet.access_logs.id}"
  acl           = "private"
  force_destroy = true # to make it easier to destroy at this repository example
}

resource "aws_s3_bucket_policy" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id
  policy = data.aws_iam_policy_document.access_logs.json
}

data "aws_iam_policy_document" "access_logs" {
  # Allow from Elastic Load Balancing account in ap-northeast-1
  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.access_logs.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::582318560864:root"]
    }
  }
}