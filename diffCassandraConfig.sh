#!/bin/bash

uname -n

sudo diff /home/russell.waliszewski/cassandraConfigFiles/cassandra-env.sh /opt/aa/latest/installs/dse/resources/cassandra/conf/. >/dev/null
if [ "$?" != 0 ]; then
        echo "cassandra-env.sh is different"
fi

sudo diff /home/russell.waliszewski/cassandraConfigFiles/cassandra.yaml /opt/aa/latest/installs/dse/resources/cassandra/conf/. >/dev/null
if [ "$?" != 0 ]; then
        echo "cassandra.yaml is different"
fi

sudo diff /home/russell.waliszewski/cassandraConfigFiles/jvm.options /opt/aa/latest/installs/dse/resources/cassandra/conf/. >/dev/null
if [ "$?" != 0 ]; then
        echo "jvm.options is different"
fi

sudo diff /home/russell.waliszewski/cassandraConfigFiles/logback.xml /opt/aa/latest/installs/dse/resources/cassandra/conf/. >/dev/null
if [ "$?" != 0 ]; then
        echo "logback.xml is different"
fi

sudo diff /home/russell.waliszewski/cassandraConfigFiles/dse.yaml /opt/aa/latest/installs/dse/resources/dse/conf/. >/dev/null
if [ "$?" != 0 ]; then
        echo "dse.yaml is different"
fi


