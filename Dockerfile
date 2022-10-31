FROM cm2network/steamcmd:root
ENV DEBIAN_FRONTEND=noninteractive
LABEL maintainer="Ralyon"

RUN apt-get update && apt-get upgrade -y && \
	apt-get install -y tmux && \
	rm -rf /var/lib/apt/lists/*

ENV INSTALLDIR="/home/steam/stationeers/"

# Copy the startup script
ADD start_stationeers.sh ${INSTALLDIR}start.sh

# Copy the defaults
ADD defaults ${INSTALLDIR}defaults

# Set permissions on folder
RUN ["chmod", "a+x", "${INSTALLDIR}start.sh"]

## More info about the new syntax for running the server from the developer:
# https://github.com/rocket2guns/StationeersDedicatedServerGuide

USER steam
RUN ./steamcmd.sh +force_install_dir "$INSTALLDIR" +login anonymous +app_update 600760 validate +quit
WORKDIR "$INSTALLDIR"

# Start the server
ENTRYPOINT ["tmux", "new", "./start.sh"]
