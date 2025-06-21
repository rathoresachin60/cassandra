#!/bin/bash

if [ "$1." = "." ]; then
	echo "You need to enter a 'Type' acceptable values are 'Primary/DR/ALL'. It is case sensitive "
	exit
fi

if [ $USER != russell.waliszewski ]; then
	echo "This MUST be run as russell.waliszewski"
	exit
fi

if [ "$1" = "Primary" ]; then
	cat ~/bin/IPList.txt |grep 'uep1' | sort -n
	exit
fi

if [ "$1" = "ALL" ]; then
	cat ~/bin/IPList.txt | sort -n
	exit
fi

if [ "$1" = "DR" ]; then
	cat ~/bin/IPList.txt |grep 'ucp1' | sort -n
	exit
fi

echo "You need to enter an acceptable value 'Primary/DR/ALL'. It is case sensitive "

