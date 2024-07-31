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
	if [ -z "$2" ]; then
		echo "Download latest version of Spigot"
		VERSION="latest"
	else
		echo "Download $2 version of Spigot"
		VERSION=$2
	fi

	dnf install java-latest-openjdk java-latest-openjdk-devel -y

	DIR=$(mktemp -d)
	OUTPUT=$(pwd)/$SERVER

	pushd $DIR

	wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
	if [ ! -f BuildTools.jar ]; then
		echo "Failed to download BuildTools.jar"
		exit 1
	fi

	echo "Build $SERVER file..."
	java -jar BuildTools.jar --rev $VERSION --final-name spigot.jar > /dev/null
	mv spigot.jar $OUTPUT
	echo "Done!"

	popd

	rm -rf $DIR

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
