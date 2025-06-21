#!/bin/bash

if [ "$1." = "." ]; then
	echo "Seriously you didn't enter a command to run on the command line!!!"
	exit
fi

if [ $USER != russell.waliszewski ]; then
	echo "This MUST be run as russell.waliszewski"
	exit
fi

ipFile=$(getClusterIPs.sh Primary)

for IPAddr in $ipFile
do
	# if a second parameter is added we are just displaying the host name
	commandToNode.sh $IPAddr "$1" $2
done

