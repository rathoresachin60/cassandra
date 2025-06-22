#!/bin/bash

if [ $USER != sachin.rathore ]; then
	echo "This MUST be run as sachin.rathore"
	exit
fi

ipList=$(getClusterIPs.sh ALL)

for IPAddr in $ipList
do
	restartCassandraNode.sh $IPAddr
done
echo "Completed cluster restart"

