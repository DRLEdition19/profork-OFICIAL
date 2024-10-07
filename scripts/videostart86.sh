#!/bin/bash

do_videostart() {
    video="$1"
    cvlc --fullscreen --no-video-title-show --play-and-exit --no-loop --no-repeat "$video"
}

# Uncomment for concurrent video playback (experimental)
# do_videostart() {
#     video="$1"
#     vlc_opt="play --fullscreen --no-video-title-show --play-and-exit"
#     vlc $vlc_opt $video &
#     PID=$!
# }

videopath="/userdata/loadingscreens"
romname="$(basename "${5%.*}")"

if [[ "$1" == "gameStart" && -n "$2" ]]; then
    if [[ -f "${videopath}/${romname}.mp4" ]]; then 
        video="${videopath}/${romname}.mp4"
    else
        video="${videopath}/${2}.mp4"
        if [[ ! -f "$video" ]]; then
            echo "Video file not found: $video" >&2
            exit 1
        fi
    fi
else
    exit 1
fi

do_videostart "$video"
# Uncomment if using concurrent playback
# wait $PID
exit 0

# Uncomment for a default video for all systems
# default="/userdata/loadingscreens/default.mp4"
# case $1 in
# gameStart)
#     vlc play --fullscreen --no-video-title-show --play-and-exit $default
#     ;;
# esac
# exit 0

