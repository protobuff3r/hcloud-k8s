output "master_ipv4" {
  description = "Map of private ipv4 to public ipv4 for masters"
  value       = ["${hcloud_server.master.*.ipv4_address}"]
}

output "worker_ipv4" {
  description = "Map of private ipv4 to public ipv4 for workers"
  value       = ["${hcloud_server.worker.*.ipv4_address}"]
}

output "floating_ipv4" {
  description = "Map of floating ipv4"
  value       = "${hcloud_floating_ip.lbipv4.ip_address}"
}

output "floating_ipv6" {
  description = "Map of floating ipv6"
  value       = "${hcloud_floating_ip.lbipv6.ip_address}"
}