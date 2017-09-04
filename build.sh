#!/bin/bash
set -x
build() {
	VERSION="$1"
	BUILD_UMURMUR_MONITOR="$2"
	BUILD_NUMURMON="$3"
	label="$VERSION"
	if "$BUILD_NUMURMON" && "$BUILD_UMURMUR_MONITOR"; then
		label="$label-full"
		docker build --build-arg SSL="openssl" --build-arg BUILD_NUMURMON=On --build-arg BUILD_UMURMUR_MONITOR=On -t "umurmur:$label" .
	elif "$BUILD_NUMURMON"; then
		label="$label-numurmon"
		docker build --build-arg SSL="openssl" --build-arg BUILD_NUMURMON=On -t "umurmur:$label" .
	elif "$BUILD_UMURMUR_MONITOR"; then
		label="$label-monitor"
		docker build --build-arg SSL="openssl" --build-arg BUILD_UMURMUR_MONITOR=On -t "umurmur:$label" .
	else
		docker build --build-arg SSL="openssl" -t "umurmur:$label" .
	fi
}

[[ -z "$1" ]] && exit 1
build "$1" false false
build "$1" true false
build "$1" false true
build "$1" true true

# docker build -t umurmur:0.2 . 
# docker run --rm -ti -p 64738:64738 -p 64738:64738/udp -e PASSWORD=toto umurmur:0.2