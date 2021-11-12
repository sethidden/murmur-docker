# currently alpine:edge supports more architectures than alpine:latest
FROM alpine:edge
EXPOSE 64738 64738/udp
RUN apk --no-cache add murmur
CMD ["murmurd", "-fg", "-v"]
