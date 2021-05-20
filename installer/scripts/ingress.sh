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
  --namespace=kupenstack \
  --values=/tmp/ingress-component.yaml 

# Wait for pods to get ready
cd /opt/openstack-helm && ./tools/deployment/common/wait-for-pods.sh kupenstack

# Verify
helm status ingress-openstack


