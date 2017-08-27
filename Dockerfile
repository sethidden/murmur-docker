FROM alpine:3.6

MAINTAINER Jeremy PETIT <jeremy.petit@gmail.com>

## CUSTOM UMURMUR UID/GID
ENV UMURMUR_UID 500
ENV UMURMUR_GUID 1000

## MURMUR BASE CONFIG (see /etc/umurmur/umurmurd.conf)
ENV LISTEN4 ""
ENV LISTEN6 ""
ENV PASSWORD ""
ENV ADMIN_PASSWORD ""
ENV MAX_USERS 10
ENV SHOW_IPS true
ENV ENABLE_BAN true
ENV SYNC_BAN true
ENV BAN_SECONDS 0
ENV MAX_BANDWIDTH 48000
ENV OPUS_THRESHOLD 100
ENV MOTD "Welcome to umurmur server$(hostname -f)!"
ENV ALLOW_TEXT true
ENV LOGGING false

## EXPOSE UMURMUR DEFAULT PORT
EXPOSE 64738:64738 64738:64738/udp

## VOLUMES FOR LOGS & CERTIFICATES
VOLUME ["/var/log", "/etc/umurmur/cert"]

## INSTALL UMURMUR & ARCHIVE DEFAULT CONFIG
RUN  apk add --no-cache umurmur \
	&& mv /etc/umurmur/umurmurd.conf /etc/umurmur/umurmurd.conf.default

## INSTALL USR/GRP TOOLS, PIP & J2
RUN  echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories \
	&& apk --no-cache add shadow py2-pip \
	&& pip install j2cli[yaml]

# COPY SCRIPTS & TEMPLATES
COPY bin/* /usr/bin/
COPY templates/* /templates/

# EXTRA INIT SCRIPTS & BAN FILE
RUN mkdir /docker-entrypoint-init.d
RUN touch /etc/umurmur/bans

CMD ["/usr/bin/umurmurd","-d","-c","/etc/umurmur/umurmurd.conf"]
ENTRYPOINT ["/usr/bin/entrypoint"]