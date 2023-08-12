################################################################################
#
# st-sdl
#
################################################################################

ST_SDL_VERSION = 2c29ceeb9ec01154d5a80d394446b42b0154d0ec
ST_SDL_SITE_METHOD = git
ST_SDL_SITE = https://github.com/FunKey-Project/st-sdl.git
ST_SDL_LICENSE = GPL-2.1+
ST_SDL_LICENSE_FILES = LICENSE

ST_SDL_DEPENDENCIES = sdl

define ST_SDL_BUILD_CMDS
	(cd $(@D); \
	sed -i -e 's|/opt/FunKey-sdk-2.0.0|../../host|g' config_funkey-s.mk; \
	sed -i -e 's|arm-funkey-linux-musleabihf-|arm-linux-|g' config_funkey-s.mk; \
	make \
	)
endef

define ST_SDL_INSTALL_TARGET_CMDS
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/st $(TARGET_DIR)/usr/bin/
endef

define ST_SDL_CREATE_OPK
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/usr/local/share/OPKs/Applications
	$(HOST_DIR)/usr/bin/mksquashfs $(ST_SDL_PKGDIR)/opk $(TARGET_DIR)/usr/local/share/OPKs/Applications/st-sdl_funkey-s.opk -all-root -noappend -no-exports -no-xattrs
endef
ST_SDL_POST_INSTALL_TARGET_HOOKS += ST_SDL_CREATE_OPK

$(eval $(generic-package))
