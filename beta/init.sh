#!/bin/sh

cd /build

VERSION='1.21.1'
BUILD='15'
JAR_NAME=paper-${VERSION}-${BUILD}.jar
URL=https://papermc.io/api/v2/projects/paper/versions/${VERSION}/builds/${BUILD}/downloads/${JAR_NAME}
wget ${URL} -O paper.jar