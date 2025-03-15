#!/bin/bash

FTRACE=/sys/kernel/debug/tracing

if (( $# <= 0 )); then
	echo "usage $0 <command>"
	echo -e "command list:
		on [timeout]
		off

		list-target
		set-target <target>
		get-target

		list-filter
		set-filter <target>
		get-filter

		list-option
		set-option <option> <value>
		get-option <option>

		result
	"
fi

case $1 in
	"on")
		echo 1 > $FTRACE/tracing_on

		if (( $# == 2 )); then
			sleep $2
			echo "tracing off"
			echo 0 > $FTRACE/tracing_on
		fi
	;;

	"off")
		echo 0 > $FTRACE/tracing_on
	;;

	"list-target")
		cat $FTRACE/available_tracers
	;;

	"set-target")
		echo $2 > $FTRACE/current_tracer
	;;

	"get-target")
		cat $FTRACE/current_tracer
	;;

	"list-filter")
		TARGET=$(cat $FTRACE/current_tracer)
		case $TARGET in
			"function" | "function_graph")	cat $FTRACE/available_filter_functions	;;
			"event")			cat $FTRACE/available_filter_events	;;
			*)				echo "no filter provided for $TARGET"	;;
		esac
	;;

	"set-filter")
		echo $2 > $FTRACE/set_ftrace_filter
	;;

	"get-filter")
		cat $FTRACE/set_ftrace_filter
	;;

	"list-option")
		ls $FTRACE/options/
	;;

	"set-option")
		echo $3 > $FTRACE/options/$2
	;;

	"get-option")
		cat $FTRACE/options/$2
	;;

	"result")
		cat $FTRACE/trace
	;;
esac
