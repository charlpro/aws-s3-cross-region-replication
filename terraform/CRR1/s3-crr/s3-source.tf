data "aws_iam_policy_document" "source_replication_role" {
  statement {
    actions = ["sts:AssumeRole"]
  
    principals {
      type = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "source_replication_policy" {
  statement {
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
    ]

    resources = [
      local.source_bucket_arn,
    ]
  }

  statement {
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
    ]

    resources = [
      local.source_bucket_object_arn,
    ]
  }

  statement {
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ObjectOwnerOverrideToBucketOwner",
    ]

    resources = [
      local.dest_bucket_object_arn,
    ]
  }
}

resource "aws_iam_role" "source_replication" {
  provider = aws.source
  name = "${local.replication_name}-replication-role"
  assume_role_policy = data.aws_iam_policy_document.source_replication_role.json
}

resource "aws_iam_policy" "source_replication" {
  provider = aws.source
  name = "${local.replication_name}-replication-policy"
  policy = data.aws_iam_policy_document.source_replication_policy.json
}

resource "aws_iam_role_policy_attachment" "source_replication" {
  provider = aws.source
  role = aws_iam_role.source_replication.name
  policy_arn = aws_iam_policy.source_replication.arn
}

resource "aws_s3_bucket" "source" {
  provider = aws.source
  bucket = var.source_bucket_name
}

resource "aws_s3_bucket_versioning" "source_versioning" {
  bucket = aws_s3_bucket.source.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  provider = aws.source
  depends_on = [aws_s3_bucket_versioning.source_versioning, aws_s3_bucket_versioning.dest_versioning]

  role   = aws_iam_role.source_replication.arn
  bucket = aws_s3_bucket.source.id
  rule {
    id = local.replication_name
    priority = var.priority
    prefix = var.replicate_prefix
    status = "Enabled"
    destination {
      bucket = local.dest_bucket_arn
      storage_class = "STANDARD"

      access_control_translation {
        owner = "Destination"
      }

      account = data.aws_caller_identity.dest.account_id
    }
  }
}


