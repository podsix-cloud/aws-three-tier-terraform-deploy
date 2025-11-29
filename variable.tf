variable "vpc_cidrblock" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/16"
  
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "production"
  
}

variable "create_subnet" {
  description = "Flag to create a subnet"
  type        = bool
  default     = true
}

variable "countsub" {
  description = "Number of subnets to create"
  type        = number
  default     = 2
  
}
variable "create_elastic_ip" {
  description = "Flag to create Elastic IPs"
  type        = bool
  default     = true
}


variable "desired_size" {
  description = "Desired size of the EKS node group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum size of the EKS node group"
  type        = number
  default     = 6
}

variable "min_size" {
  description = "Minimum size of the EKS node group"
  type        = number
  default     = 2 
}

variable "instance_types" {
  description = "Instance types for the EKS node group"
  type        = list(string)
  default     = ["t3.medium"]    
} 

variable "capacity_type" {
  description = "Capacity type for the EKS node group"
  type        = string
  default     = "ON_DEMAND"
}
variable "eks_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.34"
}
variable "ami_type" {
  description = "AMI type for the EKS node group"
  type        = string
  default     = "AL2023_x86_64_STANDARD" # Use AL2_x86_64 for x86 instances, AL2_ARM_64 for ARM instances
}

variable "label_one" {
  description = "Label for the EKS node group"
  type        = string
  default     = "system"
}

variable "zone_name" {
  description = "Name of the DNS zone"
  type        = string
  default     = "mypodsix.online"
}

variable "domain-name" {
  description = "Domain name to be created"
  type        = string
  default     = "mypodsix.online"
}

#===========

variable "db_instance_class" {
  description = "Instance class for the RDS database"
  type        = string
  default     = "db.t3.medium" 
}

variable "db_allocated_storage" {
  description = "Storage allocated to the DB instance (in GB)"
  type        = number
  default     = 20
}

# variable "db_subnet_group_name" {
#   description = "Name of the DB subnet group"
#   type        = string
#   default     = "my-db-subnet-group"
# }

variable "db_username" {
  description = "Username for the database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  default     = "password123"
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "production_db"
}
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "eks-cluster"
}

variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "eks-repository"
  
}

variable "email" {
  description = "Email address for notifications and certificates"
  type        = string
  default     = "okoro.christianpeace@gmail.com"
}