output "endpoint" {
  value = aws_elasticsearch_domain.this.endpoint
}

output "username" {
  value = random_string.this.result
}

 # output "password" {
 #   value = random_password.this.result
 # }
