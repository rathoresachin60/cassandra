#!/bin/bash

if [ "$1." = "." ]; then
	echo "The first parameter must be the IP Address/Name of the destination server."
	exit
fi

if [ "$2." = "." ]; then
	echo "Seriously you didn't enter a command to run on the command line!!!"
	exit
fi

if [ $USER != sachin.rathore ]; then
	echo "This MUST be run as sachin.rathore"
	exit
fi

if [ "$4." != "." ]; then
	echo "Copying file to server: $1"
fi

scp $2 sachin.rathore@$1:$3/.

if [ "$?" != 0 ]; then
        echo "Failed copying to server:"
        ssh -q sachin.rathore@$1 'uname -n'
fi

