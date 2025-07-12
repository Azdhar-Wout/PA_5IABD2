# --- Cloud Run Job pour Generation d'audio ---
resource "google_cloud_run_v2_job" "generate_audio" {
  name     = "generate-audio"
  location = var.gcp_datacenter_euw

  template {
    task_count = 1
    template {
      service_account = google_service_account.cloud_run_job_runner.email
      timeout         = "300s" # 5 minutes

      containers {
        # Image placeholder
        image = "gcr.io/google-samples/hello-app:1.0"

        # Vraie image : image = "${var.gcp_datacenter_euw}-docker.pkg.dev/${var.gcp_project_id}/${var.repo_name}/generate_audio"

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
  location = var.gcp_datacenter_euw

  template {
    task_count = 1
    template {
      service_account = google_service_account.cloud_run_job_runner.email
      # TODO : redéfinir le timer en fonction du temps d'entrainement
      timeout = "7200s"

      containers {
        # Image placeholder
        image = "gcr.io/google-samples/hello-app:1.0"
        # Vraie image : image = "${var.gcp_datacenter_euw}-docker.pkg.dev/${var.gcp_project_id}/${var.repo_name}/train_model"

        resources {
          limits = {
            cpu    = "4"
            memory = "16Gi"
            # nvidia_tesla_t4  = 1    # Pas compris dans le free trial
          }
        }
      }
    }
  }
  depends_on = [google_service_account.cloud_run_job_runner]
}


resource "google_cloud_run_v2_service" "tts_api" {
  name     = "tts-api"
  location = var.gcp_datacenter_euw

  template {
    containers {
       # Image placeholder
        image = "gcr.io/google-samples/hello-app:1.0"
        # Vraie image : image = "${var.gcp_datacenter_euw}-docker.pkg.dev/${var.gcp_project_id}/${var.repo_name}/tts_api"

      ports {
        container_port = 8080
      }
    }

    service_account = google_service_account.cloud_run_job_runner.email
  }
}
