provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Create Artifact Registry Repository
resource "google_artifact_registry_repository" "kubernetes_assignment" {
  location      = var.region
  repository_id = "kubernetes-assignment"
  format        = "DOCKER"
}

# Create GKE Cluster
resource "google_container_cluster" "primary" {
  name     = "kubernetes-assignment-cluster"
  location = var.zone
  
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  # Networking configurations
  networking_mode = "VPC_NATIVE"
  
  # This is the latest stable release of GKE
  release_channel {
    channel = "REGULAR"
  }
}

# Create separately managed node pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    # As specified in the assignment
    machine_type = "e2-micro"
    
    # Specific OS image
    image_type = "cos_containerd"
    
    # Minimum boot disk size
    disk_size_gb = 10
    disk_type    = "pd-standard"
    
    # Specific scopes for the nodes
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}