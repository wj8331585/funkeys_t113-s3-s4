################################################################################
#
# sdl_mixer
#
################################################################################

#SDL_MIXER_VERSION = 1.2.13
#SDL_MIXER_SOURCE = SDL-1.2.tar.gz # Not stable
#SDL_MIXER_SITE =  https://github.com/SDL-mirror/SDL_mixer/archive
SDL_MIXER_VERSION = 981c7c21534a71fb57b7b63f12bc08c28c290d55
SDL_MIXER_SITE_METHOD = git
SDL_MIXER_SITE =  https://github.com/SDL-mirror/SDL_mixer
SDL_MIXER_LICENSE = zlib
SDL_MIXER_LICENSE_FILES = COPYING

SDL_MIXER_INSTALL_STAGING = YES
SDL_MIXER_DEPENDENCIES = sdl
SDL_MIXER_CONF_OPTS = \
	--without-x \
	--with-sdl-prefix=$(STAGING_DIR)/usr \
	--disable-music-mp3 \
	--disable-music-mod \
	--disable-music-flac # configure script fails when cross compiling
	
ifeq ($(BR2_STATIC_LIBS),y)
SDL_MIXER_CONF_OPTS += --disable-music-mod-shared --disable-music-fluidsynth-shared --disable-music-ogg-shared --disable-music-flac-shared --disable-music-mp3-shared --disable-shared
endif

ifeq ($(BR2_PACKAGE_LIBMAD),y)
SDL_MIXER_CONF_OPTS += --enable-music-mp3-mad-gpl
SDL_MIXER_DEPENDENCIES += libmad
else
ifeq ($(BR2_PACKAGE_MPG123),y)
SDL_MIXER_CONF_OPTS += --enable-music-mp3
SDL_MIXER_DEPENDENCIES += mpg123
else
SDL_MIXER_CONF_OPTS += --disable-music-mp3
endif
endif

# Prefer libmikmod over Modplug due to dependency on C++
ifeq ($(BR2_PACKAGE_LIBMIKMOD),y)
SDL_MIXER_CONF_OPTS += --enable-music-mod
SDL_MIXER_DEPENDENCIES += libmikmod
else
ifeq ($(BR2_PACKAGE_LIBMODPLUG),y)
SDL_MIXER_CONF_OPTS += --enable-music-mod-modplug
SDL_MIXER_DEPENDENCIES += libmodplug
else
SDL_MIXER_CONF_OPTS += --disable-music-mod-modplug
endif
endif

# prefer tremor over libvorbis
ifeq ($(BR2_PACKAGE_TREMOR),y)
SDL_MIXER_CONF_OPTS += --enable-music-ogg-tremor
SDL_MIXER_DEPENDENCIES += tremor
else
SDL_MIXER_CONF_OPTS += --disable-music-ogg
endif

SDL_MIXER_CONF_OPTS += --enable-music-timidity-midi

$(eval $(autotools-package))
