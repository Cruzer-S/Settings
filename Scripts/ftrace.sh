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

		set-pid <pid>
		get-pid <pid>

		list-option
		set-option <option> <value>
		get-option <option>

		result
	"

	exit
fi

TARGET=$(cat $FTRACE/current_tracer)

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
		if [[ $2 != "nop" ]]; then
			echo "" > $FTRACE/set_event
		fi
	;;

	"get-target")
		cat $FTRACE/current_tracer
	;;

	"list-filter")
		case $TARGET in
			"function" | "function_graph")	cat $FTRACE/available_filter_functions	;;
			"nop")				cat $FTRACE/available_events		;;
			*)				echo "no filter provided for $TARGET"	;;
		esac
	;;

	"set-filter")
		if [[ $TARGET == "nop" ]]; then
			echo $2 > $FTRACE/set_event
		else
			echo $2 > $FTRACE/set_ftrace_filter
		fi
	;;

	"get-filter")
		if [[ $TARGET == "nop" ]]; then
			cat $FTRACE/set_event
		else
			cat $FTRACE/set_ftrace_filter
		fi
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

	"set-pid")
		if [[ $TARGET == "nop" ]]; then
			echo $2 > $FTRACE/set_event_pid
		else
			echo $2 > $FTRACE/set_ftrace_pid
		fi
	;;

	"get-pid")
		if [[ $TARGET == "nop" ]]; then
			cat $FTRACE/set_event_pid
		else
			cat $FTRACE/set_ftrace_pid
		fi
	;;


	"result")
		cat $FTRACE/trace
	;;
esac
