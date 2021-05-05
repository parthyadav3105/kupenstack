#!/bin/bash


# Add node labels

# label openstack-control-plane=enabled
controlnodes=$(yq -r .spec.controlNodes /etc/kupenstack/kupenstack.yaml)
for node in "${controlnodes[@]}"; do nodename=$(echo $node | sed 's/[]"/[]//g'); kubectl label nodes $nodename openstack-control-plane=enabled; done

# label linuxbridge=enabled
controlnodes=$(yq -r .spec.controlNodes /etc/kupenstack/kupenstack.yaml)
for node in "${controlnodes[@]}"; do nodename=$(echo $node | sed 's/[]"/[]//g'); kubectl label nodes $nodename linuxbridge=enabled; done

# label openstack-compute-node=enabled
controlnodes=$(yq -r .spec.controlNodes /etc/kupenstack/kupenstack.yaml)
for node in "${controlnodes[@]}"; do nodename=$(echo $node | sed 's/[]"/[]//g'); kubectl label nodes $nodename openstack-compute-node=enabled; done


# Init Helm
/etc/kupenstack/helm.sh

# Deploy Ingress
/etc/kupenstack/ingress.sh

# Deploy MariaDB
/etc/kupenstack/mariadb.sh

# Deploy Rabbitmq
/etc/kupenstack/rabbitmq.sh

# Deploy Memcached
/etc/kupenstack/memcached.sh

# Deploy Keystone
/etc/kupenstack/keystone.sh

# Deploy Horizon
/etc/kupenstack/horizon.sh

# Deploy Glance
/etc/kupenstack/glance.sh

echo "Deployment Completed"

