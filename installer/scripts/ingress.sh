#!/bin/bash

make -C ${HELM_CHART_ROOT_PATH} ingress

helm upgrade --install ingress-kube-system ${HELM_CHART_ROOT_PATH}/ingress \
  --namespace=kube-system \
  --values=/tmp/ingress-kube-system.yaml

# Wait for pods to get ready
cd /opt/openstack-helm && ./tools/deployment/common/wait-for-pods.sh kube-system

# Verify
helm status ingress-kube-system

# Deploy ingress-openstack
helm upgrade --install ingress-openstack ${HELM_CHART_ROOT_PATH}/ingress \
  --namespace=openstack \
  --values=/tmp/ingress-component.yaml 

# Wait for pods to get ready
cd /opt/openstack-helm && ./tools/deployment/common/wait-for-pods.sh openstack

# Verify
helm status ingress-openstack

# Deploy ingress-ceph
helm upgrade --install ingress-ceph ${HELM_CHART_ROOT_PATH}/ingress \
  --namespace=ceph \
  --values=/tmp/ingress-component.yaml

# Wait for pods to get ready
cd /opt/openstack-helm && ./tools/deployment/common/wait-for-pods.sh ceph

# Verify
helm status ingress-ceph
