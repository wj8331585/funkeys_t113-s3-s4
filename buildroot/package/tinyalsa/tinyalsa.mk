################################################################################
#
# tinyalsa
#
################################################################################

TINYALSA_VERSION = 30d4711
TINYALSA_SITE_METHOD = git
TINYALSA_SITE = https://github.com/FunKey-Project/tinyalsa.git
TINYALSA_LICENSE = BSD-3-Clause
TINYALSA_LICENSE_FILES = NOTICE
TINYALSA_INSTALL_STAGING = YES

$(eval $(cmake-package))
