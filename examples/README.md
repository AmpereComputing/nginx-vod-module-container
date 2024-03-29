# HLS & DASH example

## Running this example locally

1. Replicate all video and vtt files under videos to a directory (for example, vod-demo) as container storage for nginx-vod-app
2. If you want to use your own video, please make sure the video resolution is higher than 720p, then use bin/transcode.sh to transcode all renditions in 240p, 360p, 480p, 720p & 1080p by the following commands:
  ```
  % chmod +x transcode.sh 
  % ./transcode.sh [video filename] 
  ```
3. After trancoding video completed, move the video files under vod-demo/videos 
4. The hls.html and dash.html under html are the example of HTML5 video players for HLS and MPEG-DASH 
  - For Linux user, you can copy them into new files (e.g., Ampere_AI-hls.html or Ampere_AI-dash.html) with the new hostname and video file prefix by the command below 
  ```
  $ sed -i "s,http://\[vod-demo\]/,http://localhost:3030/,g" Ampere_AI-hls.html
  $ sed -i "s,/\[video-prefix\],/Ampere_AI_,g" Ampere_AI-hls.html
  ```
  - For MacOS user, you can not use "-i" to replace those 2 patterns, please use the commands below: 
  ```
  $ sed "s,http://\[vod-demo\]/,http://localhost:3030/,g" hls.html > tmp.html
  $ sed "s,/\[video-prefix\],/Ampere_AI_,g" tmp.html > Ampere_AI-hls.html
  ```
5. You can run this example locally with Docker or Podman under the 

```
% docker run -p 3030:8080 --name nginx-vod-app -v $PWD/videos:/opt/static/videos -v $PWD/nginx.conf:/usr/local/nginx/conf/nginx.conf ampere/nginx-vod-app
```
or
```
% podman run -p 3030:8080 --name nginx-vod-app -v $PWD/videos:/opt/static/videos -v $PWD/nginx.conf:/usr/local/nginx/conf/nginx.conf ampere/nginx-vod-app
```

6. After running this command, you should be able to play the following URLs with VLC video player:

- HLS: http://localhost:3030/hls/Ampere_AI_,240p.mp4,360p.mp4,480p.mp4,720p.mp4,.en_US.vtt,.urlset/master.m3u8
- Dash: http://localhost:3030/dash/Ampere_AI_,240p.mp4,360p.mp4,480p.mp4,720p.mp4,.en_US.vtt,.urlset/manifest.mpd
- Thumbnail: http://localhost:3030/thumb/Ampere_AI_360p.mp4/thumb-3000.jpg

7. You also can use browsers to playback video streaming by opening the html files. Ampere_AI-hls.html and Ampere_AI-dash.html

8. If you want to use a nginx web server container to host those html files, then you can use the Dockerfile on https://github.com/AmpereComputing/nginx-hello-container/ to build the container image to run nginx web server.

## Running this demo on Kubernetes
1. Find nginx-vod-app.yaml in one of the kubernetes distributions (Canonical MicroK8s, OKE, SUSE K3s) with corresponding StorageClass
2. You can run the command to deploy the StatefulSet to the namespace on Kubernetes from your bastion node
```
% kubectl -n [namespace] create -f ./nginx-vod-module-container/[K8s distro]/nginx-vod-app.yaml
```
3. Check the result after deployed the StatefulSet 
```
$ kubectl get pod -n [namespace]
NAME                READY   STATUS    RESTARTS   AGE
nginx-vod-app-0     1/1     Running   0          1m
nginx-vod-app-1     1/1     Running   0          30s
nginx-vod-app-2     1/1     Running   0          10s
```
4. For deploying the video files to the container in nginx-vod-app pod, you will need a webserver to host those video and subtitle files
5. You can prepare a tarball with those pre-transcoded video files and subtitle file (extension filename: vtt) by the command below:
```
% tar -zcvf vod-demo.tgz *.mp4 *.vtt
```
6. Then create a sub-directory such as "nginx-html" and move vod-demo.tgz to "nginx-html", then run the nginx webserver container with the directory
```
% mkdir nginx-html
% mv vod-demo.tgz nginx-html
% cd nginx-html
% podman run -d --rm -p 8080:8080  --name nginx-html  --user 1001 -v $PWD:/usr/share/nginx/html  docker.io/mrdojojo/nginx-hello-app:1.1-arm64
```
7. Once the Nginx webserver container running, then access the container in nginx-vod-app pod by the commands below:
```
% kubectl -n [namespace] exec -it nginx-vod-app-[0-2] -- sh
# cd /opt/static/videos
/opt/static/videos # wget http://[IP address of the host running the nginx web server container, nginx-html]/vod-demo.tgz
/opt/static/videos # tar zxvf vod-demo.tgz
/opt/static/videos # exit
```
8. The nginx-vod-app service is ready for streaming video
