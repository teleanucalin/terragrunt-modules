output "core_primary_db_parameter_group" {
   value = aws_db_parameter_group.core_primary
}

output "core_db_subnet_group" {
   value = aws_db_subnet_group.core
}
