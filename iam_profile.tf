data "aws_iam_policy_document" "key_reader_policy" {
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      "${aws_kms_key.credstash_cmk.arn}"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]

    resources = [
      "${aws_dynamodb_table.store.arn}"
    ]
  }
}

data "aws_iam_policy_document" "key_writer_policy" {
  statement {
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey"
    ]
    resources = [
      "${aws_kms_key.credstash_cmk.arn}"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
        "dynamodb:PutItem"
    ]

    resources = [
      "${aws_dynamodb_table.store.arn}"
    ]
  }
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_policy" "read_credstash_store" {
  name        = "ReadCredstashStore${var.store_name == "" ? "" : "_${var.store_name}"}"
  description = "Read Credstash Store"
  policy      = "${data.aws_iam_policy_document.key_reader_policy.json}"
}

resource "aws_iam_policy" "write_credstash_store" {
  name        = "WriteCredstashStore${var.store_name == "" ? "" : "_${var.store_name}"}"
  description = "Write Credstash Store"
  policy      = "${data.aws_iam_policy_document.key_writer_policy.json}"
}

resource "aws_iam_role" "access_credstash_role" {
  name               = "access_credstash${var.store_name == "" ? "" : "_${var.store_name}"}"
  assume_role_policy = "${data.aws_iam_policy_document.ec2_assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "read_credstash_store" {
    role       = "${aws_iam_role.access_credstash_role.name}"
    policy_arn = "${aws_iam_policy.read_credstash_store.arn}"
}

resource "aws_iam_role_policy_attachment" "write_credstash_store" {
    role       = "${aws_iam_role.access_credstash_role.name}"
    policy_arn = "${aws_iam_policy.write_credstash_store.arn}"
}

resource "aws_iam_instance_profile" "access_credstash_iam_profile" {
  name  = "access_credstash${var.store_name == "" ? "" : "_${var.store_name}"}"
  roles = [
    "${aws_iam_role.access_credstash_role.name}",
  ]
}

