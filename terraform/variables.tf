###############################################################
# Vinzapinfotech — Terraform Variables
###############################################################

variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Primary domain name (without www)"
  type        = string
  default     = "vinzapinfotech.com"
}

variable "environment" {
  description = "Environment name (production / staging)"
  type        = string
  default     = "production"

  validation {
    condition     = contains(["production", "staging", "dev"], var.environment)
    error_message = "Environment must be production, staging, or dev."
  }
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID (use env var TF_VAR_aws_access_key_id)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key (use env var TF_VAR_aws_secret_access_key)"
  type        = string
  sensitive   = true
  default     = ""
}
