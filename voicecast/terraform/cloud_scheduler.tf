resource "google_cloud_scheduler_job" "weekly_training" {
  name      = "weekly-training"
  # Cron format : https://cloud.google.com/scheduler/docs/configuring/cron-job-schedules
  schedule  = "0 2 * * 1"  # Lundi 2h du matin  # min hour day_of_month month day_of_week
  time_zone = "Europe/Paris"

  http_target {
    http_method = "POST"
    uri         = "https://${var.gcp_datacenter_euw}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.gcp_project_id}/jobs/training:run"

    oauth_token {
      service_account_email = google_service_account.cloud_run_job_runner.email
    }
  }
}