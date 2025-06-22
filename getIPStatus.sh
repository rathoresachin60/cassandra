#!/bin/bash

if [ $USER != sachin.rathore ]; then
	echo "This MUST be run as sachin.rathore"
	exit
fi

if [ "$1." = "." ]; then
	echo "Supply an IP Address as a parameter"
	exit
fi

nodetool -u cassandra -pwf ~/.local/.cp status |grep "$1 " | sort -n |awk '{ printf  "%s\n", $1 }'

