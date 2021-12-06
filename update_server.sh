#!/bin/bash
cd /opt/minecraft-java
URL_SERVER_VERSION_MANIFEST=https://launchermeta.mojang.com/mc/game/version_manifest.json
MANIFEST=`curl $URL_SERVER_VERSION_MANIFEST`

LATEST_RELEASE=`echo $MANIFEST | jq -r '.latest.release'`
CURRENT_RELEASE=`cat .server_current`

if [ $LATEST_RELEASE != "$CURRENT_RELEASE" ]; then
  URL_ARGUMENTS=`echo $MANIFEST | jq -r ".versions | map(select(.id == \"${LATEST_RELEASE}\"))[0].url"`

  URL_SERVER_DL=`curl $URL_ARGUMENTS | jq -r "select(.id == \"${LATEST_RELEASE}\").downloads.server.url"`
  wget -q $URL_SERVER_DL -O server.jar
  echo $LATEST_RELEASE > .server_current
fi
