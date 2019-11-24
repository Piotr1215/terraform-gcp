provider "google" {
  credentials = "${file("..\\TerraformKey.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
  zone        = "${var.cluster_zone}"
}

resource "google_container_cluster" "cluster" {
  name               = "${var.cluster_name}"
  location           = "${var.cluster_zone}"
  min_master_version = "${var.cluster_k8s_version}"
  initial_node_count = "${var.initial_node_count}"
  
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = true
    }
  }
}

resource "google_container_node_pool" "primary_regular_nodes" {
  name       = "atos-node-pool"
  location   = "${var.cluster_zone}"
  cluster    = "${google_container_cluster.cluster.name}"
  initial_node_count = "${var.initial_node_count}"

  management {
      auto_repair = true
    }

  autoscaling {
    min_node_count = "${var.autoscaling_min_node_count}"
    max_node_count = "${var.autoscaling_max_node_count}"
  }

  node_config {
    preemptible  = false
    disk_size_gb = "${var.disk_size_gb}"
    disk_type    = "${var.disk_type}"
    machine_type = "${var.machine_type}"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/trace.append",
        "https://www.googleapis.com/auth/compute",
    ]
  }
}
 #
# Output for K8S
#
output "client_certificate" {
  value = "${google_container_cluster.cluster.master_auth.0.client_certificate}"
  sensitive = true
}

output "client_key" {
  value = "${google_container_cluster.cluster.master_auth.0.client_key}"
  sensitive = true
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.cluster.master_auth.0.cluster_ca_certificate}"
  sensitive = true
}

output "host" {
  value = "${google_container_cluster.cluster.endpoint}"
  sensitive = true
}
