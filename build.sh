#!/bin/bash
set -x
build() {
	[[ $# -lt 3 ]] && [[ $# -gt 4 ]] && exit 1
	VER="$1"
	BUILD_UMURMUR_MONITOR="$2"
	BUILD_NUMURMON="$3"
	UMURMUR_VERSION="${4:-0.2.17}"
	label="$UMURMUR_VERSION-$VER"
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

umurmur-release
https://cloud.docker.com/api/build/v1/source/2e02c70c-7382-4412-ab1c-034b0521ae61/trigger/d36a9273-7cb5-412a-acdc-0be97a5303f1/call/

# TODO: https://docs.docker.com/apidocs/docker-cloud/#authentication
# https://docs.docker.com/apidocs/docker-cloud/#registries
# https://docs.docker.com/apidocs/docker-cloud/#triggers
BUILDER_API_KEY=05f46db7-eeea-4cee-a792-c127731a8d27
curl -H "Authorization: Basic $BUILDER_API_KEY" -H "Accept: application/json" https://cloud.docker.com/api/app/v1/service/

-- get all registries
GET /api/repo/v1/registry/ HTTP/1.1
Host: cloud.docker.com
Authorization: Basic dXNlcm5hbWU6YXBpa2V5
Accept: application/json

curl -u gp3t1:05f46db7-eeea-4cee-a792-c127731a8d27 \
	-H "Accept: application/json" \
	https://cloud.docker.com/api/repo/v1/registry/ \
	| python -m json.tool

-- get all triggers
GET /api/app/v1/service/61a29874-9134-48f9-b460-f37d4bec4826/trigger/ HTTP/1.1
Host: cloud.docker.com
Authorization: Basic dXNlcm5hbWU6YXBpa2V5
Accept: application/json

curl -u gp3t1:05f46db7-eeea-4cee-a792-c127731a8d27 \
	-H "Accept: application/json" \
	https://cloud.docker.com/api/build/v1/source/2e02c70c-7382-4412-ab1c-034b0521ae61/trigger/ \
	| python -m json.tool

--Call trigger
POST /api/app/v1/service/61a29874-9134-48f9-b460-f37d4bec4826/trigger/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/call/ HTTP/1.1
Host: cloud.docker.com
Accept: application/json

curl -u gp3t1:05f46db7-eeea-4cee-a792-c127731a8d27 \
	-H "Accept: application/json" \
	-X POST \
	https://cloud.docker.com/api/build/v1/source/2e02c70c-7382-4412-ab1c-034b0521ae61/trigger/d36a9273-7cb5-412a-acdc-0be97a5303f1/call/ \
	| python -m json.tool

-- see trigger
curl -u gp3t1:05f46db7-eeea-4cee-a792-c127731a8d27 \
	-H "Accept: application/json" \
	https://cloud.docker.com/api/build/v1/source/2e02c70c-7382-4412-ab1c-034b0521ae61/trigger/d36a9273-7cb5-412a-acdc-0be97a5303f1/ \
	| python -m json.tool



-- get all actions
curl -u gp3t1:05f46db7-eeea-4cee-a792-c127731a8d27 \
	-H "Accept: application/json" \
	https://cloud.docker.com//api/audit/v1/action/ \
	| python -m json.tool





IDEE:
gitlab on tag -> push tag to github && trigger the builds on dockercloud







