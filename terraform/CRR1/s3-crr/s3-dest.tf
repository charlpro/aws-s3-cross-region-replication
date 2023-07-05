data "aws_iam_policy_document" "dest_bucket_policy" {
  statement {
    sid = "replicate-objects-from-$(data.aws_caller_identity.source.account_id)-to-prefix-$(var.replicate_prefix}"
      
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ObjectOwnerOverrideToBucketOwner",
    ]
      
    resources = [
      local.dest_bucket_object_arn,
    ]

    principals {
      type = "AWS"
    
      identifiers = [
        local.source_root_user_arn,
      ]
    }
  }
}

resource "aws_s3_bucket" "dest" {
  count = var.create_dest_bucket == "true" ? 1 : 0
  provider = aws.dest
  bucket = var.dest_bucket_name
  policy = data.aws_iam_policy_document.dest_bucket_policy.json
}

resource "aws_s3_bucket_versioning" "dest_versioning" {
  bucket = aws_s3_bucket.dest[0].id
  provider = aws.dest
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.dest[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}


