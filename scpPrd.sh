#!/bin/bash

if [ "$1." = "." ]; then
	echo "Seriously you didn't enter a command to run on the command line!!!"
	exit
fi

if [ $USER != sachin.rathore ]; then
	echo "This MUST be run as sachin.rathore"
	exit
fi

if [ "$2." = "." ]; then
        echo "This requires 2 paramters: 1) File name to copy, 2) Directory destination"
fi

ipList=$(getClusterIPs.sh Primary)

for IPAddr in $ipList
do
	# if a third parameter is added we are just displaying the host name
	scpToNode.sh $IPAddr $1 $2 $3
done

