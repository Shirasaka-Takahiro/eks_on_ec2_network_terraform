output "instance_id" {
  value = aws_instance.default.id
}

output "key_pair" {
  value = aws_key_pair.key
}