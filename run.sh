#!/bin/bash

CMD="/server/${BINARY} $*"

RERUN="/server/run.sh $*"
CONFIG_PATH="/home/myuser/.local/share"

# Graceful shutdown of the server
function shutdown() {
	echo "Exiting gracefully..."
	screen -S terraria -p 0 -X stuff 'exit\n'
	while screen -list | grep -q "terraria"; do
		sleep 1
	done
}

# Switching to non-root user
if [ $(id -u) -eq 0 ]; then
	if ! id -u myuser &>/dev/null; then
		echo "Adding new user with specified UID: $UID & GID: $GID"
		groupadd -g $GID mygroup
		useradd -m -u $UID -g $GID myuser
		chown -R $UID:$GID /server /config
	fi
	echo "Switching to non-root user"
	exec gosu myuser $(echo $RERUN | xargs)
fi

# Check if .local exists. If not then create it and add a symlink to /config.
if [ ! -d $CONFIG_PATH ]; then
	echo "Creating .local folder and adding /config symlink"
	mkdir -p ~/.local/share && \
    ln -sT /config ~/.local/share/Terraria && \
	if [ ! -z $TMOD_VER ]; then
		if [ ! -d "${CONFIG_PATH}/Terraria/ModLoader/Mods/ModPacks" ]; then
			echo "Creating Modloader folders"
			mkdir -p ~/.local/share/Terraria/ModLoader/Mods/ModPacks
		fi
	fi
fi

echo "Starting server with the following arguments $*"

# Run server in detached screen
cd /tmp
screen -dmSL terraria $CMD
screen -S terraria -X colon "logfile flush 0^M"

# Keep reading logfile until shutdown
trap shutdown SIGTERM SIGINT
tail -Fn 0 /tmp/screenlog.0 &
wait
