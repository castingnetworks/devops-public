output "this_arn" {
  value = aws_sfn_state_machine.state_machine.id
}

output "this_creation_date" {
  value = aws_sfn_state_machine.state_machine.creation_date
}

output "this_status" {
  value = aws_sfn_state_machine.state_machine.status
}
