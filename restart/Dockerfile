FROM alpine:latest

RUN apk update
RUN apk add --no-cache curl tzdata py3-pip docker-cli bash
# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Verify installations
RUN docker --version && docker-compose --version

ENV TZ=Asia/Tokyo

COPY cron.sh /bin/

ADD crontab /var/spool/crontab/root
RUN crontab /var/spool/crontab/root

ENTRYPOINT ["crond", "-f"]