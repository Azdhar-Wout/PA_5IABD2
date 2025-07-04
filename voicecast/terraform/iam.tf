resource "google_service_account" "cloud_run_job_runner" {
  account_id   = "compte-de-service-voicecast"
  display_name = "Service Account for Voicecast"
  depends_on   = [google_project_service.apis]
}

# Grant the service account permissions to read/write to Cloud Storage
resource "google_project_iam_member" "storage_admin" {
  project = var.gcp_project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.cloud_run_job_runner.email}"
}
