# HLS & DASH example

## Running this example locally

1. Replicate all video and vtt files under videos to a directory as container storage for nginx-vod-app
2. If you want to use your own video, please make sure the video resolution is higher than 720p, then use bin/transcode.sh to transcode all renditions in 240p, 360p, 480p, 720p & 1080p by the following commands:
```
% chmod +x transcode.sh 
% ./transcode.sh [video filename] 
```
3.
4. The hls.html and dash.html under html are example video players for HLS and MPEG-DASH. You can copy them into new files (e.g., Ampere_AI-hls.html or Ampere_AI-dash.html) with the new hostname and video file prefix by the command below 
```
$ sed -i "s,http://\[vod-demo\]/,http://localhost:3030/,g" Ampere_AI-hls.html
$ sed -i "s,/\[video-prefix\],/Ampere_AI_,g" Ampere_AI-hls.html
```
4. You can run this example locally with Docker or Podman

```
% docker run -p 3030:8080 --name nginx-vod-app -v $PWD/videos:/opt/static/videos -v $PWD/nginx.conf:/usr/local/nginx/conf/nginx.conf ampere/nginx-vod-module
```
or
```
% podman run -p 3030:8080 --name nginx-vod-app -v $PWD/videos:/opt/static/videos -v $PWD/nginx.conf:/usr/local/nginx/conf/nginx.conf ampere/nginx-vod-module
```

5. After running this command, you should be able to play the following URLs with VLC video player:

- HLS: http://localhost:3030/hls/Ampere_AI_,240p.mp4,360p.mp4,480p.mp4,720p.mp4,.en_US.vtt,.urlset/master.m3u8
- Dash: http://localhost:3030/dash/Ampere_AI_,240p.mp4,360p.mp4,480p.mp4,720p.mp4,.en_US.vtt,.urlset/manifest.mpd
- Thumbnail: http://localhost:3030/thumb/Ampere_AI_360p.mp4/thumb-3000.jpg

6. You also can use browsers to playback video streaming by opening the html files. Ampere_AI-hls.html and Ampere_AI-dash.html

7. If you want to use a nginx web server container to host those html files, then you can use the Dockerfile on https://github.com/AmpereComputing/nginx-hello-container/ to build the container image to run nginx web server.
