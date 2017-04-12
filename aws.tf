# This data source is necessary to get the current aws account id to set in
# the key policy
data "aws_caller_identity" "current" {}

provider "aws" {
  region = "${var.region}"
}

