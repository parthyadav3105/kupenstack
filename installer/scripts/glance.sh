#!/bin/bash

OPENSTACK_HELM_ROOT_PATH=/opt/openstack-helm

make -C ${OPENSTACK_HELM_ROOT_PATH} glance

kubectl apply -f /tmp/glance-pv.yaml

helm upgrade --install glance ${OPENSTACK_HELM_ROOT_PATH}/glance \
    --namespace=openstack \
    --values=/tmp/glance.yaml


# wait for glance
cd /opt/openstack-helm && ./tools/deployment/common/wait-for-pods.sh openstack

