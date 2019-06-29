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

MK_FILES =  Makefile makefile.config.mk $(patsubst \
            %,makeinc/makefile.%.mk,check variables regex web run)

# Version format: MAJOR.API.MINOR
VERSION_SPEC = $(VER_MAJOR).$(VER_API).$(VER_MINOR)

# Version format: MAJOR.API.MINOR.PATCH{-SUFFIX}
VERSION = $(VER_MAJOR).$(VER_API).$(VER_MINOR).$(VER_PATCH)$(VER_SUFFIX)

# Version format: MCVERSION-MAJOR.API.MINOR.PATCH{-SUFFIX}
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
* Negative values (Two\\´s Complements) are supported\n\
* Multiplayer support

# Credits of the mod
MODTHANKS = MCP, Minecraft Forge

# Conventions here
#   <http://maven.apache.org/guides/mini/guide-naming-conventions.html>
MODID = youdirk_numeric_io
GROUP = net.dj_l
MOD_RELDIR = $(subst .,/,$(GROUP))/$(MODID)

BUILD_DIR = build
BUILDLIBS_DIR = $(BUILD_DIR)/libs
BUILD_JARNAME = $(MODID)-$(VERSION_FULL)

SRC_DIR = src
RESOURCES_DIR = $(SRC_DIR)/main/resources
JAVA_DIR = $(SRC_DIR)/main/java
JAVA_MOD_DIR = $(JAVA_DIR)/$(MOD_RELDIR)
METAINF_DIR = $(RESOURCES_DIR)/META-INF
JAVADOC_DIR = $(BUILD_DIR)/docs/javadoc

RUN_DIR = run
RUN_TEMPL_DIR = run.templ

# FIND_CMD not available at first call without _CACHE_FILE
SRC_FILES := $(shell $(FIND_CMD) $(SRC_DIR) \
        -type f -a ! -name 'pack.mcmeta' -a ! -name 'mods.toml' \
        2> /dev/null || echo $(SRC_DIR))

MF_VERSION_FULL = $(MC_VERSION)-$(MF_VERSION)
MF_GROUP = net.minecraftforge
MF_NAME = forge

MF_DIR = forge
MF_MDK_DIR = $(MF_DIR)/mdk
MF_RESOURCES_DIR = $(MF_MDK_DIR)/$(RESOURCES_DIR)
MF_METAINF_DIR = $(MF_MDK_DIR)/$(METAINF_DIR)

MF_SUBFORGE_DIR = $(MF_DIR)/projects/forge
MF_JAVADOC_DIR = $(MF_SUBFORGE_DIR)/$(JAVADOC_DIR)
MF_BUILD_SRG2MCP_DIR = $(MF_SUBFORGE_DIR)/$(BUILD_DIR)/srg2mcp

DOCS_DIR = docs
MAVEN_DIR = $(DOCS_DIR)/maven
MAVEN_FORGE_RELDIR = $(subst .,/,$(MF_GROUP))/$(MF_NAME)
MAVEN_FORGE_DIR = $(MAVEN_DIR)/$(MAVEN_FORGE_RELDIR)
MAVEN_MOD_RELDIR = $(MOD_RELDIR)
MAVEN_MOD_DIR = $(MAVEN_DIR)/$(MAVEN_MOD_RELDIR)
DOCS_DATA_DIR = $(DOCS_DIR)/_data
DOCS_FORGEBUILDS_DIR = $(DOCS_DATA_DIR)/forge_builds
DOCS_FORGEBUILDS_VERSION_DIR = $(DOCS_FORGEBUILDS_DIR)/$(subst \
        .,-,$(MC_VERSION))
DOCS_BUILDS_DIR = $(DOCS_DATA_DIR)/builds
DOCS_BUILDS_VERSION_DIR = $(DOCS_BUILDS_DIR)/$(subst .,-,$(MC_VERSION))

MAVEN_FORGE_VERSIONDIRS := $(subst /.,,$(wildcard \
        $(MAVEN_FORGE_DIR)/$(MC_VERSION)-*/.))
MAVEN_MOD_VERSIONDIRS := $(subst /.,,$(wildcard \
        $(MAVEN_MOD_DIR)/$(MC_VERSION)-*/.))

MAVEN_FORGE_VERSIONS = $(subst $(MAVEN_FORGE_DIR)/,,\
        $(MAVEN_FORGE_VERSIONDIRS))
DOCS_FORGEBUILDS_JSONS = $(patsubst \
        %,$(DOCS_FORGEBUILDS_VERSION_DIR)/%.json, $(MAVEN_FORGE_VERSIONS))
MAVEN_MOD_VERSIONS = $(subst $(MAVEN_MOD_DIR)/,,\
        $(MAVEN_MOD_VERSIONDIRS))
DOCS_BUILDS_JSONS = $(patsubst %,$(DOCS_BUILDS_VERSION_DIR)/%.json,\
        $(MAVEN_MOD_VERSIONS))

MAVEN_FORGE_CURINSTALLER = $(MAVEN_FORGE_DIR)/$(MF_VERSION_FULL)$(\
        )/$(MF_NAME)-$(MF_VERSION_FULL)-installer.jar

PROJECT_URL = https://github.com/YouDirk/youdirk_numeric_io
REPOSITORY_ROOT_URL = $(PROJECT_URL)/blob/master
LICENSE_FILE = LICENSE

LOGO_FILE = youdirk_numeric_io.png
WEBSITE_URL = https://youdirk.github.io/youdirk_numeric_io
WEBSITE_DOWNLOADS_REL = downloads
WEBSITE_WIKI_REL = wiki
WEBSITE_ISSUES_REL = issues
WEBSITE_CONTRIB_DOC_REL = blob/master/CONTRIBUTING.md
UPDATE_JSON_URL = $(WEBSITE_URL)/update.json
GIT_URL = $(PROJECT_URL).git
GITHUB_RAW_URL = $(PROJECT_URL)/raw/master

BUGTRACKING_SYSTEM = github
BUGTRACKING_URL = $(PROJECT_URL)/$(WEBSITE_ISSUES_REL)

LICENSE_SHORT = GPL v3.0
LICENSE_URL = $(REPOSITORY_ROOT_URL)/$(LICENSE_FILE)

# --------------------------------------------------------------------
# Environment variables

ifneq (,$(MY_JAVA_HOME))
  PATH := $(MY_JAVA_HOME)/bin:$(PATH)
  JAVA_HOME := $(MY_JAVA_HOME)

  export PATH JAVA_HOME
endif

# End of Variable definitions
# ********************************************************************
