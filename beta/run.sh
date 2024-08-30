#!/bin/sh

cd /app/paper && java -server $JAVA_OPTS -jar /bin/paper.jar --nogui

tail -f /dev/null