FROM alpine:3.6

# UMURMUR BUILD SETTINGS
ARG BUILD_UMURMUR_MONITOR="On"
ARG BUILD_NUMURMON="On"
ARG SSL="openssl"
ARG VERSION="0.2.17"

LABEL maintainer="Jeremy PETIT <jeremy.petit@gmail.com>"

## CUSTOM UMURMUR UID/GID
ENV UMURMUR_USER="umurmur" 				UMURMUR_UID=500
ENV	UMURMUR_GROUP="$UMURMUR_USER"	UMURMUR_GUID=1000

## MURMUR BASE CONFIG (see /etc/umurmur/umurmurd.conf)
ENV LISTEN4 "" \
		LISTEN6 ""
ENV PASSWORD 				"" \
		ADMIN_PASSWORD 	""
ENV CERT_NAME "fullchain.pem" \
		KEY_NAME 	"privkey.pem"
ENV SHOW_IPS 		true \
		ENABLE_BAN 	true \
		SYNC_BAN 		true \
		ALLOW_TEXT 	true \
		LOGGING 		false
ENV MAX_USERS 				 10 \
		BAN_SECONDS 				0 \
		MAX_BANDWIDTH 	48000 \
		OPUS_THRESHOLD 		100
ENV MOTD "Welcome to umurmur server$(hostname -f)!"

## EXPOSE UMURMUR DEFAULT PORT
EXPOSE 64738:64738 64738:64738/udp

## VOLUMES FOR LOGS & CERTIFICATES
VOLUME ["/var/log", "/etc/umurmur/cert"]

## INSTALL USR/GRP TOOLS, BUILD TOOLS, PIP & J2
#  CREATE USER/GROUP
#  INSTALL MURMUR (apk add --no-cache umurmur)
RUN apk --no-cache add \
		mbedtls-dev \
		ncurses-dev \
	 	openssl-dev \
		protobuf-c-dev \
		py-pip \
		shadow
RUN 	echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories \
	&& 	apk --no-cache add -t build-dependencies \
			cmake \
			gcc \
			git \
			libc-dev \
			libconfig-dev \
			make \
	&& 	pip install --upgrade pip \
	&& 	pip install j2cli[yaml] \
	&& 	addgroup -g "${UMURMUR_GUID}" -S "${UMURMUR_GROUP}" 2>/dev/null \
	&& 	adduser  -u "${UMURMUR_UID}"  -S -D -h /var/run/umurmurd -s /bin/sh -G "${UMURMUR_GROUP}" -g "${UMURMUR_GROUP}" "${UMURMUR_USER}" 2>/dev/null \
	&& 	git clone --recursive -b "${VERSION}" "https://github.com/umurmur/umurmur.git" "/tmp/umurmur-src" \
	&& 	mkdir -p /tmp/umurmur \
	&& 	cd /tmp/umurmur \
	&& 	cmake -DSSL="$SSL" -DBUILD_UMURMUR_MONITOR="$BUILD_UMURMUR_MONITOR" -DBUILD_NUMURMON="$BUILD_NUMURMON" "/tmp/umurmur-src" \
	&& 	make \
	&& 	make install \
	&& 	rm -rf /tmp/umurmur* \
	&& 	mv /usr/local/etc/umurmur.conf /etc/umurmur/umurmurd.conf.default \
	&& 	apk del build-dependencies

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




