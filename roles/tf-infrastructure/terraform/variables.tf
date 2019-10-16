// DO NOT EDIT - ANSIBLE replace the variables

variable "hcloud_token" {
  type        = string
  description = "Hetzner Cloud API Token - Replaced by Ansible Playbook on run"
}

variable "datacenter" {
  type        = string
  description = "Datacenter Location - Replaced by Ansible Playbook on run"
}

variable "master_servertype" {
  type        = string
  description = "Master Server Type - Replaced by Ansible Playbook on run"
}

variable "worker_servertype" {
  type        = string
  description = "Worker Server Type - Replaced by Ansible Playbook on run"
}

variable "worker_count" {
  type        = number
  description = "Worker count - Replaced by Ansible Playbook on run"
}

variable "floatip_count" {
  type        = number
  description = "Floating IPs count - Replaced by Ansible Playbook on run"
}