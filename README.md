# umurmur

umurmur dockerization that supports many CPU architectures e.g. amd32v7 for Raspberry Pi and others. For supported architectures, see (https://hub.docker.com/r/sethidden/umurmur/tags)[OS/ARCH column on dockerhub tags]

## Custom umurmur.conf/certs
To make the container use your umurmurd.conf, create a volume that points to the `/etc/umurmur/` folder in the container. By default, the `/etc/umurmur/`folder contains these files you can override with your volume:
* umurmurd.conf
* key.key (gets auto-created after first launch)
* cert.crt (gets auto-created after first launch)

## docker run
```sh
docker run -ti -p 64738:64738 -p 64738:64738/udp -v /home/user_on_host_machine/umurmur/:/etc/umurmur/ sethidden/umurmur:latest
```
## docker-compose

```yaml
version: "3.5"
services:
  umurmur:
    image: sethidden/umurmur
    container_name: umurmur
    restart: always
    ports:
        - '64738:64738'
        - '64738:64738/udp'
    volumes: 
      - '/home/user_on_host_machine/umurmur/:/etc/umurmur/'
```

## Acknowledgements

This is a fork of Jeremy Petit's work on https://github.com/gp3t1/umurmur/

## License

Copyright (C) <2017> <gp3t1>

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
