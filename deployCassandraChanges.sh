#!/bin/bash

#
#	For Each file force copy to correct location and then set appropriate privs
#

sudo cp -f /home/russell.waliszewski/cassandraConfigFiles/cassandra-env.sh /opt/aa/latest/installs/dse/resources/cassandra/conf/.
sudo chown rsaop:rsaop /opt/aa/latest/installs/dse/resources/cassandra/conf/cassandra-env.sh
sudo chmod 755 /opt/aa/latest/installs/dse/resources/cassandra/conf/cassandra-env.sh

sudo cp -f /home/russell.waliszewski/cassandraConfigFiles/cassandra.yaml /opt/aa/latest/installs/dse/resources/cassandra/conf/.
sudo chown rsaop:rsaop /opt/aa/latest/installs/dse/resources/cassandra/conf/cassandra.yaml
sudo chmod 755 /opt/aa/latest/installs/dse/resources/cassandra/conf/cassandra.yaml

sudo cp -f /home/russell.waliszewski/cassandraConfigFiles/jvm.options /opt/aa/latest/installs/dse/resources/cassandra/conf/.
sudo chown rsaop:rsaop /opt/aa/latest/installs/dse/resources/cassandra/conf/jvm.options
sudo chmod 755 /opt/aa/latest/installs/dse/resources/cassandra/conf/jvm.options

sudo cp -f /home/russell.waliszewski/cassandraConfigFiles/logback.xml /opt/aa/latest/installs/dse/resources/cassandra/conf/.
sudo chown rsaop:rsaop /opt/aa/latest/installs/dse/resources/cassandra/conf/logback.xml
sudo chmod 755 /opt/aa/latest/installs/dse/resources/cassandra/conf/logback.xml

sudo cp -f /home/russell.waliszewski/cassandraConfigFiles/dse.yaml /opt/aa/latest/installs/dse/resources/dse/conf/.
sudo chown rsaop:rsaop /opt/aa/latest/installs/dse/resources/dse/conf/dse.yaml
sudo chmod 755 /opt/aa/latest/installs/dse/resources/dse/conf/dse.yaml


