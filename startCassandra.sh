#!/bin/bash

if [ $USER != russell.waliszewski ]; then
        echo "This MUST be run as russell.waliszewski"
        exit
fi

ipAddr=`hostname -I | awk '{print $1}'`

startCassandraNode.sh $ipAddr

