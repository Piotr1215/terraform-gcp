provider "google" {
  credentials = "${file("..\\TerraformKey.json")}"
  project     = "atos-dev-254809"
  region      = "europe-west3"
  zone        = "europe-west3-a"
}

resource "google_container_cluster" "primary" {
  name               = "atos-dev"
  location           = "europe-west3-a"
  initial_node_count = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "atos-node-pool"
  location   = "europe-west3-a"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = 3

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

}
  output "name" {
    value = "${google_container_cluster.primary.name}"
  }
