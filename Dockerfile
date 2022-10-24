FROM steamcmd/steamcmd

LABEL maintainer="Ralyon"

# Create and set the steamcmd folder as a volume
RUN mkdir -p /steamcmd/stationeers

# Add the steamcmd installation script
ADD install.txt /app/install.txt

# Copy the startup script
ADD start_stationeers.sh /app/start.sh

# Set the current working directory
WORKDIR /

## More info about the new syntax for running the server from the developer:
# https://github.com/rocket2guns/StationeersDedicatedServerGuide

# Setup default environment variables for the server
ARG WORLD_NAME=Mars
ARG WORLD_TYPE=mars
ARG SERVER_DIFFICULTY=Easy
ARG SERVER_PUBLIC=false
ARG GAME_PORT=27016
ARG SERVER_NAME="A Docker Server"
ARG SERVER_PASSWORD=""
ARG SERVER_PLAYERS=10
ARG SERVER_AUTO_SAVE=true
ARG SERVER_SAVE_INTERVAL=300
ARG AUTH_SECRET=""
ENV STATIONEERS_WORLD_NAME=$WORLD_NAME
ENV STATIONEERS_WORLD_TYPE=$WORLD_TYPE
ENV STATIONEERS_SERVER_DIFFICULTY=$SERVER_DIFFICULTY
ENV STATIONEERS_SERVER_PUBLIC=$SERVER_PUBLIC
ENV STATIONEERS_GAME_PORT=$GAME_PORT
ENV STATIONEERS_SERVER_NAME=$SERVER_NAME
ENV STATIONEERS_SERVER_PASSWORD=$SERVER_PASSWORD
ENV STATIONEERS_SERVER_PLAYERS=$SERVER_PLAYERS
ENV STATIONEERS_SERVER_AUTO_SAVE=$SERVER_AUTO_SAVE
ENV STATIONEERS_SERVER_SAVE_INTERVAL=$SERVER_SAVE_INTERVAL
ENV STATIONEERS_AUTH_SECRET=$AUTH_SECRET

# Run as a non-root user by default
ENV PGID 1000
ENV PUID 1000

# Define directories to take ownership of
ENV CHOWN_DIRS "/app,/steamcmd"

# Start the server
ENTRYPOINT ["/app/start.sh"]
