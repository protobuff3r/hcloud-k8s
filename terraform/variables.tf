variable "hcloud_token" {
  type        = string
  description = "Hetzner Cloud API Token"
  default = "xxxxxxxxxxxxxxxxxxxxxxxxxx"
}

variable "datacenter" {
  type        = string
  description = "Datacenter Location"
  default = "fsn1"
}

variable "master_servertype" {
  type        = string
  description = "Master Server Type"
  default = "cx21-ceph"
}

variable "worker_servertype" {
  type        = string
  description = "Worker Server Type"
  default = "cx31-ceph"
}