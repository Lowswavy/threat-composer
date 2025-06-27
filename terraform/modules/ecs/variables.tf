variable "cluster_name" {}
variable "name_prefix" {}
variable "container_name" {}
variable "container_image" {}
variable "target_group_arn" {}
variable "container_port" {}
variable "subnet_ids" {
  type = list(string)
}
variable "vpc_id" {
  type        = string
}
variable "alb_security_group" {}
variable "operating_system_family" {
  description = "The operating system family"
  type        = string
  default     = "LINUX"
}

variable "cpu_architecture" {
  description = "The CPU architecture"
  type        = string
  default     = "ARM64" 
}