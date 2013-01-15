#!/bin/sh

###############################################################################
#2013.01.15 create by dancal.
###############################################################################

PATH=/home/static/throughput/wget_load
BINPATH="$PATH/bin"
DATAPATH="$PATH/data"
DUMPPATH="$PATH/dump"
TEMPPATH="$PATH/temp"
LOGPATH="$PATH/log"

URLSPLITLINE=10
OPERATIONTIME=60

CLIENTINCR=1
STARTCLINET=1
ENDEDCLINET=10

SHOWTITLE=1

###############################################################################
#URL 파일을 일정 라인으로 분리.
###############################################################################

/bin/rm -f $DATAPATH/*
/bin/rm -f $DUMPPATH/wget_*

pushd $DUMPPATH
/usr/bin/split -l $URLSPLITLINE $DUMPPATH/*.dat wget_
popd

###############################################################################
#
###############################################################################
INDEX=0
FILELIST=`/bin/ls ${DUMPPATH}/wget_*`
FLIST=($FILELIST)
for (( i=$STARTCLINET; i<=$ENDEDCLINET; i++ ))
do

	STIME=`echo $(($(/bin/date +%s%N)/1000000))`
	for (( a=0; a<$i; a++ ))
	do

		URL_FILE=${FLIST[$INDEX]}
		if [[ ! -f $URL_FILE ]]; then
			break
		fi

		$BINPATH/wget -nv -q -i $URL_FILE -z $OPERATIONTIME -O /dev/null > $TEMPPATH/request_${i}_${a}.log &

		INDEX=`/usr/bin/expr $INDEX + $CLIENTINCR`

	done

	wait

	ETIME=`echo $(($(/bin/date +%s%N)/1000000))`

	#$BINPATH/analysys.tcl $SHOWTITLE $PATH $i $OPERATIONTIME "$TEMPPATH/request_${i}_*"
	$BINPATH/analysys.tcl $SHOWTITLE $PATH $i $STIME $ETIME "$TEMPPATH/request_${i}_*"

	SHOWTITLE=0

done

