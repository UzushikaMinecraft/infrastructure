#!/bin/sh

cd /app/velocity && java -server $JAVA_OPTS -jar /bin/velocity.jar

tail -f /dev/null