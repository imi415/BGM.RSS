#!/usr/bin/zsh

# $1 -> Origin filename
# $2 -> Output filename
# $3 -> Resolution (1280x720)

ffmpeg -loglevel panic \
                    -i $1 \
                    -vcodec copy \
                    -acodec copy \
                    -f hls -hls_list_size 0 -hls_allow_cache 1 \
                    -hls_time 30 -hls_segment_filename "$2_%03d.ts" $2.m3u8
