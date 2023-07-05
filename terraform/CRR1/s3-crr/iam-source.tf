data "aws_iam_policy_document" "source_writer" {
  statement {
    actions = [
      "S3:PutObject",
    ]
    resources = [
      local.source_bucket_object_arn,
    ]
  }

  statement {
    actions = [
      "S3:ListBucket",
    ]
    resources = [
      local.source_bucket_arn,
    ]
  }
}

resource "aws_iam_policy" "source_writer" {
  provider = aws.source
  name_prefix = "${local.replication_name}-source-write-"
  policy = data.aws_iam_policy_document.source_writer.json
}

resource "aws_iam_user" "source_writer" {
  provider = aws.source
  name = "${local.replication_name}-source-write-user"
  force_destroy = true  
}

resource "aws_iam_user_policy_attachment" "source_writer" {
  provider = aws.source
  user = aws_iam_user.source_writer.name
  policy_arn = aws_iam_policy.source_writer.arn
}

resource "aws_iam_access_key" "source_writer" {
provider = aws.source
user = aws_iam_user.source_writer.name
}