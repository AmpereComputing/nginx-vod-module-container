# Deploy Nginx VOD container to OCI OKE

## The following is the steps to deploy Nginx VOD container with PVC to OCI

% kubectl create -f nginx-vod-app-pvc.yaml

% kubectl create -f nginx-vod-app-deployment.yaml

% kubectl create -f nginx-vod-app-service.yaml
