# --- Cloud Run Job pour Generation d'audio ---
resource "google_cloud_run_v2_job" "generate_audio" {
  name     = "generate-audio"
  location = var.gcp_region

  template {
    task_count = 1
    template {
      service_account = google_service_account.cloud_run_job_runner.email
      timeout         = "600s" # 10 minutes

      containers {
        image = "${var.gcp_region}-docker.pkg.dev/${var.gcp_project_id}/${var.repo_name}/generate_audio"

        resources {
          limits = {
            cpu    = "4"
            memory = "8Gi"
          }
        }
      }
    }
  }
  depends_on = [google_service_account.cloud_run_job_runner]
}


# --- Cloud Run Job pour Entrainement ---
resource "google_cloud_run_v2_job" "training" {
  name     = "training"
  location = var.gcp_region

  template {
    task_count = 1
    template {
      service_account = google_service_account.cloud_run_job_runner.email
      # TODO : redéfinir le timer en fonction du temps d'entrainement
      timeout         = "7200s"

      containers {
        image = "${var.gcp_region}-docker.pkg.dev/${var.gcp_project_id}/${var.repo_name}/train_model"

        resources {
          limits = {
            cpu    = "4"
            memory = "16Gi"
          }
        }
      }
    }
  }
  depends_on = [google_service_account.cloud_run_job_runner]
}
