#!/usr/bin/env bash

# Enable debugging
#set -x

# Setup error handling
set -e
set -o pipefail

# Print the user we're currently running as
echo "Running as user: $(whoami)"

# Define the exit handler
exit_handler()
{
        echo ""
        echo "Waiting for server to shutdown.."
        echo ""
        kill -SIGINT "$child"
        sleep 5

        echo ""
        echo "Terminating.."
        echo ""
        exit
}

# Trap specific signals and forward to the exit handler
trap 'exit_handler' SIGHUP SIGINT SIGQUIT SIGTERM

# Check that Stationeers exists in the first place
if [ ! -f "/steamcmd/stationeers/rocketstation_DedicatedServer.x86_64" ]; then
        # Install Stationeers from install.txt
        echo ""
        echo "Installing Stationeers.."
        echo ""
        bash /steamcmd/steamcmd.sh +runscript /app/install.txt
else
        # Install Stationeers from install.txt
        echo ""
        echo "Updating Stationeers.."
        echo ""
        bash /steamcmd/steamcmd.sh +runscript /app/install.txt
fi

# Set the world name
if [ ! -z ${STATIONEERS_WORLD_NAME+x} ]; then
       STATIONEERS_STARTUP_COMMAND="-loadlatest ${STATIONEERS_WORLD_NAME}"
fi

# Set the world type
if [ ! -z ${STATIONEERS_WORLD_TYPE+x} ]; then
       STATIONEERS_STARTUP_COMMAND="${STATIONEERS_STARTUP_COMMAND} ${STATIONEERS_WORLD_TYPE}"
fi

# Add logfile location
STATIONEERS_STARTUP_COMMAND="${STATIONEERS_STARTUP_COMMAND} -logfile /steamcmd/stationeers/dedi_logging.txt"

# Set the server difficulty
if [ ! -z ${STATIONEERS_SERVER_DIFFICULTY+x} ]; then
        STATIONEERS_STARTUP_COMMAND="${STATIONEERS_STARTUP_COMMAND} -difficulty ${STATIONEERS_SERVER_DIFFICULTY}"
fi

# Add the settings string
STATIONEERS_STARTUP_SETTINGS="-settings StartLocalHost true"

# Set whether the server is visible on the public list
if [ ! -z ${STATIONEERS_SERVER_PUBLIC+x} ]; then
        STATIONEERS_STARTUP_SETTINGS="${STATIONEERS_STARTUP_SETTINGS} ServerVisible ${STATIONEERS_SERVER_PUBLIC}"
fi

# Set the game port
if [ ! -z ${STATIONEERS_GAME_PORT+x} ]; then
        STATIONEERS_STARTUP_SETTINGS="${STATIONEERS_STARTUP_SETTINGS} GamePort ${STATIONEERS_GAME_PORT}"
fi

# Set the server name
if [ ! -z ${STATIONEERS_SERVER_NAME+x} ]; then
        STATIONEERS_STARTUP_SETTINGS="${STATIONEERS_STARTUP_SETTINGS} ServerName ${STATIONEERS_SERVER_NAME}"
fi

# Set the server password
if [ ! -z ${STATIONEERS_SERVER_PASSWORD+x} ]; then
        STATIONEERS_STARTUP_SETTINGS="${STATIONEERS_STARTUP_SETTINGS} ServerPassword ${STATIONEERS_SERVER_PASSWORD}"
fi

# Set the max players allowed on the server
if [ ! -z ${STATIONEERS_SERVER_PLAYERS+x} ]; then
        STATIONEERS_STARTUP_SETTINGS="${STATIONEERS_STARTUP_SETTINGS} ServerMaxPlayers ${STATIONEERS_SERVER_PLAYERS}"
fi

# Enable or disable auto-save
if [ ! -z ${STATIONEERS_SERVER_AUTO_SAVE+x} ]; then
        STATIONEERS_STARTUP_SETTINGS="${STATIONEERS_STARTUP_SETTINGS} AutoSave ${STATIONEERS_SERVER_AUTO_SAVE}"
fi

# Set the auto-save interval
if [ ! -z ${STATIONEERS_SERVER_SAVE_INTERVAL+x} ]; then
        STATIONEERS_STARTUP_SETTINGS="${STATIONEERS_STARTUP_SETTINGS} SaveInterval ${STATIONEERS_SERVER_SAVE_INTERVAL}"
fi

# Set the server admin password
if [ ! -z ${STATIONEERS_AUTH_SECRET+x} ]; then
        STATIONEERS_STARTUP_SETTINGS="${STATIONEERS_STARTUP_SETTINGS} ServerAuthSecret ${STATIONEERS_AUTH_SECRET}"
fi

# Set the working directory
cd /steamcmd/stationeers || exit

# Run the server
echo ""
echo "Starting Stationeers with arguments: ${STATIONEERS_STARTUP_COMMAND} ${STATIONEERS_STARTUP_SETTINGS}"
echo ""
./rocketstation_DedicatedServer.x86_64 \
  ${STATIONEERS_STARTUP_COMMAND} \
  ${STATIONEERS_STARTUP_SETTINGS}
  2>&1 &

child=$!
wait "$child"
