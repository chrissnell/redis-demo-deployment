#!/bin/bash -e

if [ -z "${SPIPED_KEY}" ]; then
  echo The env var SPIPED_KEY needs to be defined. 
  echo This is the path to the spiped key file.
  echo Exiting...
  exit 1
fi

if [ -z "${SPIPED_SOURCE_SOCKET}" ]; then
  echo The env var SPIPED_SOURCE_SOCKET needs to be defined.
  echo This is the socket on which spiped listens for connections.
  echo Exiting...
  exit 1
fi

if [ -z "${SPIPED_TARGET_SOCKET}" ]; then
  echo The env var SPIPED_TARGET_SOCKET needs to be defined.
  echo This is the socket which spiped tunnels encrypted traffic to.
  echo Exiting...
  exit 1
fi

if [ "$SPIPED_MODE" != "e" ] && [ "$SPIPED_MODE" != "d" ]; then
  echo "The env var SPIPED_MODE must be set to either"
  echo "'e' (encrypt) or 'd' (decrypt)."
  exit 1
fi

if [ "$SPIPED_MODE" = "e" ]; then
   SPIPED_MODE_FLAG="-e"
fi

if [ "$SPIPED_MODE" = "d" ]; then
   SPIPED_MODE_FLAG="-d"
fi

# Default timeout is 30 seconds
SPIPED_TIMEOUT="${SPIPED_TIMEOUT:-30}"

# Use gosu to drop privileges and run spiped in foreground
# exec /gosu nobody /usr/local/bin/spiped -F ${SPIPED_MODE_FLAG} -s ${SPIPED_SOURCE_SOCKET} -t ${SPIPED_TARGET_SOCKET} \
exec /usr/local/bin/spiped -F ${SPIPED_MODE_FLAG} -s ${SPIPED_SOURCE_SOCKET} -t ${SPIPED_TARGET_SOCKET} \
                    -k ${SPIPED_KEY} -o ${SPIPED_TIMEOUT}
