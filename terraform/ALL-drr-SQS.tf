resource "aws_sqs_queue" "drr-data-source-queue" {
  name = "drr-data-source-queue"

  tags {
    Name = "drr data source queue"
  }
}

resource "aws_sqs_queue" "drr-task-queue" {
  name = "drr-task-queue"

  tags {
    Name = "drr task queue"
  }
}

resource "aws_sqs_queue" "drr-result-queue" {
  name = "drr-result-queue"

  tags {
    Name = "drr result queue"
  }
}
