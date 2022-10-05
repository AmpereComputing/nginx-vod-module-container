# Deploy Nginx VOD container to SUSE K3s Cluster

## The following is the steps to deploy Nginx VOD container with PVC to K3s with Longhorn

% kubectl create -f nginx-vod-app-pvc.yaml

% kubectl create -f nginx-vod-app-deployment.yaml

% kubectl create -f nginx-vod-app-service.yaml
