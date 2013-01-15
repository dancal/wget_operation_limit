#!/usr/bin/tclsh

set SHOWTITLE		[ lindex $argv 0 ]
set PATH			[ lindex $argv 1 ]
set STARTCLINET		[ lindex $argv 2 ]
set OPSTIME			[ lindex $argv 3 ]
set OPETIME			[ lindex $argv 4 ]
set LOGNAMES		[ lindex $argv 5 ]

set OPERATIONTIME	[ expr ($OPETIME - $OPSTIME) / 1000.0 ]
if { [ catch {
	set lsLogList	[ exec /bin/sh -c "/bin/ls $LOGNAMES" ]
} sErr ] } {
	puts "[ERROR]STARTCLINET : $STARTCLINET, OPERATIONTIME : $OPERATIONTIME, $sErr"
	return
}

array set rStatusCode {}

set nTotalRequest	0
set nResponseTime	0
set nResponseByte	0
set nTransRate		0

set nResponseTime0	0
set nResponseTime1	0
set nResponseTime2	0
set nResponseTime3	0
set nResponseTime4	0
set nResponseTime5	0

foreach  sFile $lsLogList {

	#OK  200 0.128519    7   1000000 http://adtg.widerplanet.com/status/index.html

	set lsTemp		[ exec /bin/cat $sFile ]
	foreach { str code responsetime responsebyte transrate url } $lsTemp {

		set nResponseTime	[ expr $nResponseTime + $responsetime ] 
		set nResponseByte	[ expr $nResponseByte + $responsebyte ]
		set nTransRate		[ expr $nTransRate + $transrate ]

		if { $responsetime < 1.0 } {
			incr nResponseTime0
		} elseif { $responsetime < 2.0 } {
			incr nResponseTime1
		} elseif { $responsetime < 3.0 } {
			incr nResponseTime2
		} elseif { $responsetime < 4.0 } {
			incr nResponseTime3
		} elseif { $responsetime < 5.0 } {
			incr nResponseTime4
		} else {
			incr nResponseTime5
		}

		if { ![ info exists rStatusCode($code) ] } {
			set rStatusCode($code)	0
		}
		incr rStatusCode($code)

		incr nTotalRequest

	}

}

set nAvgRequest			[ expr $nTotalRequest / ${OPERATIONTIME} ]
set nAvgResponseByte	[ expr $nResponseByte / ${nTotalRequest}.0 ]
set nAvgResponseTime	[ expr $nResponseTime / ${nTotalRequest}.0 ]
set nAvgTransferSpeed	[ expr $nTransRate / ${nTotalRequest}.0 ]

if { $SHOWTITLE == 1 } {
	puts -nonewline "thread,op_time,total_request,avgrequest/secs,avgresponse/secs,avgresponse_byte/sec,avgtrans/secs,"
	puts -nonewline "0sec,1sec,2sec,3sec,4sec,5sec over,"
	puts "total_response_time,total_response_byte,total_trans_byte/secs,status..."
}

puts -nonewline "${STARTCLINET},${OPERATIONTIME}"
puts -nonewline ",${nTotalRequest},${nAvgRequest},${nAvgResponseTime},${nAvgResponseByte},${nAvgTransferSpeed}"
puts -nonewline ",${nResponseTime0},${nResponseTime1},${nResponseTime2},${nResponseTime3},${nResponseTime4},${nResponseTime5}"
puts -nonewline ",${nResponseTime},${nResponseByte},${nTransRate}"
foreach key [ array names rStatusCode ] {
	puts -nonewline ",$key,$rStatusCode($key)"
}
puts ""
