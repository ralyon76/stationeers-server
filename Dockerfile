FROM cm2network/steamcmd:root
ENV DEBIAN_FRONTEND=noninteractive
LABEL maintainer="Ralyon"

RUN apt-get update && apt-get upgrade -y && \
	apt-get install -y tmux && \
	rm -rf /var/lib/apt/lists/*

ENV INSTALLDIR="/home/steam/stationeers"
ENV STEAMCMDDIR="/home/steam/steamcmd"

# Copy the startup script
COPY --chmod=755 start_stationeers.sh ${INSTALLDIR}/start.sh

# Copy the defaults
COPY --chmod=755 defaults ${INSTALLDIR}/defaults

## More info about the new syntax for running the server from the developer:
# https://github.com/rocket2guns/StationeersDedicatedServerGuide

USER steam
WORKDIR "$INSTALLDIR"

# Start the server
ENTRYPOINT ["./start.sh"]
