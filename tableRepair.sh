#!/bin/bash

if [[ "$3." = "." ]]
then
        nodetool -u rsacassandra -pw XCyota01! repair -pr -j 1 $1 $2
	if [ "$?" != 0 ]; then
		echo "ERROR IN REPAIR"
	fi
else
        nodetool -u rsacassandra -pw XCyota01! repair -pr -j $3 $1 $2
	if [ "$?" != 0 ]; then
		echo "ERROR IN REPAIR"
	fi
fi

