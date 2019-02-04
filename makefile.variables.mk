# This file is part of the `youdirk_numeric_io` Minecraft mod
# Copyright (C) 2019  Dirk "YouDirk" Lehmann
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


# ********************************************************************
# Variable definitions

# win_path_escaped _2WINPATH_ESCAPE(unix_path)
_2WINPATH = $(shell echo $(1) | $(SED_CMD) 's~^/\(.\)/~\1:/~;s~ ~\\ ~g')

VERSION_FULL = $(MC_VERSION)-$(VERSION)

# Display name of the mod
MODNAME = YouDirk Numeric I/O

MODDESC_ONELINE = This is the official $(MODNAME) Minecraft mod \
                  'youdirk_numeric_io'.

# Mult-line description of the mod
MODDESC = This mod adds:\n\
\n\
* Blocks which are outputing (hexa-)decimal numbers\n\
* Blocks which you can input a number\n\
* Negative values (Two\\\'s Complements) are supported

# Credits of the mod
MODTHANKS = To the MCP team and the Forge programmers to make it \
            possible to ez programming Minecraft mods :)

# Conventions here
#   <http://maven.apache.org/guides/mini/guide-naming-conventions.html>
MODID = youdirk_numeric_io
GROUP = net.dj_l.$(MODID)

BUILD_DIR = build
RESOURCES_DIR = src/main/resources
JAVA_DIR = src/main/java
METAINF_DIR = $(RESOURCES_DIR)/META-INF
JAVADOC_DIR = $(BUILD_DIR)/docs/javadoc

RUN_DIR = run

# FIND_CMD not available at first call without _CACHE_FILE
JAVA_FILES := $(shell $(FIND_CMD) $(JAVA_DIR) -name '*.java' \
                      2> /dev/null || echo $(JAVA_DIR))

MF_VERSION_FULL = $(MC_VERSION)-$(MF_VERSION)
MF_GROUP = net.minecraftforge
MF_NAME = forge

MF_DIR = minecraft_forge
MF_MDK_DIR = $(MF_DIR)/mdk
MF_RESOURCES_DIR = $(MF_MDK_DIR)/$(RESOURCES_DIR)
MF_METAINF_DIR = $(MF_MDK_DIR)/$(METAINF_DIR)

MF_SUBFORGE_DIR = $(MF_DIR)/projects/forge
MF_JAVADOC_DIR = $(MF_SUBFORGE_DIR)/$(JAVADOC_DIR)

DOCS_DIR = docs
MAVEN_DIR = $(DOCS_DIR)/maven
MAVEN_FORGE_RELDIR = $(subst .,/,$(MF_GROUP))/$(MF_NAME)
MAVEN_FORGE_DIR = $(MAVEN_DIR)/$(MAVEN_FORGE_RELDIR)
DOCS_DATA_DIR = $(DOCS_DIR)/_data
DOCS_FORGEBUILDS_DIR = $(DOCS_DATA_DIR)/forge_builds

# FIND_CMD not available at first call without _CACHE_FILE
MAVEN_FORGE_VERSIONDIRS := $(shell $(FIND_CMD) $(MAVEN_FORGE_DIR)/* \
        -type d 2> /dev/null || echo $(MAVEN_FORGE_DIR))
MAVEN_FORGE_VERSIONS = $(patsubst $(MAVEN_FORGE_DIR)/%,%,\
                         $(MAVEN_FORGE_VERSIONDIRS))
DOCS_FORGEBUILDS_JSONS = $(patsubst %,$(DOCS_FORGEBUILDS_DIR)/%.json,\
                           $(MAVEN_FORGE_VERSIONS))

LOGO_FILE = youdirk_numeric_io.png
WEBSITE_URL = https://youdirk.github.io/youdirk_numeric_io
BUGTRACKING_URL = https://github.com/YouDirk/youdirk_numeric_io/issues
UPDATE_JSON_URL = $(WEBSITE_URL)/releases/update.json

_BLANK :=
define NL

$(_BLANK)
endef

# --------------------------------------------------------------------
# Environment variables

PATH := $(MY_JAVA_HOME)/bin:$(PATH)
JAVA_HOME := $(MY_JAVA_HOME)

# End of Variable definitions
# ********************************************************************
