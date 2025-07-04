resource "google_artifact_registry_repository" "main_repo" {
  location      = var.gcp_region
  repository_id = var.repo_name
  description   = "Docker repository for VoiceCast."
  format        = "DOCKER"
  project       = var.gcp_project_id
  depends_on    = [google_project_service.apis]
}
