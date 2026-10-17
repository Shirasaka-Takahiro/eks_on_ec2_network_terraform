##IAM Role
resource "aws_iam_role" "default" {
  name               = "${var.general_config["project"]}-${var.general_config["env"]}-${var.role_name}"
  assume_role_policy = var.role_json
}

##IAM Role Policy
resource "aws_iam_policy" "default" {
  name   = "${var.general_config["project"]}-${var.general_config["env"]}-${var.policy_name}"
  policy = var.policy_json
}

##IAM  Attachment Policy to Role
resource "aws_iam_policy_attachment" "default" {
  name       = "${var.general_config["project"]}-${var.general_config["env"]}-attach-policy-to-role"
  roles      = [aws_iam_role.default.name]
  policy_arn = aws_iam_policy.default.arn
}