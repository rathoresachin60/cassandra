#!/bin/bash

if [[ "$2." = "." ]]
then
	exit
else
        nodetool -u username -pw password repair -full $1 $2
fi

