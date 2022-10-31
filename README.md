# Stationeers server that runs inside a Docker container

**NOTE**: This image will install/update stationeers when it starts up. The path ```/home/steam/stationeers``` can be mounted on the host for data persistence.

## How to run the server

1. Set the environment variables you wish to modify from below
2. Optionally mount ```/home/steam/stationeers``` somewhere on the host or inside another container to keep your data safe
3. Enjoy!

The following environment variables are available:
```
SERVER_NAME          (DEFAULT: "A Docker Server" - Publicly visible server name)
WORLD_TYPE           (DEFAULT: "mars" - World type, mainly used for world type to start a new game)
WORLD_NAME           (DEFAULT: "Mars" - World name, mainly used for save names etc.)
SERVER_PLAYERS       (DEFAULT: "10" - Set the max number of players that can connect)
SERVER_AUTO_SAVE     (DEFAULT: "true" - Set to false if you do not want the server automatically saving)
SERVER_SAVE_INTERVAL (DEFAULT: "300" - Automatic save interval in seconds)
SERVER_DIFFICULTY    (DEFAULT: "Easy" - Set difficulty level to Easy, Normal or Stationeer)
GAME_PORT            (DEFAULT: "27016" - Used for both incoming client connections (Make sure this is forwarded and not firewalled))
SERVER_PASSWORD      (DEFAULT: "" - Server password)
SERVER_PUBLIC        (DEFAULT: "false" - Set to true if you want your server advertised on the public list)
AUTH_SECRET          (DEFAULT: "" - Set a password to use the serverrun command in the client)
```

## License

See [LICENSE](LICENSE).
