# Ansible Playbook

## Prerequirments edit the following files
  - set the IPs in the file "ansible/inventory" from "terraform/outputs.json" 
  - edit the Values in "ansible/env/values.yaml" from "terraform/outputs.json"

## Start Playbook
```bash
ansible-playbook install.yaml -i inventory
```

## What's happening
  - Configure Floating IPs and install gobetween for IPv6 to IPv4 translation
  - Prepare Kubernetes Tools and Configuration on all Servers
  - Install Master-Node
  - Join Worker-Nodes to Master
  - Install Metal Load Balancer and IP failover Configuration (FIP)
    - [MetalLB](https://metallb.universe.tf/)
    - [Hetzner Cloud floating IP controller](https://github.com/cbeneke/hcloud-fip-controller)
  
### Info MetalLB

Hetzner Cloud does not support LoadBalancer as a Service (yet). Thus [MetalLB](https://metallb.universe.tf/) will be installed to make the LoadBalancer service type available in the cluster.

> A Kubernetes LoadBalancer is typically managed by the cloud controller, but it is not implemented in the hcloud cloud controller (because its not supported by Hetzner Cloud). MetalLB is a project, which provides the LoadBalancer type for baremetal Kubernetes clusters. It announces changes of the IP address endpoint to neighbor-routers, but we will just make use of the LoadBalancer provision in the cluster.

This will configure MetalLB to use the IPv4 floating IP as LoadBalancer IP. MetalLB can reuse IPs for multiple LoadBalancer services if some [conditions](https://metallb.universe.tf/usage/#ip-address-sharing) are met. This can be enabled by adding an annotation `metallb.universe.tf/allow-shared-ip` to the service.

### Info floating IP failover

As the floating IP is bound to one server only I wrote a little controller, which will run in the cluster and reassign the floating IP to another server, if the currently assigned node becomes NotReady.

> If you do not ensure, that the floating IP is always associated to a node in status Ready your cluster will not be high available, as the traffic can be routed to a (potentially) broken node.

[Hetzner Cloud floating IP controller](https://github.com/cbeneke/hcloud-fip-controller)

> If you did not set up the hcloud cloud controller, the external IP of the nodes might be announced as internalIP of the nodes in the Kubernetes cluster. In that event you must change `nodeAddressType` in the config to `internal` for the floating IP controller to work correctly.

Please be aware, that the project is still in development and the config might be changed drastically in the future. Refer to the [GitHub repository](https://github.com/cbeneke/hcloud-fip-controller) for config options etc.

### Credits

Credits for Installation Manual: https://github.com/cbeneke/

Ansible and Terraform created by: https://github.com/gammpamm/
