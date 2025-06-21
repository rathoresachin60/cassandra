#!/bin/bash

if [ $USER != russell.waliszewski ]; then
	echo "This MUST be run as russell.waliszewski"
	exit
fi

if [ "$1." = "." ]; then
	echo "Supply an IP Address as a parameter"
	exit
fi

nodetool -u rsacassandra -pwf ~/.local/.cp status |grep "$1 " | sort -n |awk '{ printf  "%s\n", $1 }'

