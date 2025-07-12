# Cloud Run Service pour le front-end
resource "google_cloud_run_v2_service" "frontend" {
  name     = "voicecast-frontend"
  location = var.gcp_datacenter_euw

  template {
    scaling {
      min_instance_count = 0
      max_instance_count = 10
    }

    containers {
        # Image placeholder
        # image = "gcr.io/google-samples/hello-app:1.0"
        # Vraie image :
        image = "${var.gcp_datacenter_euw}-docker.pkg.dev/${var.gcp_project_id}/${var.repo_name}/frontend:latest"

      ports {
        container_port = 3000  # TODO: changer port si besoin
      }

      # Variable d'environnement pour la bdd, à voir si on doit la garder ou non
      env {
        name  = "DATABASE_URL"
        value = "file:./dev.db"
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }

      # Volume pour persister la BDD
      volume_mounts {
        name       = "database-volume"
        mount_path = "/app/prisma"
      }
    }

    # Volume persistant pour la BDD
    volumes {
      name = "database-volume"

      gcs {
        bucket    = google_storage_bucket.basic_bucket.name
        read_only = false
      }
    }

    service_account = google_service_account.cloud_run_service_runner.email
  }

  depends_on = [
    google_project_service.apis,
    google_storage_bucket.basic_bucket
  ]
}

# Donner l'accès public
resource "google_cloud_run_service_iam_binding" "frontend_public" {
  location = google_cloud_run_v2_service.frontend.location
  service  = google_cloud_run_v2_service.frontend.name
  role     = "roles/run.invoker"
  members = [
    "allUsers",
  ]
}

# Sortie de l'URL du service
output "frontend_url" {
  value = google_cloud_run_v2_service.frontend.uri
  description = "Front's URL deployed"
}