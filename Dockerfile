FROM alpine:edge

# shamelessly stolen from, or as we call it in open source "forked":
#LABEL maintainer="Jeremy PETIT <jeremy.petit@gmail.com>" \
	#description="alpine-based umurmurd image - audio chat server"

EXPOSE 64738 64738/udp
VOLUME ["/var/log/umurmur", "/var/lib/umurmur"]

RUN apk --no-cache add umurmur

CMD ["umurmurd","-d", "-c" , "/etc/umurmur/umurmurd.conf"]
