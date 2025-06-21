#! /bin/bash

# Three Parameters
# 1 - Keyspace
# 2 - Table Name

if [ "$2." = "." ]; then
	echo You are missing parameters.
	exit
fi

if [ ! -d "/mnt/cassandra-log/tmp/SSTables" ] 
then
	sudo mkdir /mnt/cassandra-log/tmp/SSTables
	sudo chmod 777 /mnt/cassandra-log/tmp/SSTables
fi

cd /mnt/cassandra-log/tmp/SSTables
sudo rm -rf *

# Copy the sstable files to another directory
cp /mnt/cassandra/data/$1/$2-*/* .

# Use sstabledump on the copied files to get the data.
SStables=`ls *-big-Data.db`
for oneTable in $SStables
do
	sudo $C_HOME/tools/bin/sstabledump $oneTable -e  | awk '{OFS="\n"; $1=$1}1' |grep -v '\]'  >> allKeys.txt
done

