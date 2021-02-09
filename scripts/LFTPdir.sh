#!/bin/bash
if [ $# -lt 3 ]
then
	echo "Usage: LFTPdir.sh 'user:pw' RemoteHostname Directory1 Directory2 DirectoryN..."
	exit
fi
USER=$1
shift
HOST=$1
shift
cd ~
for DIR in $@
do
echo -e "\n\n ***  ${DIR} *** \n\n"
	lftp -u ${USER} sftp://${HOST}/  -e "cd ~ ; mirror -c  --parallel=5 ${DIR} ;quit"
done
