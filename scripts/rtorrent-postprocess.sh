#!/bin/sh -xu
# Input Parameters
ARG_PATH="$1"
ARG_NAME="$2"
ARG_LABEL="$3"

# Configuration
CONFIG_OUTPUT="/home/bate/rclone/cache/"
if [ "$ARG_LABEL" = dkfilm ]; then
	filebot -script fn:amc --log-file amc.log --output $CONFIG_OUTPUT --action hardlink --conflict auto -non-strict --lang Danish --def unsorted=y music=n artwork=n excludeList=".excludes" ut_dir="$ARG_PATH" ut_kind=multi ut_title=$ARG_NAME ut_label=movie --def movieFormat="DKFILM/{plex.tail} {vf}" &
elif [ "$ARG_LABEL" = dktv ]; then
	filebot -script fn:amc --log-file amc.log --output $CONFIG_OUTPUT --action hardlink --conflict auto -non-strict --lang Danish --def unsorted=y music=n artwork=n excludeList=".excludes" ut_dir="$ARG_PATH" ut_kind=multi ut_title=$ARG_NAME ut_label=show --def seriesFormat="DKTV/{plex.tail} {vf}" &
elif [ "$ARG_LABEL" = remux ]; then
	filebot -script fn:amc --log-file amc.log --output $CONFIG_OUTPUT --action hardlink --conflict auto -non-strict --def unsorted=y music=n artwork=n excludeList=".excludes" ut_dir="$ARG_PATH" ut_kind=multi ut_title=$ARG_NAME ut_label=movie --def movieFormat="remux/{plex.tail} {vf}" &
elif [ "$ARG_LABEL" = 4k ]; then
	filebot -script fn:amc --log-file amc.log --output /home/bate/torrents/ --action move --conflict auto -non-strict --def unsorted=y music=n artwork=y excludeList=".excludes" ut_dir="$ARG_PATH" ut_kind=multi ut_title=$ARG_NAME ut_label=movie --def movieFormat="4k/{plex.tail} {vf}" &
elif [ "$ARG_LABEL" = dkkidstv ]; then
	filebot -script fn:amc --log-file amc.log --output $CONFIG_OUTPUT --action hardlink --conflict auto -non-strict --lang Danish --def unsorted=y music=n artwork=n excludeList=".excludes" ut_dir="$ARG_PATH" ut_kind=multi ut_title=$ARG_NAME ut_label=show --def seriesFormat="DKKidsTV/{plex.tail} {vf}" &
elif [ "$ARG_LABEL" = dkkidsmovie ]; then
	filebot -script fn:amc --log-file amc.log --output $CONFIG_OUTPUT --action hardlink --conflict auto -non-strict --lang Danish --def unsorted=y music=n artwork=n excludeList=".excludes" ut_dir="$ARG_PATH" ut_kind=multi ut_title=$ARG_NAME ut_label=movie --def movieFormat="DKKidsMovie/{plex.tail} {vf}" &

else
	filebot -script fn:amc --output "$CONFIG_OUTPUT" --action hardlink --conflict auto -non-strict --log-file amc.log --def unsorted=y music=n artwork=y excludeList=".excludes" ut_dir="$ARG_PATH" ut_kind="multi" ut_title="$ARG_NAME" ut_label="$ARG_LABEL" &
fi
