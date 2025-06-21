#! /bin/bash

# Three Parameters
# 1 - Keyspace
# 2 - Table Name
# 3 - PK Value of the record

if [ "$2." = "." ]; then
	echo You are missing parameters.
	exit
fi

nodetool -u rsacassandra -pw XCyota01! getendpoints -- $1 $2 $3


