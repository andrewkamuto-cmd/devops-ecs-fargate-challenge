output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "alb_url" {
  value = "http://${aws_lb.main.dns_name}"
}

output "frontend_ecr" {
  value = aws_ecr_repository.frontend.repository_url
}

output "backend_ecr" {
  value = aws_ecr_repository.backend.repository_url
}

output "ecs_cluster" {
  value = aws_ecs_cluster.main.name
}

output "frontend_service" {
  value = aws_ecs_service.frontend.name
}

output "backend_service" {
  value = aws_ecs_service.backend.name
}

output "dynamodb_table" {
  value = aws_dynamodb_table.waitlist.name
}

output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "jenkins_url" {
  value = "http://${aws_instance.jenkins.public_ip}:8080"
}