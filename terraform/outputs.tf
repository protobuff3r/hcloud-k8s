output "master_ipv4" {
  description = "Map of private ipv4 to public ipv4 for masters"
  value       = { for i in range(length(hcloud_server.master)) : hcloud_server_network.master_network[i].ip => hcloud_server.master[i].ipv4_address }
}

output "worker_ipv4" {
  description = "Map of private ipv4 to public ipv4 for workers"
  value       = { for i in range(length(hcloud_server.worker)) : hcloud_server_network.worker_network[i].ip => hcloud_server.worker[i].ipv4_address }
}

output "floating_ipv4" {
  description = "Map of floating ipv4"
  value       = hcloud_floating_ip.lbipv4.ip_address
}

output "floating_ipv6" {
  description = "Map of floating ipv6"
  value       = hcloud_floating_ip.lbipv6.ip_address
}