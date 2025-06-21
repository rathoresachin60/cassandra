#!/bin/bash

if [ "$1." = "." ]; then
	echo "The first parameter must be the IP Address/Name of the destination server."
	exit
fi

if [ "$2." = "." ]; then
	echo "Seriously you didn't enter a command to run on the command line!!!"
	exit
fi

if [ $USER != russell.waliszewski ]; then
	echo "This MUST be run as russell.waliszewski"
	exit
fi

if [ "$3." != "." ]; then
	echo "Running Command on: $1"
fi

ssh -q russell.waliszewski@$1 "$2"

if [ "$?" != 0 ]; then
        echo "Command failed on server:"
        ssh -q russell.waliszewski@$1 'uname -n'
fi

