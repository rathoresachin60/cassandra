#! /bin/bash

# Three Parameters
# 1 - Keyspace
# 2 - Table Name
# 3 - PK Value of the record

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

# On that node find which SSTables contain the record
# Copy the sstable files to another directory
SStables=`nodetool -u rsacassandra -pw XCyota01! getsstables -- $1 $2 $3`
for oneTable in $SStables
do
	length=`expr length $oneTable`
	length=$(($length-11))
	partFile=`expr substr $oneTable 1 $length`
	cp $partFile* .
done


# Use sstabledump on the copied files to get the data.
SStables=`ls *-big-Data.db`
for oneTable in $SStables
do
	sudo $C_HOME/tools/bin/sstabledump $oneTable -k $3
done

