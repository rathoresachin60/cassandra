#!/bin/bash

if [ $USER != sachin.rathore ]; then
        echo "This MUST be run as sachin.rathore"
        exit
fi

ipAddr=`hostname -I | awk '{print $1}'`

stopCassandraNode.sh $ipAddr

