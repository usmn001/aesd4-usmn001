#!/bin/bash
#Script to build buildroot configuration
#Author: Siddhant Jajoo

source "$(dirname "$0")/shared.sh"
echo "DEBUG: AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT=${AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT}"

EXTERNAL_REL_BUILDROOT=../base_external
git submodule init
git submodule sync
git submodule update

set -e 
cd `dirname $0`

if [ ! -e buildroot/.config ]
then
	echo "MISSING BUILDROOT CONFIGURATION FILE"

	if [ -e ${AESD_MODIFIED_DEFCONFIG} ]
	then
		echo "USING ${AESD_MODIFIED_DEFCONFIG}"
		echo "USING BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT}"
		make -C buildroot defconfig BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT} O=output defconfig BR2_DEFCONFIG=${AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT}
	else
		echo "Run ./save_config.s+h to save this as the default configuration in ${AESD_MODIFIED_DEFCONFIG}"
		echo "Then add packages as needed to complete the installation, re-running ./save_config.sh as needed"
		echo "USING BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT}"
		make -C buildroot defconfig BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT} O=output BR2_DEFCONFIG=${AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT}
	fi
else
	echo "USING EXISTING BUILDROOT CONFIG"
	echo "To force update, delete .config or make changes using make menuconfig and build again."
	echo "USING BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT}"
	make -C buildroot BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT} O=output BR2_DEFCONFIG=${AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT}

fi
