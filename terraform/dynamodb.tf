resource "aws_dynamodb_table" "waitlist" {
  name         = "${var.project_name}-waitlist"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "${var.project_name}-waitlist"
  }
}