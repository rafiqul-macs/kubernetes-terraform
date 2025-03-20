provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Only include the artifact registry that was successfully imported
resource "google_artifact_registry_repository" "kubernetes_assignment" {
  location      = var.region
  repository_id = "kubernetes-assignment"
  format        = "DOCKER"
}

# Use data sources instead of resources for existing infrastructure
data "google_container_cluster" "primary" {
  name     = "kubernetes-assignment-cluster"
  location = var.zone
}
