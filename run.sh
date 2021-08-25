#!/bin/bash

CMD="/server/${BINARY} $*"

echo "Starting server with the following arguments $*"

# Graceful shutdown of the server
function shutdown() {
	screen -S terraria -p 0 -X stuff 'exit\n'
	while screen -list | grep -q "terraria"; do
		sleep 1
	done
}

# Run server in detached screen
cd /tmp
screen -dmSL terraria $CMD
screen -S terraria -X colon "logfile flush 0^M"

# Keep reading logfile until shutdown
trap shutdown SIGTERM SIGINT
tail -Fn 0 /tmp/screenlog.0 &
wait