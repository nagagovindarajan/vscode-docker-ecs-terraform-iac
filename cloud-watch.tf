resource "aws_cloudwatch_log_group" "vscode" {
  name              = "vscode-log"
  retention_in_days = 7
}