#!/usr/bin/zsh

# $1 -> Origin filename
# $2 -> Output filename
# $3 -> Resolution (1280x720)

ffmpeg -loglevel panic \
                    -i $1 \
                    -vcodec libx264 -vprofile high -preset medium -vf setsar=1:1 \
                    -level 4.1 -b:v 1500k -maxrate 3000k -bufsize 10000k -s $3 \
                    -acodec libfdk_aac -vbr 5 \
                    -f hls -hls_list_size 0 -hls_allow_cache 1 \
                    -hls_time 30 -hls_segment_filename "$2_%03d.ts" $2.m3u8
