# Deploy Nginx VOD container to SUSE K3s Cluster

## The steps to deploy Nginx VOD app container with PVC to K3s + Longhorn 
It's a single pod only.

% kubectl create -f nginx-vod-app-pvc.yaml 

% kubectl create -f nginx-vod-app-deployment.yaml 

% kubectl create -f nginx-vod-app-service.yaml 

! Please make sure there is a FQDN in the ingress YAML file for the container 

% kubectl create -f nginx-vod-app-ingress.yaml 

## The following is the steps to deploy StatefulSet of Nginx VOD container 
It's a StatefutSet with 3 replicas (by default) with PVC tempate to K3s with Longhorn 

% kubectl create -f nginx-vod-app.yaml
