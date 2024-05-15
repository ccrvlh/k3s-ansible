# K3s Ansible

This is a heavily modified version of the [original project](https://github.com/k3s-io/k3s-ansible), original work:

- Original Project Repo: [k3s-io/k3s-ansible](https://github.com/k3s-io/k3s-ansible)
- Original Project Author: <https://github.com/itwars>
- Original Project Current Maintainer: <https://github.com/dereknola>

The idea was to greatly simplify the playbook and make it more flexible, allowing for a more direct configuration of the cluster.
Currently, only Ubuntu/Debian distributions are supported.

## System requirements

The control node **must** have Ansible 8.0+ (ansible-core 2.15+)

All managed nodes in inventory must have:

- Passwordless SSH access
- Root access (or a user with equivalent permissions)

It is also recommended that all managed nodes disable firewalls and swap. See [K3s Requirements](https://docs.k3s.io/installation/requirements) for more information.

## Usage

First copy the sample inventory to `inventory.yml`.

```bash
cp inventory.example.yml inventory.yml
```

Second edit the inventory file to match your cluster setup.

If multiple hosts are in the server group the playbook will automatically setup k3s in HA mode with embedded etcd.
An odd number of server nodes is required (3,5,7). Read the [official documentation](https://docs.k3s.io/datastore/ha-embedded) for more information.

You can also setup the load balancer (HAProxy + KeepAlived) by defining the `loadbalancer` hosts in the inventory.
Start provisioning of the cluster using the following command:

```bash
# Running the playbook directly with a specific operation
ansible-playbook main.yml -e operation=cluster

# Using the make command
make cluster
```

Current operations are:

```bash
# Reset & uninstall k3s from all nodes
make reset

# Upgrade k3s on all nodes
make upgrade

# Install k3s on all nodes
make cluster

# Add an agent
make agent

# Reboot
make reboot

# Upgrade
make upgrade
```

## Cluster Initialization

After K3S is installed, you can add some manifests and/or Helm charts that will be applied.
This is helpful to add resources that will be used by the cluster, such as monitoring, logging, etc.
Just add the manifests to `./setup/manifests/my_manifest_goes_here.yml` and it will be applied.
For Helm charts, add the chart values `./setup/charts/some_chart/values.yml` and define the chart on the inventory.

## Kubeconfig

After successful bringup, the kubeconfig of the cluster is copied to the control node and merged with `~/.kube/config` under the `k3s-ansible` context.
Assuming you have [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) installed, you can confirm access to your **Kubernetes** cluster with the following:

```bash
kubectl config use-context k3s-ansible
kubectl get nodes
```

If you wish for your kubeconfig to be copied elsewhere and not merged, you can set the `kubeconfig` variable in `inventory.yml` to the desired path.
