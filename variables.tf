variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-south-1" # Default AWS region
}

variable "subnets" {
  description = "List of subnet IDs"
  type        = list(string)
  default     = ["subnet-06d6437824c554b71", "subnet-0ca3ef571d0d92dc8", "subnet-0a6ad544060f0c08c"] # Replace with your actual subnet IDs
}

variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
  default     = ["sg-0d7c9a80b869b0b74"] # Replace with your actual security group ID(s)
}
