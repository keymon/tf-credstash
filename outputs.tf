// KMS Key ID for the generated CMK
output "kms_key_id" {
  value = "${aws_kms_key.credstash_cmk.key_id}"
}

// ARN for the generated dynamodb table
output "dynamo_table_arn" {
  value = "${aws_dynamodb_table.store.arn}"
}

// ID for the generated iam profile
output "aws_iam_profile_id" {
  value = "${aws_iam_instance_profile.access_credstash_iam_profile.id}"
}
