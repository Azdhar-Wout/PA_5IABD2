# Permission pour lancer les Cloud Run Job
resource "google_service_account" "cloud_run_job_runner" {
  account_id   = "compte-de-service-voicecast"
  display_name = "Service Account for Voicecast"
  depends_on   = [google_project_service.apis]
}

# Permissions pour read/write sur Cloud Storage (pour les jobs génération audio, training)
resource "google_project_iam_member" "storage_admin" {
  project = var.gcp_project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.cloud_run_job_runner.email}"
}

# Permissions pour le Cloud Run Service (frontend)
resource "google_service_account" "cloud_run_service_runner" {
  account_id   = "voicecast-frontend-sa"
  display_name = "Service Account for Voicecast Frontend"
  depends_on   = [google_project_service.apis]
}

# Permissions pour le frontend (lecture/écriture dans le bucket)
resource "google_project_iam_member" "storage_object_admin_frontend" {
  project = var.gcp_project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.cloud_run_service_runner.email}"
}

# Permission pour lire les buckets
resource "google_project_iam_member" "storage_viewer_frontend" {
  project = var.gcp_project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.cloud_run_service_runner.email}"
}


