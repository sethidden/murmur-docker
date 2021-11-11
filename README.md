# umurmur

Work in progress. This isn't published anywhere yet. If you're looking for an Umurmur docker image that works on non-x86 CPU architectures (e.g. Raspberry Pi) clone this repo and run `docker build .`, `docker image ls` (look for newly built image), `docker tag [newly built image id] umurmur`, then use `umurmur` image in your docker-compose (or `docker run umurmur`).

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
      - '/media/umurmur:/etc/umurmur'
```

## Acknowledgements

This is a fork of Jeremy Petit's work on https://github.com/gp3t1/umurmur/

## License

Copyright (C) <2017> <gp3t1>

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
