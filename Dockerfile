FROM alpine:latest

# UMURMUR BUILD SETTINGS
ARG BUILD_UMURMUR_MONITOR="On"
ARG BUILD_NUMURMON="On"
ARG SSL="openssl"
ARG VERSION="0.2.17"

# shamelessly stolen from, or as we call it in open source "forked":
#LABEL maintainer="Jeremy PETIT <jeremy.petit@gmail.com>" \
	#description="alpine-based umurmurd image - audio chat server"

EXPOSE 64738 64738/udp
VOLUME ["/var/log/umurmur", "/var/lib/umurmur"]

RUN  apk --no-cache add \
			libconfig \
			openssl \
			protobuf-c \
	&& apk --no-cache add -t build-dependencies \
			cmake \
			gcc \
			git \
			libc-dev \
			libconfig-dev \
			make \
			ncurses-dev \
			openssl-dev \
			protobuf-c-dev \
	&& git clone --recursive -b "${VERSION}" "https://github.com/umurmur/umurmur.git" "/tmp/umurmur-src" \
	&& mkdir -p /tmp/umurmur \
	&& cd /tmp/umurmur \
	&& cmake -DSSL="$SSL" -DBUILD_UMURMUR_MONITOR="$BUILD_UMURMUR_MONITOR" -DBUILD_NUMURMON="$BUILD_NUMURMON" "/tmp/umurmur-src" \
	&& make \
	&& make install \
	&& rm -rf /tmp/umurmur* \
	&& apk --no-cache del build-dependencies

CMD ["/usr/local/bin/umurmurd","-d", "-c", "/etc/umurmur.conf"]
