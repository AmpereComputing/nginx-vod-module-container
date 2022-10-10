#!/usr/bin/env bash

P1080p="1920x1080"
P720p="1280x720"
P480p="852x480"
P360p="630x360"
P240p="426x240"

if [ -z "$1" ]; then
    echo "transcode.sh [video filename]"
else
    filename=$1
    file=${filename/.*/}
    ext=${filename/*./}
    resolution=`ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 ${filename}`
    height=`ffprobe -v error -show_entries stream=height -of default=noprint_wrappers=1:nokey=1 ${filename}`
    echo resolution: ${resolution}
    echo height: ${height}
    echo filename without ext: ${file}
    #echo `ffprobe $1  2>&1 >/dev/null |grep Stream.*Video`
    
    if ( ffprobe $1 2>&1 >/dev/null | grep -q Stream.*Video ) ; then
        if [ ${height} -ge 1080 ] ; then
            echo "Resoltuon  greater than or equal to 1080p"
            ffmpeg -i $1 -c:a copy -c:v libx264  -profile:v main -vf format=yuv420p -s ${P1080p} -movflags +faststart  ${file}_1080p.mp4
            ffmpeg -i $1 -c:a copy -c:v libx264  -profile:v main -vf format=yuv420p -s ${P720p} -movflags +faststart  ${file}_720p.mp4
            ffmpeg -i $1 -c:a copy -c:v libx264  -profile:v main -vf format=yuv420p -s ${P480p} -movflags +faststart  ${file}_480p.mp4
            ffmpeg -i $1 -c:a copy -c:v libx264  -profile:v main -vf format=yuv420p -s ${P360p} -movflags +faststart  ${file}_360p.mp4
            ffmpeg -i $1 -c:a copy -c:v libx264  -profile:v main -vf format=yuv420p -s ${P240p} -movflags +faststart  ${file}_240p.mp4
            ffmpeg -i $1 -vf format=yuv420p -s ${P240p}  -ss 00:00:03.435 -frames:v 1 ${file}_240p.png
        else
            ffmpeg -i $1 -c:v libx264 -profile:v main -vf format=yuv420p  -c:a aac -movflags +faststart  ${file}.mp4
        fi
    fi
fi
