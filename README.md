# Docker-Terraria

This repository contains the dockerfiles necessary for building and running a dedicated simple terraria vanilla or modded (tModLoader) container. Apart from graceful shutdown the image does not add extra functionality to what is already provided in the server binaries. It is meant to be a convenient, yet flexible way to run a terraria server containerized. It is required to already have a Linux based system with docker running.

The vanilla image is up to date with the latest version of Terraria `1.4.2.3`

The tModLoader image is up to date with the latest version being `0.11.8.4`

## Building from source
After cloning into this repository two types of images can be build.

For a vanilla server, build the `Vanilla` folder with:
````
docker build -f Vanilla/Dockerfile . -t <image name>
````
For a tModLoader server, build the `tModLoader` folder with:
````
docker build -f tModLoader/Dockerfile . -t <image name>
````

## Starting the container
The command for starting the container exists out of two parts: the arguments related to organizing the [container](https://docs.docker.com/engine/reference/run/) and the arguments given to the [terraria server](https://terraria.fandom.com/wiki/Server#Command_line_parameters). In its abstract form it looks something like:
````
docker run -d <container args> <image name> <server args>
````

Those arguments are all based on preferences and it is encouraged to look into them a bit more. A couple of quickstart examples are given below.

### Simple vanilla large world
````
docker run -d --name=terraria-simple --restart unless-stopped -p 7777:7777 <image name> -world /config/Worlds/basic.wld -autocreate 3
````
### Importing pre-generated world
Create a folder with the following structure:
````
<folder name>
└── Worlds
    └── <world name>.wld
````
Then mount that folder to the `/config` volume of the container like:
````
docker run -d --name=terraria-pregen --restart unless-stopped -p 7777:7777 -v <path to folder>/<folder name>:/config <image name> -world /config/Worlds/<world name>.wld
````
### Importing configuration file
Create a configuration file using the [wiki](https://terraria.fandom.com/wiki/Server#Server_config_file) or the provided `serverconfig.txt` template and create a folder for it:
````
<folder name>
└── serverconfig.txt
````
Then mount that folder to the `/config` volume of the container like:
````
docker run -d --name=terraria-config --restart unless-stopped -p 7777:7777 -v <path to folder>/<folder name>:/config <image name> -config /config/serverconfig.txt
````
### tModLoader
All of the previous examples can still be applied when using mods, however the mounted folder structure is slightly different. Here is an example when only having the CalamityMod installed and using a configuration file.
````
<folder name>
├── ModLoader
│   └── Mods
│       ├── CalamityMod.tmod
│       └── enabled.json
│   └── Worlds
└── serverconfig.txt
````
The server can then be ran the same as the configuration file example.

## Manual commands
It is also possible to log into the container and run the server commands manually, for example to send a server message to all players.
````
docker exec -it <container name> /bin/bash
screen -r
say It's over Anakin! I have the high ground!
````
A list of all commands can be found [here](https://terraria.fandom.com/wiki/Server#List_of_console_commands).

## Different Terraria/tModLoader versions
One thing is for certain, things change. This also applies for Terraria and tModLoader versions. If in the future new versions are released, it might be still possible to build and run the images by changing the environment variables of it. These can be passed as arguments when starting the containers.

For a vanilla server:
````
docker run -d -e VANILLA_VER=1423 <container args> <image name> <server args>
````
For a tModLoader server:
````
docker run -d -e TMOD_VER=0.11.8.4 <container args> <image name> <server args>
````
A list of all possible environment variables can be found in the following table.

| General | Vanilla environment variable | tModLoader environment variable |
| :--: | :--: | :--: |
| version | VANILLA_VER | TMOD_VER |
| url | VANILLA_URL | TMOD_URL |
| .zip name | VANILLA_ZIP | TMOD_ZIP |
| executable | BINARY | BINARY |
