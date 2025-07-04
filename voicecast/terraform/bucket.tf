# Bucket for input the audios that were used for the first version of the model
resource "google_storage_bucket" "basic_dataset" {
  name          = "${var.gcp_project_id}-basic-dataset"
  location      = var.gcp_region
  force_destroy = true # WARNING :
  uniform_bucket_level_access = true
  depends_on = [google_project_service.apis]
}

# Bucket for generated audios
resource "google_storage_bucket" "generated_audio" {
  name          = "${var.gcp_project_id}-generated"
  location      = var.gcp_region
  force_destroy = true
  uniform_bucket_level_access = true
  depends_on = [google_project_service.apis]
}

# Bucket for samples used by the 0-shot
resource "google_storage_bucket" "voice_samples" {
  name          = "${var.gcp_project_id}-voice-samples"
  location      = var.gcp_region
  force_destroy = true
  uniform_bucket_level_access = true
  depends_on = [google_project_service.apis]
}
