# The bucket names can't have any capitalized letters and must be globally unique
module "s3-crr" {
  source = "./s3-crr/"
  source_bucket_name = "source-bucket-ENTER-RANDOM-NUMBER"
  source_region = "us-east-1"
  dest_bucket_name = "replica-bucket-ENTER-RANDOM-NUMBER"
  dest_region = "us-west-2"
  replication_name = "my-replication-name"
}
