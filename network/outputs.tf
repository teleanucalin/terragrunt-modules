output "vpc_id" {
   value = aws_vpc.main.id
}

output "public_subnet_ids" {
   value = aws_subnet.public[*].id
}

output "web_subnet_ids" {
   value = aws_subnet.web[*].id
}

output "app_subnet_ids" {
   value = aws_subnet.app[*].id
}

output "data_subnet_ids" {
   value = aws_subnet.data[*].id
}

output "app_subnet_cidr" {
   value = aws_subnet.app[*].cidr_block
}

output "web_subnet_cidr" {
   value = aws_subnet.web[*].cidr_block
}

output "data_subnet_cidr" {
   value = aws_subnet.data[*].cidr_block
}
