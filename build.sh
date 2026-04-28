#!/bin/bash
#Script to build buildroot configuration
#Author: Siddhant Jajoo
set -e 
source "$(dirname "$0")/shared.sh"
echo "DEBUG: AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT=${AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT}"

EXTERNAL_REL_BUILDROOT=../base_external
git submodule init
git submodule sync
git submodule update


cd `dirname $0`

# Always start clean in CI (prevents stale config issues)
echo "Cleaning previous build..."
rm -rf buildroot/output

# Ensure defconfig exists (fail early)
if [ ! -f "${AESD_MODIFIED_DEFCONFIG}" ]; then
    echo "ERROR: Modified defconfig not found at ${AESD_MODIFIED_DEFCONFIG}"
    exit 1
fi

# Always apply defconfig (NO conditional logic)
echo "Applying defconfig..."
make -C buildroot \
    BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT} \
    BR2_DEFCONFIG=${AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT} \
    defconfig

# 🔍 Debug: verify Dropbear is enabled
echo "Checking Dropbear in config..."
grep BR2_PACKAGE_DROPBEAR buildroot/.config || true

# Build
echo "Starting build..."
make -C buildroot \
    BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT}

echo "Build completed successfully!"
