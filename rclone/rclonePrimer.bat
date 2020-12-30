@echo off
title Rclone Prime
D:\rclone\rclone rc vfs/refresh recursive=true --timeout 10m
pause