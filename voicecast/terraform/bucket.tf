# Base bucket
resource "google_storage_bucket" "basic_bucket" {
  name = "${var.project_name}"
  location = var.gcp_datacenter_euw
  force_destroy = false         # WARNING WARNING WARNING
  uniform_bucket_level_access = true
  depends_on = [google_project_service.apis]
}

# Sub buckets
resource "google_storage_bucket_object" "sub_buckets" {
    for_each = toset([
        "basic_dataset/",
        "generated/",
        "samples/"
       ])

  bucket =  google_storage_bucket.basic_bucket.name
  name = each.value
  content = " "
}