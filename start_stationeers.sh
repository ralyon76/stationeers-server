#!/bin/bash

# Include defaults
/app/defaults

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
if [ ! -z ${WORLD_NAME+x} ]; then
       STARTUP_COMMAND="-loadlatest ${WORLD_NAME}"
fi

# Set the world type
if [ ! -z ${WORLD_TYPE+x} ]; then
       STARTUP_COMMAND="${STARTUP_COMMAND} ${WORLD_TYPE}"
fi

# Add logfile location
STARTUP_COMMAND="${STARTUP_COMMAND} -logfile /steamcmd/stationeers/dedi_logging.txt"

# Set the server difficulty
if [ ! -z ${SERVER_DIFFICULTY+x} ]; then
        STARTUP_COMMAND="${STARTUP_COMMAND} -difficulty ${SERVER_DIFFICULTY}"
fi

# Add the settings string
STARTUP_SETTINGS="-settings StartLocalHost true"

# Set whether the server is visible on the public list
if [ ! -z ${SERVER_PUBLIC+x} ]; then
        STARTUP_SETTINGS="${STARTUP_SETTINGS} ServerVisible ${SERVER_PUBLIC}"
fi

# Set the game port
if [ ! -z ${GAME_PORT+x} ]; then
        STARTUP_SETTINGS="${STARTUP_SETTINGS} GamePort ${GAME_PORT}"
fi

# Set the server name
if [ ! -z ${SERVER_NAME+x} ]; then
        STARTUP_SETTINGS="${STARTUP_SETTINGS} ServerName ${SERVER_NAME}"
fi

# Set the server password
if [ ! -z ${SERVER_PASSWORD+x} ]; then
        STARTUP_SETTINGS="${STARTUP_SETTINGS} ServerPassword ${SERVER_PASSWORD}"
fi

# Set the max players allowed on the server
if [ ! -z ${SERVER_PLAYERS+x} ]; then
        STARTUP_SETTINGS="${STARTUP_SETTINGS} ServerMaxPlayers ${SERVER_PLAYERS}"
fi

# Enable or disable auto-save
if [ ! -z ${SERVER_AUTO_SAVE+x} ]; then
        STARTUP_SETTINGS="${STARTUP_SETTINGS} AutoSave ${SERVER_AUTO_SAVE}"
fi

# Set the auto-save interval
if [ ! -z ${SERVER_SAVE_INTERVAL+x} ]; then
        STARTUP_SETTINGS="${STARTUP_SETTINGS} SaveInterval ${SERVER_SAVE_INTERVAL}"
fi

# Set the server admin password
if [ ! -z ${AUTH_SECRET+x} ]; then
        STARTUP_SETTINGS="${STARTUP_SETTINGS} ServerAuthSecret ${AUTH_SECRET}"
fi

# Set the working directory
cd /steamcmd/stationeers || exit

# Run the server
echo ""
echo "Starting Stationeers with arguments: ${STARTUP_COMMAND} ${STARTUP_SETTINGS}"
echo ""
./rocketstation_DedicatedServer.x86_64 \
  ${STARTUP_COMMAND} \
  ${STARTUP_SETTINGS}
  2>&1 &

child=$!
wait "$child"
