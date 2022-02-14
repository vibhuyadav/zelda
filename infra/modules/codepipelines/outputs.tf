output "codestar_connection_status" {
  value = one(aws_codestarconnections_connection.aws_codestarconnections_connection_github[*].connection_status)
}