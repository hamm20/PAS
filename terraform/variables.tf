variable "regsion" {
    description = "AWS region"
    type = string
}

variable "cidr_block" {
    description = "VPC CIDR block"
    default     = "10.0.0.0/16"
}