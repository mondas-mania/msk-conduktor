# Used for naming the bucket to avoid clashing names
resource "random_string" "bucket_random" {
  length  = 6
  special = false
  upper   = false
}

##########
# Bucket #
##########

# tfsec:ignore:aws-s3-enable-versioning
# tfsec:ignore:aws-s3-enable-bucket-logging
# tfsec:ignore:aws-s3-encryption-customer-key
# tfsec:ignore:aws-s3-enable-bucket-encryption
resource "aws_s3_bucket" "conduktor_monitoring_storage" {
  bucket = "conduktor-monitoring-${random_string.bucket_random.result}"
}

#################
# Public Access #
#################

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.conduktor_monitoring_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#################
# Bucket Policy #
#################
resource "aws_s3_bucket_policy" "allow_conduktor_access" {
  bucket = aws_s3_bucket.conduktor_monitoring_storage.id
  policy = data.aws_iam_policy_document.conduktor_bucket_policy.json
}

data "aws_iam_policy_document" "conduktor_bucket_policy" {
  statement {
    sid    = "ConduktorFullObjectAccess"
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = concat(
        var.additional_bucket_policy_principals,
        [aws_iam_role.conduktor_task_role.arn, ]
      )
    }

    actions = [
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:ListBucketVersions",
      "s3:ListBucket",
      "s3:PutObjectTagging",
      "s3:PutObjectVersionTagging",
    ]

    resources = [
      "arn:aws:s3:::conduktor-monitoring-${random_string.bucket_random.result}/*",
      "arn:aws:s3:::conduktor-monitoring-${random_string.bucket_random.result}",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}
