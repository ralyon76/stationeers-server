# Stationeers server that runs inside a Docker container
This project is hosted at [https://github.com/ralyon76/stationeers-server](https://github.com/ralyon76/stationeers-server)

## Docker image info
The image is located on github's repository at `ghcr.io/ralyon76/stationeers-server`.

Making a volume for the install directory will keep the data stored between restarts, helping speed up startup and retaining save information. It should be mounted at `/home/steam/stationeers` and needs to be writeable by the steam user id 1000.

This image will install/update stationeers when it starts up and requires at about 3G of space and will grow with the server saves. On the first start, it will take several minutes to load as it downloads the dedicated server files from steam. 

With no environment variables set, it will create a new save on Mars at Easy difficulty that is NOT advertised in the public server list. Make sure to look over the `Environment variables` below to adjust the server settings for your use.

If you want to play with friends over the Internet and are behind NAT make sure that the UDP port (27016 is the default unless changed in the environment vairable) is forwarded to the container host. Also ensure it is publicly accessible in any firewall.

## How to run the server from Docker CLI
Make sure to adjust the port and environment variables for your setup

```
mkdir -p $HOME/stationeers
chown 1000.1000 $HOME/stationeers
docker run -d \
  --name stationeers-server \
  -p 27016:27016/udp \
  -v $HOME/stationeers:/home/steam/stationeers \
  -e SERVER_NAME="A Docker Server" \
  -e WORLD_TYPE="mars" \
  ghcr.io/ralyon76/stationeers-server
```

## How to run the server in Docker Compose
After downloading the yaml file, make sure to edit the port and environment variables for your setup

```
mkdir -p $HOME/stationeers/data
chown 1000.1000 $HOME/stationeers/data
cd $HOME/stationeers/
curl -o $HOME/stationeers/docker-compose.yml https://raw.githubusercontent.com/ralyon76/stationeers-server/main/docker-compose.yml
nano docker-compose.yml #Edit file accordingly
docker-compose up
```

## Environment variables
**All variable names and values are case-sensitive!**

| Name | Default | Purpose |
|----------|----------|-------|
| `SERVER_NAME` | `A Docker Server` | Publicly visible server name |
| `WORLD_TYPE` | `mars` | World type, mainly used for world type to start a new game |
| `WORLD_NAME` | `Mars` | World name, mainly used for save names etc. |
| `STATIONEERS_VERSION` | | Set to beta if you want to install the beta brach, anything else will run stable |
| `SERVER_PLAYERS` | `10` | Set the max number of players that can connect |
| `SERVER_AUTO_SAVE` | `true` | Set to false if you do not want the server automatically saving |
| `SERVER_SAVE_INTERVAL` | `300` | Automatic save interval in seconds |
| `SERVER_DIFFICULTY` | `Easy` | Set difficulty level to Easy, Normal or Stationeer |
| `GAME_PORT` | `27016` | Used for both incoming client connections (Make sure this is forwarded and not firewalled) |
| `SERVER_PASSWORD` | | Server password |
| `SERVER_PUBLIC` | `false` | Set to true if you want your server advertised on the public list |
| `AUTH_SECRET` | | Set a password to use the serverrun command in the client |

## License

See [LICENSE](LICENSE).
