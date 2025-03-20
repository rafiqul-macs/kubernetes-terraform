provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Create Artifact Registry Repository with lifecycle block
resource "google_artifact_registry_repository" "kubernetes_assignment" {
  location      = var.region
  repository_id = "kubernetes-assignment"
  format        = "DOCKER"
  
  # This prevents Terraform from trying to recreate/modify the existing repository
  lifecycle {
    ignore_changes = all
  }
}

# Create GKE Cluster with lifecycle block
resource "google_container_cluster" "primary" {
  name     = "kubernetes-assignment-cluster"
  location = var.zone
  
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  
  # This prevents Terraform from trying to recreate/modify the existing cluster
  lifecycle {
    ignore_changes = all
  }
}

# Create node pool with lifecycle block
resource "google_container_node_pool" "small_pool" {
  name       = "small-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    machine_type = "e2-small"
    image_type   = "cos_containerd"
    disk_size_gb = 10
    disk_type    = "pd-standard"
    
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  
  # This prevents Terraform from trying to recreate/modify the existing node pool
  lifecycle {
    ignore_changes = all
  }
}