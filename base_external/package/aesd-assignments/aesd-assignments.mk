
##############################################################
#
# AESD-ASSIGNMENTS
#
##############################################################

AESD_ASSIGNMENTS_VERSION = 21d41f5b110dd392116eb4918664a74ab4474b00
AESD_ASSIGNMENTS_SITE = git@github.com:usmn001/aesd3-usmn001.git
AESD_ASSIGNMENTS_SITE_METHOD = git
AESD_ASSIGNMENTS_GIT_SUBMODULES = YES

define AESD_ASSIGNMENTS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)/finder-app all
endef

define AESD_ASSIGNMENTS_INSTALL_TARGET_CMDS
	# Create directories
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/usr/bin
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/etc/finder-app/conf

	# Install writer (ensure it exists after build)
	if [ -f $(@D)/finder-app/writer ]; then \
		$(INSTALL) -m 0755 $(@D)/finder-app/writer $(TARGET_DIR)/usr/bin/; \
	fi

	# Install scripts
	if [ -f $(@D)/finder-app/finder.sh ]; then \
		$(INSTALL) -m 0755 $(@D)/finder-app/finder.sh $(TARGET_DIR)/usr/bin/; \
	fi

	if [ -f $(@D)/finder-app/finder-test.sh ]; then \
		$(INSTALL) -m 0755 $(@D)/finder-app/finder-test.sh $(TARGET_DIR)/usr/bin/; \
	fi

	# Install config files safely
	if [ -d $(@D)/conf ]; then \
		$(INSTALL) -m 0755 $(@D)/conf/* $(TARGET_DIR)/etc/finder-app/conf/ || true; \
	fi
endef

$(eval $(generic-package))