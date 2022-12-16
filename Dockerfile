FROM cm2network/steamcmd:root
ENV DEBIAN_FRONTEND=noninteractive
LABEL maintainer="Ralyon: ralyon76+gh@gmail.com"

RUN apt-get update && apt-get upgrade -y && \
	apt-get install -y tmux && \
	sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list && \
	apt-get update && apt-get install -y libc6 libstdc++6 && \
	sed -i 's/bookworm/bullseye/g' /etc/apt/sources.list && \
	rm -rf /var/lib/apt/lists/*

ENV INSTALLDIR="/home/steam/stationeers"
ENV STEAMCMDDIR="/home/steam/steamcmd"

# Copy the startup script
COPY --chmod=755 start_stationeers.sh /app/start.sh

# Copy the defaults
COPY --chmod=755 defaults /app/defaults

## More info about the new syntax for running the server from the developer:
# https://github.com/rocket2guns/StationeersDedicatedServerGuide

USER steam
WORKDIR "$INSTALLDIR"

# Start the server
ENTRYPOINT ["/app/start.sh"]
