#!/bin/bash
#
#	Parameters
# 1 Keyspace File		- This contains a list of keyspaces to be repaired
# 2 Work Directory		- This is the directory where the cluster information files reside typically ~/centralRepair
# 3 CQL Host IP			- This is the IP of a host in the cluster to connect to.  It gathers the tables in keyspace
# 4 DC Parallel runs	- The number of concurrent threads to run in each DC.
# 5 Sleep seconds		- The number of seconds to sleep between checks for a finished thread.

export PATH=/home/russell.waliszewski/bin:/home/russell.waliszewski/lib:$PATH
wrkDir='/home/russell.waliszewski/centralRepair'
logFile='setFileNameLater.txt'
tokenDelimit='-'
totalDCs=0
newRunStarted=0
export FromUser="repair@"`uname -n`".com"

getKeyspaceTables() {
	cqlsh -u rsacassandra -p XCyota01! -e "select table_name from system_schema.tables where keyspace_name='$tenant';" |  sed 's/ //g' | sed '1,3 d' |head -n -2 |sort > $tenant.tables
}

createNodeTenantTables() {
	tblList=$(comm -23 $tenant.tables ignore.tables)
	for tblName in $tblList
	do

		dcFileList=$(ls *.dc.txt)
		for aDCFile in $dcFileList
		do
			periodCount=`echo "$aDCFile" | tr -cd '.' | wc -c`
			if [ "$periodCount." = "2." ]; then
				ipList=$(cat $aDCFile)
				for ipAddr in $ipList
				do
					echo "$tblName$tokenDelimit$ipAddr" >> $tenant.$aDCFile
				done

				# Repeatative I know
				if [ ! -f $tenant.$aDCFile.running ]; then
					touch $tenant.$aDCFile.running
					touch $tenant.$aDCFile.started
					cp $aDCFile.user $tenant.$aDCFile.user
				fi
			fi
		done

	done

	totalDCs=`ls $tenant.*.started |grep -c started`
}

checkForCompletedRuns() {
	aDCFile=$1
	runningFile=$2
	startedFile=$3

	if test -f "$runningFile"; then
		# This function will go through the running list and see if there is a "completed" message in the log file"
		cp $runningFile $tenant.tempFile.txt

		ipTblList=$(cat $runningFile)
		for ipTblLine in $ipTblList
		do
			ipAddr="$(cut -d$tokenDelimit -f2 <<<$ipTblLine)"
			tblName="$(cut -d$tokenDelimit -f1 <<<$ipTblLine)"

			nodeCount=`grep -c ' successfully$' output/$tenant.$tblName.$ipAddr.out`
			if [ "$nodeCount" = "1" ]; then
				grep -v "^$tblName$tokenDelimit$ipAddr\$" $tenant.tempFile.txt > $tenant.temp2File.txt; mv $tenant.temp2File.txt $tenant.tempFile.txt
				rm output/$tenant.$tblName.$ipAddr.out
			else
				nodeCount=`grep -c 'ERROR IN REPAIR' output/$tenant.$tblName.$ipAddr.out`
				if [ "$nodeCount" != "0" ]; then
					grep -v "^$tblName$tokenDelimit$ipAddr\$" $tenant.tempFile.txt > $tenant.temp2File.txt; mv $tenant.temp2File.txt $tenant.tempFile.txt
					mail -r $FromUser -s "$tenant repair ERROR" russell.waliszewski@outseer.com < output/$tenant.$tblName.$ipAddr.out
					# mail -r $FromUser -s "$tenant repair ERROR" -a "X-Priority:1" russell.waliszewski@outseer.com < output/$tenant.$tblName.$ipAddr.out
					rm output/$tenant.$tblName.$ipAddr.out
				fi
			fi
		done
		mv $tenant.tempFile.txt $runningFile
	fi
}

startNewRuns() {
	aDCFile=$1
	runningFile=$2
	startedFile=$3
	newRunStarted=0
	userName=$(cat $aDCFile.user)

	counter=`cat $runningFile |wc -l`
	if [ "$counter" != "$DCparallelruns" ]; then
		ipTblList=$(diff $aDCFile $startedFile | grep "<" | sed 's/^<\ //g')
		for ipTblLine in $ipTblList
		do
			ipAddr="$(cut -d$tokenDelimit -f2 <<<$ipTblLine)"
			tblName="$(cut -d$tokenDelimit -f1 <<<$ipTblLine)"

			nohup ssh -q $userName@$ipAddr "/home/$userName/bin/tableRepair.sh $tenant $tblName"  > output/$tenant.$tblName.$ipAddr.out 2>&1 &
			echo $ipTblLine >> $startedFile
			echo $ipTblLine >> $runningFile
			counter=`expr $counter + 1`
			if [ "$counter" = "$DCparallelruns" ]; then
				newRunStarted=1
				break
			fi
		done
	fi
}

displayRemainingNodeCount() {
	if [ "$newRunStarted." = "1." ]; then
		dcTotal=`cat $1 |wc -l`
		runTotal=`cat $2 |wc -l`
		procTotal=`cat $3 |wc -l`
		left=`expr $dcTotal - $procTotal + $runTotal`
		echo "$oneDCFile	$left nodes remaining" >>$logFile
		if [ "$left." = "0." ]; then
			rm $1
		fi
	fi
}



#
#		Initialization
#
continueLoop=1
startDate=`date`
startEpochSeconds=$(date +%s)


#	Parameter check
if [ "$1." = "." ]; then
	echo "No keyspace file specified" | mail -r $FromUser -s "$tenant repair parameters problem" russell.waliszewski@outseer.com
	exit
else
	keyspaceFile=$1
fi

if [ "$2." != "." ]; then
	wrkDir=$2
else
	echo "No Work Directory specified" | mail -r $FromUser -s "$tenant repair parameters problem" russell.waliszewski@outseer.com
	exit
fi

if [ "$3." != "." ]; then
	export CQLSH_HOST=$3
else
	echo "No Cassandra cluster node specified" | mail -r $FromUser -s "$tenant repair parameters problem" russell.waliszewski@outseer.com
	exit
fi

if [ "$4." = "." ]; then
	DCparallelruns=5
else
	DCparallelruns=$4
fi

if [ "$5." = "." ]; then
	sleepSeconds=5
else
	sleepSeconds=$5
fi

cd $wrkDir

# 	Grab a tenant
tenant=`head -1 $keyspaceFile`
grep -v "^$tenant$" $keyspaceFile > $keyspaceFile.tmp
echo $tenant >> $keyspaceFile.tmp
mv -f $keyspaceFile.tmp $keyspaceFile

logFile="$tenant.log"

getKeyspaceTables
createNodeTenantTables



#
#	Process the DC's
#	Continue to loop as long as there are remaining node/tables to process
#
while [ "$continueLoop." = "1." ]
do
	totalActiveRuns=0
	tmpAR=0

	dcFileList=$(ls $tenant.*.dc.txt)
	for oneDCFile in $dcFileList
	do
		checkForCompletedRuns $oneDCFile $oneDCFile.running $oneDCFile.started
		startNewRuns $oneDCFile $oneDCFile.running $oneDCFile.started
		displayRemainingNodeCount $oneDCFile $oneDCFile.running $oneDCFile.started

		tmpAR=`cat $oneDCFile.running |wc -l`
		if [ "$tmpAR" = "0" ]; then
			touch $oneDCFile.completed
		fi
		totalActiveRuns=`expr $tmpAR + $totalActiveRuns`
	done

	# If there is a stop file for the tenant let's stop everything
	if [ -f $tenant.stop ]; then
		rm -f $tenant.stop
		continueLoop=0
	else
		# Check to see if there are any active runs.
		if [ "$totalActiveRuns" != "0" ]; then
			sleep $sleepSeconds
		else
			continueLoop=0
		fi
	fi
done



#
#	Done final steps
#	Check for errors, send email out, cleanup
#
endDate=`date`
endEpochSeconds=$(date +%s)
startEndSeconds=$((endEpochSeconds - startEpochSeconds))

fileDate=`date '+%Y%m'`
echo "Keyspace: $tenant                         Date/Time: $startDate $endDate Difference (Mins: $startEndSeconds / 60)" >> $wrkDir/RepairHistory.$fileDate.txt 

# Cleanup
rm $tenant.*.txt
rm $tenant.*.running
rm $tenant.*.started
rm $tenant.*.completed
rm -rf $tenant.*.user
rm $tenant.tables
rm $logFile

