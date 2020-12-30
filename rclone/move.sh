#!/bin/bash
### DO NOT REMOVE/EDIT THIS LINE
. /root/.quickbox/db_access_file
################################
# RClone Config file
RCLONE_CONFIG=/home/bate/.config/rclone/rclone.conf
export RCLONE_CONFIG
_cyan=$(tput setaf 6)
_green=$(tput setaf 2)
function _info() {
  printf "\n\n${_cyan}➜ %s${_norm}\n" "$@"
}
function _success() {
  printf "${_green}✓ %s${_norm}\n" "$@"
}
function _cleanLock() {
  _info "Clearing lock from Ctrl+C intercept"
  rm -f /home/bate/rclone/rclone.lock
  _success "rclone.lock successfully removed."
  exit 1
}
trap _cleanLock SIGINT

if [[ ! -f /home/bate/rclone/rclone.lock ]]; then
  touch /home/bate/rclone/rclone.lock
  /usr/bin/rclone move /home/bate/rclone/cache gdrive:Media --drive-chunk-size 64M --drive-stop-on-upload-limit --delete-empty-src-dirs --user-agent user --fast-list -P --log-file=/home/bate/rclone/move.log -v
  rm -f /home/bate/rclone/rclone.lock
else
  exit 1
fi

