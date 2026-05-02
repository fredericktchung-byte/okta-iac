variable "org_name" {
  type        = string
  description = "The prefix of your Okta Org URL"
  default     = "integrator-1501452"
}

variable "api_token" {
  type        = string
  description = "Okta API Token"
  sensitive   = true # This prevents the token from printing in your console logs
}