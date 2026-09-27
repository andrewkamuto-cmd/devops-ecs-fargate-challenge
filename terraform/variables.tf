variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "project_name" {
  type    = string
  default = "andrews"
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "admin_cidr" {
  description = "Your public IP address in CIDR format"
  type        = string
}

variable "public_key_path" {
  description = "Absolute path to the Jenkins SSH public key"
  type        = string
}

variable "private_key_path" {
  description = "Absolute path to the Jenkins SSH private key"
  type        = string
}

variable "bootstrap" {
  description = "Keep ECS services at zero until initial Docker images exist"
  type        = bool
  default     = true
}

variable "min_tasks" {
  type    = number
  default = 1
}

variable "max_tasks" {
  type    = number
  default = 4
}

variable "cpu_target" {
  type    = number
  default = 50
}