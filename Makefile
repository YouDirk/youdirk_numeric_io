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

# Configuration

# (optional) JAVA_HOME path, if not automatically detected
JDK_PATH =

# YouDirk Numeric I/O Version (without Minecraft Version)
#   Take a look to the conventions for versioning
#   <https://mcforge.readthedocs.io/en/latest/conventions/versioning/>
VERSION = 0.0.0.1-pre

# Dependency Version stuff
MC_VERSION = 1.13

# Official version from <https://files.minecraftforge.net/> or self
# deployed version from MAVEN directory
MF_VERSION = 24.0.96.0-youdirk

# Official Mappings are here <http://export.mcpbot.bspk.rs/>
MCP_MAPPING_CHANNEL = stable
MCP_MAPPING_VERSION = 43

# Mincraft Forge branch/commit from which will be bootstraped
MF_BRANCH = 1.13-pre

# Mincraft Forge branch/commit from which will be bootstraped
# if current development is too heavily
MF_FALLBACK_BRANCH = origin/1.12.x

# (optional) Inodes (files, directories, etc) relative to
# MINECRAFT_FORGE directory which will be using fallback versions
MF_FALLBACK_INODES = mdk/build.gradle mdk/gradle.properties

# Comma separated list
CREDITS = Dirk (YouDirk) Lehmann

# End of Configuration
# ********************************************************************
# Linux/MSYS2 commands, feature check

_CMD_TEST = $(shell which $(1) 2> /dev/null)

FIND_CMD = $(call _CMD_TEST,find)
ifeq (,$(FIND_CMD))
  $(error FIND command not found!  Try '$$> pacman -S msys/findutils' \
          for installation.  Or use your Linux package manager.)
endif

SED_CMD = $(call _CMD_TEST,sed)
ifeq (,$(SED_CMD))
  $(error SED command not found!  Try '$$> pacman -S msys/sed' \
          for installation.  Or use your Linux package manager.)
endif

ifneq (,$(TEST_GIT))
  GIT_CMD = "$(call _CMD_TEST,git)"
  ifeq ("",$(GIT_CMD))
    $(error GIT command not found!  Try '$$> pacman -S msys/git' \
            for installation.  Or use your Linux package manager.)
  endif
endif

# --------------------------------------------------------------------
# Find JDK installation

JDK_PATH := $(shell echo $(JDK_PATH) \
	            | $(SED_CMD) 's/"//g; s/'\''//g; s/\\ / /g;')

# bool _JDK_FOUND(java_home)
_JDK_FOUND = $(shell (test -f "$(1)/bin/javac.exe" \
                      || test -f "$(1)/bin/javac") && echo -n 1)

# latest_path _JDK_LATEST(potentially_path)
_JDK_LATEST = $(shell d=($(1)/jdk*); IFS=$$'\n'; echo "$${d[*]}" \
                      | $(SED_CMD) -n '$$p')

ifneq (,$(call _JDK_FOUND,$(JDK_PATH)))
  # Configuration variable set
  MY_JAVA_HOME = $(JDK_PATH)

else ifneq (,$(call _JDK_FOUND,$(JAVA_HOME)))
  # JAVA_HOME environment variable set
  MY_JAVA_HOME = $(JAVA_HOME)
else ifneq (,$(call _CMD_TEST,javac))
  # JAVAC in PATH found, set JAVA_HOME:=(empty)
  MY_JAVA_HOME =

else
  # Try commonly known locations
  _TRY_HOME = $(call _JDK_LATEST,"/c/Program Files (x86)/Java")
  ifneq (,$(call _JDK_FOUND,$(_TRY_HOME)))
    MY_JAVA_HOME = $(_TRY_HOME)
  endif

  _TRY_HOME = $(call _JDK_LATEST,"/c/Program Files/Java")
  ifneq (,$(call _JDK_FOUND,$(_TRY_HOME)))
    MY_JAVA_HOME = $(_TRY_HOME)
  endif

  ifeq (,$(MY_JAVA_HOME))
    $(error JAVAC command not found!  Please install the 'Java SE \
            Development Kit (JDK)' and/or set Makefile configuration \
            variable JDK_PATH)
  endif
endif

# MY_JAVA_HOME is set from here
# --------------------------------------------------------------------

# ********************************************************************
# Variable definitions

VERSION_FULL = $(MC_VERSION)-$(VERSION)

# Display name of the mod
MODNAME = YouDirk Numeric I/O

# Mult-line description of the mod
MODDESC = \
This is the official $(MODNAME) Minecraft mod 'youdirk_numeric_io'. \
It adds to the game\n\
\n\
* Blocks which are outputing decimal (and hexadecimal) numbers to \
  represent the connected binary encoded Redstone Wires\n\
\n\
* Blocks which you can input a number (by right clicking on it). \
  These will be encoded to binary and outputed to the connected \
  Redstone Wires\n\
\n\
* Negative values (Two\\\'s Complement encoding) are supported

# Credits of the mod
MODTHANKS = To the MCP team and the Forge programmers to make it \
            possible to ez programming Minecraft mods :)

# Conventions here
#   <http://maven.apache.org/guides/mini/guide-naming-conventions.html>
MODID = youdirk_numeric_io
GROUP = net.dj_l.$(MODID)

MCP_MAPPING = $(MCP_MAPPING_CHANNEL)_$(MCP_MAPPING_VERSION)
MF_VERSION_FULL = $(MC_VERSION)-$(MF_VERSION)

RESOURCES_DIR = src/main/resources
METAINF_DIR = $(RESOURCES_DIR)/META-INF

MF_DIR = minecraft_forge
MF_MDK_DIR = $(MF_DIR)/mdk
MF_RESOURCES_DIR = $(MF_MDK_DIR)/$(RESOURCES_DIR)
MF_METAINF_DIR = $(MF_MDK_DIR)/$(METAINF_DIR)

DOCS_DIR = docs

MAVEN_DIR = $(DOCS_DIR)/maven
MAVEN_FORGE_DIR = $(MAVEN_DIR)/net/minecraftforge/forge

# ********************************************************************
# Environment variables

PATH := $(MY_JAVA_HOME)/bin:$(PATH)
JAVA_HOME := $(MY_JAVA_HOME)

# ********************************************************************
# Target definitions

.PHONY: all
all: gradle_all src
	./gradlew classes

.PHONY: setup_decomp_workspace
setup_decomp_workspace: gradle_all src
	./gradlew --stacktrace setupDecompWorkspace

.PHONY: setup%
setup%: gradle_all src
	./gradlew $@

.PHONY: classes
classes: gradle_all src
	./gradlew classes

.PHONY: clean
clean: _clean_bak
	-rm -rf .gradle build

.PHONY: jdk_version
jdk_version:
	javac -version

# --- Maintaining only ---

.PHONY: bootstrap
bootstrap: minecraft_forge maven gradle_all src

.PHONY: maven
maven: $(MAVEN_FORGE_DIR)/maven-metadata.xml

# --- End of Maintaining only ---

# ********************************************************************

.PHONY: minecraft_forge
minecraft_forge:
	$(MAKE) TEST_GIT=1 _minecraft_forge
.PHONY: _minecraft_forge
_minecraft_forge:
	$(GIT_CMD) submodule update --init $(MF_DIR)
	cd $(MF_DIR) && $(GIT_CMD) checkout -f $(MF_BRANCH) \
	  && $(GIT_CMD) pull -f --rebase \
	  $(foreach INODE,$(MF_FALLBACK_INODES), \
	      && $(GIT_CMD) checkout $(MF_FALLBACK_BRANCH) -- $(INODE))

$(MAVEN_FORGE_DIR)/maven-metadata.xml: \
  $(MAVEN_FORGE_DIR)/maven-metadata-local.xml
	cp -f $< $@

$(MAVEN_FORGE_DIR)/maven-metadata-local.xml: \
  .git/modules/$(MF_DIR)/FETCH_HEAD
	$(SED_CMD) -i 's/net.minecraftforge.test/net.minecraftforge/g' \
	  $(MF_DIR)/build.gradle
	cd $(MF_DIR) && ./gradlew -Dmaven.repo.local=../$(MAVEN_DIR) \
	  setup :forge:licenseFormat :forge:publishToMavenLocal
	branch=`$(SED_CMD) 's~^.*/\([^/]\+\)$$~\1~' \
	                   .git/modules/$(MF_DIR)/HEAD`; \
	  version_old=`basename $$($(FIND_CMD) $(MAVEN_FORGE_DIR) \
	                             -name "*$$branch")`; \
	  version_new=`echo $$version_old | sed "s/-$$branch/.0-youdirk/"`; \
	  for i in $(MAVEN_FORGE_DIR)/$$version_old/*; do \
	    mv -f $$i `echo $$i | $(SED_CMD) \
	      "s~-$$version_old\([-\.][a-z]\)~-$$version_new\1~"`; \
	  done; \
	  mv -f $(MAVEN_FORGE_DIR)/$$version_old $(MAVEN_FORGE_DIR)/$$version_new; \
	  $(SED_CMD) -i "s/$$version_old/$$version_new/g" $@; \

$(RESOURCES_DIR)/pack.mcmeta: $(MF_RESOURCES_DIR)/pack.mcmeta
	cp -f $< $@
$(METAINF_DIR)/mods.toml: $(MF_METAINF_DIR)/mods.toml Makefile
	$(SED_CMD) \
's~^modId \?=[^#]*~modId="$(MODID)"~g; '\
's~^version \?=[^#]*~version="$(VERSION_FULL)"~g; '\
's~^displayName \?=[^#]*~displayName="$(MODNAME)"~g; '\
's~^authors \?=[^#]*~authors="$(CREDITS)"~g; '\
's~^credits \?=[^#]*~credits="$(MODTHANKS)"~g; '\
's~^\[\[dependencies.examplemod\]\] \?[^#]*~[[dependencies.$(MODID)]]~g; '\
	  $< > $@
	$(SED_CMD) -i ':a;N;$$!ba;s~\n~{nl}~g; ' $@ && $(SED_CMD) -i \
"s~{nl}description \\?= \\?'''.*{nl}'''~{nl}description='''{nl}$(MODDESC){nl}'''~g; "\
's~{nl}~\n~g; ' $@

.PHONY: src
src: $(METAINF_DIR)/mods.toml $(RESOURCES_DIR)/pack.mcmeta

gradle: $(MF_DIR)/gradle
	cp -rf $< $@
gradlew: $(MF_DIR)/gradlew gradle
	cp -f $< $@
gradlew.bat: $(MF_DIR)/gradlew.bat gradlew
	cp -f $< $@
gradle.properties: $(MF_MDK_DIR)/gradle.properties gradlew.bat
	cp -f $< $@
build.gradle: $(MF_MDK_DIR)/build.gradle Makefile gradle.properties
	$(SED_CMD) \
's~@MAPPINGS@~$(MCP_MAPPING)~g; '\
's~@VERSION@~$(MF_VERSION_FULL)~g; '\
's~^version \?=[^/]*~version = "$(VERSION_FULL)"~g; '\
's~^group \?=[^/]*~group = "$(GROUP)"~g; '\
's~^archivesBaseName \?=[^/]*~archivesBaseName = "$(MODID)"~g; '\
's~mcmod.info~META-INF/mods.toml~g; '\
	  $< > $@

.PHONY: gradle_all
gradle_all: build.gradle

.PHONY: mf_deinit
mf_deinit:
	$(MAKE) TEST_GIT=1 _mf_deinit
.PHONY: _mf_deinit
_mf_deinit:
	$(GIT_CMD) submodule deinit $(MF_DIR)

# ********************************************************************


.PHONY: clean_minecraft_forge
clean_minecraft_forge:
	$(MAKE) TEST_GIT=1 _clean_minecraft_forge
.PHONY: _clean_minecraft_forge
_clean_minecraft_forge:
	cd $(MF_DIR) && $(GIT_CMD) checkout build.gradle \
	  && $(GIT_CMD) clean -xdf

.PHONY: clean_all
clean_all: clean clean_maven clean_bootstrap clean_minecraft_forge

.PHONY: _clean_bak
_clean_bak:
	-rm -f $(shell $(FIND_CMD) . -name '*~')

.PHONY: clean_bootstrap
clean_bootstrap:
	-rm -f build.gradle gradle.properties
	-rm -rf gradle gradlew{,.bat}
	-rm -f $(RESOURCES_DIR)/pack.mcmeta $(METAINF_DIR)/mods.toml

.PHONY: clean_maven
clean_maven:
	-rm -rf $(MAVEN_DIR)

# ********************************************************************
