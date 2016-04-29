#!/bin/bash

RELEASE="${1}"
DATESTAMP="${2}"

RELEASE_DIRECTORY="/cygdrive/d/CYGWIN_RELEASES/${RELEASE}/${DATESTAMP}"

SOURCE_UPSTREAM="../Upstream/Framework-4.4r1"
SOURCE_TREE="../Framework"
SOURCE_MISSION="../Mission"
SOURCE_TEXTURES="../Texturing"
SOURCE_SOUNDS="../Sounds"

PBO_CONSOLE="/cygdrive/c/Program Files/PBO Manager v.1.4 beta/PBOConsole.exe"

echo "building a release for ${RELEASE} (${DATESTAMP})"

for DIRECTORY in "Altis_Life.Altis" "life_server"; do
  mkdir -pv "${RELEASE_DIRECTORY}/${DIRECTORY}"

  #
  # populate the directory with upstream files, a lot of these will get overwritten later
  #
  rsync -Pavpx --delete "${SOURCE_UPSTREAM}/${DIRECTORY}/." "${RELEASE_DIRECTORY}/${DIRECTORY}/."
done

#
# copy the mission file that contains the mapping projects
#
MISSION="${SOURCE_MISSION}/tmp/mapping/mission.sqm"
test -f "${MISSION}" && rsync -Pavpx "${MISSION}" "${RELEASE_DIRECTORY}/Altis_Life.Altis/."

#
# copy the textures from our overlay
#
mkdir -pv "${RELEASE_DIRECTORY}/Altis_Life.Altis/textures"
test -d "${SOURCE_TEXTURES}/textures" && rsync -Pavpx "${SOURCE_TEXTURES}/textures/." "${RELEASE_DIRECTORY}/Altis_Life.Altis/textures/."

#
# copy the sounds from our overlay
#
mkdir -pv "${RELEASE_DIRECTORY}/Altis_Life.Altis/custom/sounds"
test -d "${SOURCE_TEXTURES}/custom/sounds" && rsync -Pavpx "${SOURCE_TEXTURES}/custom/sounds/." "${RELEASE_DIRECTORY}/Altis_Life.Altis/custom/sounds/."

#
# copy the code from our overlay
#
for DIRECTORY in "Altis_Life.Altis" "life_server"; do
  test -d "${SOURCE_TREE}/${DIRECTORY}" && rsync -Pavpx "${SOURCE_TREE}/${DIRECTORY}/." "${RELEASE_DIRECTORY}/${DIRECTORY}/."
done

#
# set the prices in the files
#
for PRICING_FILE in briefing.sqf Config_vItems.hpp; do
	../Economy/bin/macro.py "../Framework/Altis_Life.Altis/${PRICING_FILE}" "../Economy/tmp/prices.txt" >"${RELEASE_DIRECTORY}/Altis_Life.Altis/${PRICING_FILE}"
done

#
# build the PBO files
#
for DIRECTORY in "Altis_Life.Altis" "life_server"; do
  "${PBO_CONSOLE}" \
    -pack "D:\\CYGWIN_RELEASES\\${RELEASE}\\${DATESTAMP}\\${DIRECTORY}" \
          "D:\\CYGWIN_RELEASES\\${RELEASE}\\${DATESTAMP}\\${DIRECTORY}.pbo"
done

exit 0
