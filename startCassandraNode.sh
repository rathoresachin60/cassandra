#!/bin/bash

if [ $USER != sachin.rathore ]; then
	echo "This MUST be run as sachin.rathore"
	exit
fi

echo "	Starting Cassandra Date/Time: $(date +%F-%H:%M:%S)"
commandToNode.sh $1 'sudo systemctl start cassandra.service'
until [ "$nodeStatus" == "UN" ]
do
	echo "Current Status: $nodeStatus"
	sleep 30
	nodeStatus=$(getIPStatus.sh $1)
done

echo "  Completed restart: $1 Date/Time: $(date +%F-%H:%M:%S)"

