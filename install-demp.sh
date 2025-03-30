#!/usr/bin/env bash
set -euo pipefail

VERSION="${1}"
OS=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
if [[ "${ARCH}" == "x86_64" ]]; then
  ARCH="amd64"
fi

BASE_URL="https://github.com/rianfowler/demp/releases/download/v${VERSION}"
BINARY_NAME="demp_${VERSION}_${OS}_${ARCH}.tar.gz"
CHECKSUM_NAME="demp_${VERSION}_checksums.txt"

echo "Downloading binary from ${BASE_URL}/${BINARY_NAME}"
curl -sSL -o "${BINARY_NAME}" "${BASE_URL}/${BINARY_NAME}"

echo "Downloading checksum from ${BASE_URL}/${CHECKSUM_NAME}"
curl -sSL -o "${CHECKSUM_NAME}" "${BASE_URL}/${CHECKSUM_NAME}"

echo "Verifying checksum..."

# Debug: Print the content of the checksum file
echo "Checksum file contents:"
cat "${CHECKSUM_NAME}"

EXPECTED_CHECKSUM=$(grep "${BINARY_NAME}" "${CHECKSUM_NAME}" | awk '{print $1}')
if [ -z "$EXPECTED_CHECKSUM" ]; then
  echo "ERROR: Checksum for ${BINARY_NAME} not found in ${CHECKSUM_NAME}."
  exit 1
fi

ACTUAL_CHECKSUM=$(sha256sum "${BINARY_NAME}" | awk '{print $1}')

echo "Expected checksum: ${EXPECTED_CHECKSUM}"
echo "Actual checksum:   ${ACTUAL_CHECKSUM}"

if [ "${EXPECTED_CHECKSUM}" != "${ACTUAL_CHECKSUM}" ]; then
  echo "ERROR: Checksum verification failed. Expected ${EXPECTED_CHECKSUM} but got ${ACTUAL_CHECKSUM}."
  exit 1
fi

echo "Checksum verification passed."

echo "Extracting binary..."
tar -xzf "${BINARY_NAME}"

# Assuming the tarball extracts a binary named "demp"
chmod +x demp
sudo mv demp /usr/local/bin/demp

echo "demp ${VERSION} installed successfully!"
