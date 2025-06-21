#!/bin/bash

if [ $USER != russell.waliszewski ]; then
	echo "This MUST be run as russell.waliszewski"
	exit
fi

ipList=$(getClusterIPs.sh ALL)

for IPAddr in $ipList
do
	restartCassandraNode.sh $IPAddr
done
echo "Completed cluster restart"

