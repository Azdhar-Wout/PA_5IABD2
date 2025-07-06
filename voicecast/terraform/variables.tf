variable "gcp_project_id" {
  type        = string
  description = "The GCP Project ID to deploy resources into."
  default = "voicecast-464815"
}

variable "gcp_datacenter_euw" {
  type        = string
  description = "The GCP region for all the resources."
  default     = "europe-west1"
}

variable "repo_name" {
  type        = string
  description = "Name for the Artifact Registry repository."
  default     = "voicecast-repo"
}
