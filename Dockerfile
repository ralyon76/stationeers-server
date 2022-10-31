FROM steamcmd/steamcmd
ENV DEBIAN_FRONTEND=noninteractive
LABEL maintainer="Ralyon"

# Create and set the steamcmd folder as a volume
RUN mkdir -p /steamcmd/stationeers

# Add the steamcmd installation script
ADD install.txt /app/install.txt

# Copy the startup script
ADD start_stationeers.sh /app/start.sh

# Copy the defaults
ADD defaults /app/defaults

# Set permissions on folder
RUN chown -r 1000.1000 /app

# Set the current working directory
WORKDIR /

## More info about the new syntax for running the server from the developer:
# https://github.com/rocket2guns/StationeersDedicatedServerGuide

# Run as a non-root user by default
ENV PGID 1000
ENV PUID 1000

# Define directories to take ownership of
ENV CHOWN_DIRS "/app,/steamcmd"

# Start the server
ENTRYPOINT ["/app/start.sh"]
