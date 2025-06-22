#!/bin/bash

if [[ "$3." = "." ]]
then
        nodetool -u cassandra -pw ****** repair -pr -j 1 $1 $2
	if [ "$?" != 0 ]; then
		echo "ERROR IN REPAIR"
	fi
else
        nodetool -u cassandra -pw ****** repair -pr -j $3 $1 $2
	if [ "$?" != 0 ]; then
		echo "ERROR IN REPAIR"
	fi
fi

