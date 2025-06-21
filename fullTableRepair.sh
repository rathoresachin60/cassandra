#!/bin/bash

if [[ "$2." = "." ]]
then
	exit
else
        nodetool -u rsacassandra -pw XCyota01! repair -full $1 $2
fi

