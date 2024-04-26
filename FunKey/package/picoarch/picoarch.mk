################################################################################
#
# picoarch
#
################################################################################

PICOARCH_VERSION = v1.0-funkey-s
PICOARCH_SITE_METHOD = git
PICOARCH_SITE = https://github.com/DrUm78/picoarch.git
PICOARCH_LICENSE = MAME
PICOARCH_LICENSE_FILES = LICENSE

PICOARCH_DEPENDENCIES = sdl sdl_image sdl_ttf

PICOARCH_SDL_CFLAGS += $(shell $(STAGING_DIR)/usr/bin/sdl-config --cflags)
PICOARCH_SDL_LIBS   += $(shell $(STAGING_DIR)/usr/bin/sdl-config --libs)

PICOARCH_CFLAGS += $(PICOARCH_SDL_CFLAGS)
PICOARCH_CFLAGS += -DFUNKEY_S -Ofast -DNDEBUG  -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
PICOARCH_CFLAGS += -Wall -fdata-sections -ffunction-sections -flto
PICOARCH_CFLAGS += -I./ -I./libretro-common/include/

PICOARCH_LIBS += $(PICOARCH_SDL_LIBS)
PICOARCH_LIBS += -lc -ldl -lgcc -lm -lSDL -lasound -lpng -lz -Wl,--gc-sections -flto -lSDL_image -lSDL_ttf

define PICOARCH_BUILD_CMDS
	(cd $(@D); \
	make picoarch platform=funkey-s \
	CROSS_COMPILE=$(TARGET_CROSS) \
	CFLAGS='$(PICOARCH_CFLAGS)' \
	LDFLAGS='$(PICOARCH_LIBS)' \
	SDL_INCLUDES='$(PICOARCH_SDL_CFLAGS)' \
	SDL_LIBS='$(PICOARCH_SDL_LIBS)' \
	)
endef

PICOARCH_GIT_SUBMODULES = YES

define PICOARCH_INSTALL_TARGET_CMDS
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/usr/games
	$(INSTALL) -m 0755 $(@D)/picoarch $(TARGET_DIR)/usr/games/
endef

define PICOARCH_CREATE_OPK
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/usr/local/share/OPKs/Libretro
	$(HOST_DIR)/usr/bin/mksquashfs $(PICOARCH_PKGDIR)/opk $(TARGET_DIR)/usr/local/share/OPKs/Libretro/picoarch_funkey-s.opk -all-root -noappend -no-exports -no-xattrs
endef
PICOARCH_POST_INSTALL_TARGET_HOOKS += PICOARCH_CREATE_OPK

$(eval $(generic-package))
