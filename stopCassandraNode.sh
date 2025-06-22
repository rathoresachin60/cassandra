#!/bin/bash

if [ $USER != sachin.rathore ]; then
	echo "This MUST be run as sachin.rathore"
	exit
fi

echo "Restarting IP: $1 Date/Time: $(date +%F-%H:%M:%S)"
nodeStatus=$(getIPStatus.sh $1)

echo "	Flushing Node Date/Time: $(date +%F-%H:%M:%S)"
commandToNode.sh $1 'nodetool -u rsacassandra -pwf ~/.local/.cp flush'
echo "	Draining Node Date/Time: $(date +%F-%H:%M:%S)"
commandToNode.sh $1 'nodetool -u rsacassandra -pwf ~/.local/.cp drain'
echo "	Completed Date/Time: $(date +%F-%H:%M:%S)"

echo "	Stopping Cassandra Date/Time: $(date +%F-%H:%M:%S)"
commandToNode.sh $1 'sudo systemctl stop cassandra.service'
until [ "$nodeStatus" == "DS" ]
do
	echo "Current Status: $nodeStatus will check again in 30 seconds"
	sleep 30
	nodeStatus=$(getIPStatus.sh $1)
done
echo "	Completed Date/Time: $(date +%F-%H:%M:%S)"

