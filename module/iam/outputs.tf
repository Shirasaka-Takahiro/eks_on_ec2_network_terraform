output "iam_role_arn" {
  value = aws_iam_role.default.arn
}

output "iam_policy_attachment_name" {
  value = aws_iam_policy_attachment.default.name
}