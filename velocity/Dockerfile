FROM alpine:latest AS builder

ARG USERNAME=app
ARG GROUPNAME=app
ARG UID=1000
ARG GID=1000

RUN apk add --no-cache wget jq
ADD ./init.sh /build/
ADD ./run.sh /build/
RUN /build/init.sh

FROM eclipse-temurin:22-jre-alpine

RUN apk --update add tzdata  && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata && \
    rm -rf /var/cache/apk/*
WORKDIR /
COPY --from=builder /build/velocity.jar /bin/
COPY --from=builder /build/run.sh /bin/
RUN chmod +x /bin/run.sh
CMD /bin/run.sh