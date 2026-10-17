output "node_group_lauch_template_id" {
  value = aws_launch_template.default.id
}

output "node_group_lauch_template_latest_version" {
  value = aws_launch_template.default.latest_version
}
