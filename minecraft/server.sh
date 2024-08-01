#!/bin/bash

SESSION="minecraft"

MINRAM=1024M
MAXRAM=2048M

SERVER="server.jar"

USAGE="usage: $0 <command>

commands: install, start, stop, open"

if [ $# -eq 0 ]; then
	echo "$USAGE"
	exit 1
fi

if [[ $UID != 0 ]]; then
	echo "Please run this script with sudo"
	echo "sudo $0 $*"
	exit 1
fi

if [ $1 = "install" ]; then
	echo "Install prerequisite packages"
	dnf install java java-latest-openjdk java-latest-openjdk-devel -y --quiet

	if [ -z "$2" ]; then
		echo "Download latest version of Spigot"
		VERSION="latest"
	else
		echo "Download $2 version of Spigot"
		VERSION=$2
	fi

	DIR=$(sudo -u $SUDO_USER mktemp -d)
	OUTPUT=$(pwd)/$SERVER
	UHOME=$(eval echo ~$SUDO_USER)

	pushd $DIR > /dev/null

	sudo -u $SUDO_USER wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar --quiet
	if [ ! -f BuildTools.jar ]; then
		echo "Failed to download BuildTools.jar"
		exit 1
	fi

	if [ -d $UHOME/.m2/ ]; then
		echo "Backup .m2 directory"
		mv $UHOME/.m2/ $UHOME/.m2_backup/
	fi

	echo "Build $SERVER file (It takes a long time)..."
	sudo -u $SUDO_USER java -jar BuildTools.jar --rev $VERSION --final-name spigot.jar > /dev/null 2>&1
	mv spigot.jar $OUTPUT
	mkdir -p $UHOME/.m2/
	echo "Done!"

	popd > /dev/null

	echo "Cleanup"
	rm -r $DIR $UHOME/.m2/

	if [ -d $UHOME/.m2_backup/ ]; then
		echo "Restore .m2 directory"
		mv $UHOME/.m2_backup/
	fi

	echo "output: $OUTPUT"

	exit 0
fi

if [ $1 = "start" ]; then
	if [ ! -f eula.txt ]; then
		echo "eula=true" >> eula.txt
	fi

	if [ $(firewall-cmd --state) == "running" ]; then
		echo "firewall: open 25565 port"
		firewall-cmd --add-port=25565/tcp --permanent
		firewall-cmd --reload
	fi
	echo "start minecraft server."
	screen -dmS $SESSION java -Xms$MINRAM -Xmx$MAXRAM -jar server.jar nogui
elif [ $1 = "stop" ]; then
	echo "stop minecraft server."
	screen -S $SESSION -p 0 -X stuff "stop\r"
	if [ $(firewall-cmd --state) == "running" ]; then
		echo "firewall: close 25565 port"
		firewall-cmd --remove-port=25565/tcp --permanent
		firewall-cmd --reload
	fi
elif [ $1 = "open" ]; then
	screen -r $SESSION
else
	echo $USAGE
fi
