variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.16.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "172.16.1.0/24"
}

variable "availability_zone" {
  description = "AZ for the public subnet"
  type        = string
  default     = "us-east-1a"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0332d564d76dbd8d6"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "my_ip" {
  description = "IP allowed to SSH into the instance"
  type        = string
  #ip in Secrets
}
variable "runner_ip" {          # runner ip to open ssh on created ec2 instance
  description = "IP address of the GitHub Actions Runner"
  type        = string
}
variable "key_name" {
  description = "Name of the existing EC2 Key Pair (created manually in AWS Console, without .pem extension)"
  type        = string
  #import the key from Github secrets
}
