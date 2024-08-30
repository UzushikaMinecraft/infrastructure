FROM alpine:latest

RUN apk update
RUN apk add --no-cache curl tzdata
ENV TZ=Asia/Tokyo

COPY cron.sh /bin/

ADD crontab /var/spool/crontab/root
RUN crontab /var/spool/crontab/root

ENTRYPOINT ["crond", "-f"]