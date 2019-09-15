# hcloud-k8s

Install a Kubernetes Cluster on Hetzner Cloud. The Playbook install a Master and Workers with Private Networking inclusive Cloud Controller Manager for Hetzner Cloud, Load Balancer and Failover IPs.

## Local Requirements
  - Ansible v2.8.5 (https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
  - Terraform v0.12.6 (https://github.com/tfutils/tfenv#installation)
  - Helm v2.14.3 (https://github.com/helm/helm#install)
  - Kubectl v1.15.3 (https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Prerequirments edit the following files
  - create a HCloud Project in Hetzner Cloud Console
  - create a API Token and set in "env/values.yaml"
  - edit the values in "env/values.yaml"

## Create Infrastructure Ansible Playbook Terrafom Module
```bash
ansible-playbook create-infrastructure.yaml
```
After creation is complete waiting 5 Minutes, because Hetzner install the "roles/tf-infrastructure/terraform/user-data/cloud-config.yaml" (Docker, Kubelet, Kubeadm, Kubectl, SSH Keys)
The Playbook execute Terraform and apply the resources. The working directory is "roles/tf-infrastructure/terraform/"

## Install Kubernetes Ansible Playbook
```bash
ansible-playbook k8s-install.yaml -i env/inventory
```
Install Kubernetes, Floating IPs, Gobetween for IP translation, Master, Workers, Metal Load Balancer, FIP Controller for IP failover.

Test on your local machine if all works after few minutes:
```bash
kubectl get pods --all-namespaces
```

## Delete Kubernetes and destroy Infrastructure Ansible Playbook Terrafom Module
```bash
ansible-playbook destroy-infrastructure.yaml
```
The Playbook execute Terraform and destroy the resources (Delete Instances, Floating IPs, Networks). The working directory is "roles/tf-infrastructure/terraform/"

## What's happening
  - Create Infrastructure on Hetzner Cloud with Terraform (roles/tf-infrastructure/terraform/)
  - Configure Floating IPs and install Gobetween for IPv6 to IPv4 translation 
  - Prepare Kubernetes Tools and Configuration on all Servers
  - Install Master-Node
  - Join Worker-Nodes to Master
  - Install Metal Load Balancer and IP failover Configuration (FIP)
    - [MetalLB](https://metallb.universe.tf/)
    - [Hetzner Cloud floating IP controller](https://github.com/cbeneke/hcloud-fip-controller)
  - Cleanup

## Caution Security
  - Tiller is unsecure installed without certs (secure: https://medium.com/google-cloud/install-secure-helm-in-gke-254d520061f7)
  - No network policy enabled (multi-tenancy is dangerous)
  - No pod policy - privileged pods are allowed
  - Instances/Cluster not secured by a VPC (also have public IPs)

### Recommendations for Microservices
  - Install Knative (PaaS Serverless) with Gloo (feature-rich alternative Ingress Controller) - https://medium.com/solo-io/knative-kubernetes-native-paas-with-serverless-d06ddfca05a3
  - Install a Service-Mesh - Linkerd https://linkerd.io/ or Istio https://istio.io/)
  - Install a Cert Manager - https://docs.cert-manager.io/en/latest/tutorials/acme/quick-start

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
