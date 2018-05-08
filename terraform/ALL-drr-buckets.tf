resource "aws_s3_bucket" "drr-import-bucket" {
  bucket = "drr-import-bucket"

  tags {
    Name        = "drr"
  }
}
