# Deploy Nginx VOD container to Canonical MicroK8s Cluster (v1.24)

## The following is the steps to deploy StatefulSet of Nginx VOD container 
It's a StatefutSet with 3 replicas (by default) with PVC tempate to MicroK8s cluster with OpenEBS MayaStor 

! Please make sure there is a FQDN in the YAML file for the container 

% kubectl create -f nginx-vod-app.yaml