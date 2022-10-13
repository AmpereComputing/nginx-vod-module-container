# Deploy Nginx VOD container on Canonical MicroK8s Cluster (v1.24)

The following is the steps to deploy StatefulSet of Nginx VOD container on a MicroK8s cluster
---
> It's a StatefutSet with 3 replicas (by default) with PVC tempate to MicroK8s cluster with the add-ons: Ingress, Metallb, OpenEBS MayaStor.
>
> Please make sure there is a FQDN in the YAML file for the container! 

% kubectl create -f nginx-vod-app.yaml
