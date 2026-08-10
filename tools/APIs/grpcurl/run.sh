#!/bin/sh

set -e

echo
echo "======================================"
echo "              GRPCURL"
echo "======================================"
echo
echo "Target: $TARGET"
echo

if [ "$PLAINTEXT" = "yes" ]; then
    docker run --rm \
      --name toolbox-grpcurl \
      fullstorydev/grpcurl:latest \
      -plaintext "$TARGET" list
else
    docker run --rm \
      --name toolbox-grpcurl \
      fullstorydev/grpcurl:latest \
      "$TARGET" list
fi