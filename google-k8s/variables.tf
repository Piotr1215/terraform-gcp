#
# Variables
#
variable "project" {
  default = "atos-dev-254809"
}
variable "region" {
  default = "europe-west3"
}

variable "cluster_name" {
  default = "atos-dev-k8s"
}

variable "cluster_zone" {
  default = "europe-west3-a"
}

variable "cluster_k8s_version" {
  default = "1.15.8-gke.2"
}

variable "initial_node_count" {
  default = 1
}

variable "autoscaling_min_node_count" {
  default = 1
}

variable "autoscaling_max_node_count" {
  default = 3
}

variable "disk_size_gb" {
  default = 10
}

variable "disk_type" {
  default = "pd-standard"
}

variable "machine_type" {
  default = "n1-standard-1"
}