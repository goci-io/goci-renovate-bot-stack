variable "name" {
  type        = string
  default     = "renovate"
  description = "Name of Renovate Bot Installation"
}

variable "schedule" {
  type        = string
  default     = "0 6 * * 1"
  description = "Schedule to run Renovate Bot. Defaults to Monday at 6am."
}

variable "git_type" {
  type        = string
  default     = "github"
  description = "Version Control System Type to be used (github, gitlab, bitbucket)"
}

variable "git_endpoint" {
  type        = string
  default     = ""
  description = "Endpoint to the Git Platform API"
}

variable "git_username" {
  type        = string
  default     = ""
  description = "Git User used for Authentication. Specifically used for BitBucket App Auth"
}

variable "git_token" {
  type        = string
  default     = ""
  description = "Git Token used for Renovate to checkout Repositories and create OnBoarding for example"
}

variable "repositories" {
  type        = list(string)
  description = "Repositories Renovate Bot should run on"
}

variable "renovate_version" {
  type        = string
  default     = ""
  description = "Desired Renovate Docker Image Tag"
}

variable "k8s_namespace" {
  type        = string
  default     = "default"
  description = "Kubernetes Namespace to deploy CronJob and Config into"
}
