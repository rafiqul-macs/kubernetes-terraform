output "kubernetes_cluster_name" {
  value       = data.google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_endpoint" {
  value       = "https://${data.google_container_cluster.primary.endpoint}"
  description = "GKE Cluster Endpoint"
}

output "artifact_registry_repository" {
  value       = google_artifact_registry_repository.kubernetes_assignment.name
  description = "Artifact Registry Repository"
}

