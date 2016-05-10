#!/bin/bash

RELEASE_DIRECTORY="${1}"

RELEASE="${2}"

SERVER="127.0.0.1"

if [[ "testing" == "${RELEASE}" ]]; then
  SERVER="192.168.4.105"
fi

if [[ "production" == "${RELEASE}" ]]; then
  SERVER="altisliferpg.xoreaxeax.de"
fi

#
# deploy to server
#
TARGET_DIRECTORY="/home/steam/Steam/steamapps/common/Arma\ 3\ Server"

rsync -Pavpx \
    "${RELEASE_DIRECTORY}/Altis_Life.Altis.pbo" \
      "steam@${SERVER}:${TARGET_DIRECTORY}/mpmissions/${RELEASE}_Altis_Life.Altis.pbo"

rsync -Pavpx \
          "${RELEASE_DIRECTORY}/life_server.pbo" \
                  "steam@${SERVER}:${TARGET_DIRECTORY}/@life_server/addons/."

#
# restart arma3 on betaserver
#
if [[ "testing" == "${RELEASE}" ]]; then
  ssh steam@${SERVER} -t make -C /home/steam restart
fi

sleep 1

#
# validate the contents so we know we copied everything correctly :)
#
ls -ali "${RELEASE_DIRECTORY}"

echo

sha1sum ${RELEASE_DIRECTORY}/Altis_Life.Altis.pbo
ls -al ${RELEASE_DIRECTORY}/Altis_Life.Altis.pbo
ssh -q steam@${SERVER} -t sha1sum "${TARGET_DIRECTORY}/mpmissions/${RELEASE}_Altis_Life.Altis.pbo"
ssh -q steam@${SERVER} -t ls -al "${TARGET_DIRECTORY}/mpmissions/${RELEASE}_Altis_Life.Altis.pbo"

echo

sha1sum ${RELEASE_DIRECTORY}/life_server.pbo
ls -al ${RELEASE_DIRECTORY}/life_server.pbo
ssh -q steam@${SERVER} -t sha1sum "${TARGET_DIRECTORY}/@life_server/addons/life_server.pbo"
ssh -q steam@${SERVER} -t ls -al "${TARGET_DIRECTORY}/@life_server/addons/life_server.pbo"

exit 0

