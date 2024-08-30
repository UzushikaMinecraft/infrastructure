#!/bin/sh

cd /build

VERSION='3.3.0-SNAPSHOT'
BUILD='415'
JAR_NAME=velocity-${VERSION}-${BUILD}.jar
URL=https://papermc.io/api/v2/projects/velocity/versions/${VERSION}/builds/${BUILD}/downloads/${JAR_NAME}
wget ${URL} -O velocity.jar