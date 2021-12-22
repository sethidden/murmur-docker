# Murmur-docker
[![Docker](https://img.shields.io/docker/pulls/sethidden/murmur)](https://hub.docker.com/r/sethidden/murmur)   [![Docker](https://img.shields.io/docker/image-size/sethidden/murmur)](https://hub.docker.com/r/sethidden/murmur)  
[![Docker](https://img.shields.io/badge/platform-linux/386%20|%20linux/amd64%20|%20linux/arm/v6%20|%20linux/arm/v7%20|%20linux/arm64%20|%20linux/ppc64le%20|%20linux/riscv64%20|%20linux/s390x-papayawhip)](https://hub.docker.com/r/sethidden/umurmur/tags)

Docker image for the official Murmur server for Mumble. Focused on CPU architecture support. For supported architectures, see [OS/ARCH column in dockerhub tags](https://hub.docker.com/r/sethidden/murmur/tags)

I made it because all the Murmur Docker images I found were published for the `amd64` architecture, but I wanted to run Murmur on my Raspberry Pi 4B, which has the `armv7` CPU architecture (or `arm64` if you run a 64-bit system).

## docker run and docker-compose

`docker run` and `docker-compose` examples are below

### docker run
```posh
docker run --name murmur --restart on-failure -p '64738:64738' -p '64738:64738/udp' -v '/home/user_on_host_machine/murmur.ini/:/etc/murmur.ini' sethidden/murmur:latest
```
### docker-compose

```yaml
version: "3.5"
services:
  murmur:
    container_name: murmur
    restart: on-failure
    ports:
        - '64738:64738'
        - '64738:64738/udp'
    volumes: 
      - '/home/user_on_host_machine/murmur.ini:/etc/murmur.ini'
    image: sethidden/murmur
```

If a new uMurmur version (and a new version of this image) comes out and your container is still using the old one, to update you can run `docker-compose pull umurmur` then `docker-compose up -d umurmur`.

## Acknowledgements

* the uMurmur team for letting us umurmur
* Jeremy Petit for his work on [umurmur-docker](https://github.com/gp3t1/umurmur-docker/)
* The Alpine Linux team for publishing a docker image that supports so many architectures out of the box
* Leonardo Arena for maintaining [Alpine's uMurmur package](https://pkgs.alpinelinux.org/packages?name=umurmur) and publishing it for so many architectures  

## License

Copyright (C) <2017> <gp3t1>

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
