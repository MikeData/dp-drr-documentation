
data "aws_iam_policy_document" "drr-iam-consumer-role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ],
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type = "Service"
    },
    effect = "Allow"
  }
}

resource "aws_iam_role" "drr-iam-consumer-assume-role" {
  name = "drr-consumer-role"

  assume_role_policy = "${data.aws_iam_policy_document.drr-iam-consumer-role.json}"
}


resource "aws_iam_instance_profile" "drr-iam-instance-profile-consumer" {
  name = "drr-iam-instance-profile-consumer"
  role = "${aws_iam_role.drr-iam-consumer-assume-role.id}"
}

# TODO - data source an task should be read. Result should be write
data "aws_iam_policy_document" "drr-iam-consumer-sqs" {
  statement {
    actions = [
      "sqs:SendMessage",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage"
    ]

    resources = [
      "${aws_sqs_queue.drr-data-source-queue.arn}",
      "${aws_sqs_queue.drr-task-queue.arn}",
      "${aws_sqs_queue.drr-result-queue.arn}",
    ]
  }
}


data "aws_iam_policy_document" "read-drr-import-bucket-policy" {
  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.drr-import-bucket.arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "drr-conumer-role-policy-sqs" {
  name   = "drr-iam-role-policy"
  role   = "${aws_iam_role.drr-iam-consumer-assume-role.id}"
  policy = "${data.aws_iam_policy_document.drr-iam-consumer-sqs.json}"
}

resource "aws_iam_role_policy" "drr-consumer-role-policy-s3" {
  name   = "drr-iam-role-policy"
  role   = "${aws_iam_role.drr-iam-consumer-assume-role.id}"
  policy = "${data.aws_iam_policy_document.read-drr-import-bucket-policy.json}"
}

resource "aws_instance" "drr-consumer-1" {
  ami                  = "ami-9cbe9be5"
  instance_type        = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.drr-iam-instance-profile-consumer.name}"
  key_name = "mike_ec2"

  tags {
    Name = "drr"
  }
}
