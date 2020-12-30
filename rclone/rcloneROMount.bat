@echo off
title Rclone Mount READ ONLY
D:\rclone\rclone mount --attr-timeout 1000h --dir-cache-time 1000h --poll-interval 0 --rc --read-only -v c2c: G:
pause