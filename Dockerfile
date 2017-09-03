FROM alpine:3.6

MAINTAINER Jeremy PETIT <jeremy.petit@gmail.com>

## UMURMUR VERSION
ENV VERSION "0.2.17"

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
ENV CERT_NAME "fullchain.pem"
ENV KEY_NAME "privkey.pem"

## EXPOSE UMURMUR DEFAULT PORT
EXPOSE 64738:64738 64738:64738/udp

## VOLUMES FOR LOGS & CERTIFICATES
VOLUME ["/var/log", "/etc/umurmur/cert"]

## INSTALL USR/GRP TOOLS, BUILD TOOLS, PIP & J2
RUN  echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories \
	&& apk --no-cache add cmake \
												gcc \
												git \
												libc-dev \
												libconfig-dev \
												make \
												mbedtls-dev \
												ncurses-dev \
	 											openssl-dev \
												protobuf-c-dev \
												py-pip \
												shadow \
	&& pip install --upgrade pip \
	&& pip install j2cli[yaml]

## CREATE USER/GROUP
RUN  addgroup -g "${UMURMUR_GUID}" -S umurmur 2>/dev/null \
	&& adduser  -u "${UMURMUR_UID}"  -S -D -h /var/run/umurmurd -s /bin/false -G umurmur -g umurmur umurmur 2>/dev/null

## INSTALL MURMUR (apk add --no-cache umurmur) -BUILD_NUMURMON=On
RUN git clone --recursive -b "${VERSION}" "https://github.com/umurmur/umurmur.git" "/tmp/umurmur-src" \
	&& mkdir -p /tmp/umurmur \
	&& cd /tmp/umurmur \
	&& cmake -DSSL=openssl -DBUILD_UMURMUR_MONITOR=On -BUILD_NUMURMON=On "/tmp/umurmur-src" \
	&& make \
	&& make install -o umurmur -g umurmur \
	&& rm -rf /tmp/umurmur* \
	&& mv /usr/local/etc/umurmur.conf /etc/umurmur/umurmurd.conf.default

# COPY SCRIPTS & TEMPLATES
COPY bin/* /usr/bin/
COPY templates/* /templates/

# EXTRA INIT SCRIPTS & BAN FILE
RUN mkdir /docker-entrypoint-init.d
RUN touch /etc/umurmur/bans

CMD ["/usr/local/bin/umurmurd","-d","-c","/etc/umurmur/umurmurd.conf"]
ENTRYPOINT ["/usr/bin/entrypoint"]

# HEALTHCHECK --interval=1m \
# 	--timeout=3s \
# 	--start-period=30s \
#   --retries=2 \
#   CMD curl -f http://localhost/ || exit 1




