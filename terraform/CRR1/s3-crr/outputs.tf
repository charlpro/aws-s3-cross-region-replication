output "dest_bucket_policy_json" {
  value = var.create_dest_bucket == "true" ? "not needed" : data.aws_iam_policy_document.dest_bucket_policy.json
}

output "source_write_iam_user_access_key_id" {
  value = aws_iam_access_key.source_writer.id
}

output "source_write_iam_user_secret_access_key" {
  value = aws_iam_access_key.source_writer.secret
  sensitive = true
}