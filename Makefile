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

# Mincraft Forge branch/commit from which will be bootstraped
MINECRAFT_FORGE_BRANCH = 1.13-pre

# (optional) JAVA_HOME path, if not automatically detected
JDK_PATH =

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
          for installation)
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
  MY_JAVA_HOME = "$(JDK_PATH)"

else ifneq (,$(call _JDK_FOUND,$(JAVA_HOME)))
  # JAVA_HOME environment variable set
  MY_JAVA_HOME = "$(JAVA_HOME)"
else ifneq (,$(call _CMD_TEST,javac))
  # JAVAC in PATH found, set JAVA_HOME:=(empty)
  MY_JAVA_HOME =

else
  # Try commonly known locations
  _TRY_HOME = $(call _JDK_LATEST,"c:/Program Files (x86)/Java")
  ifneq (,$(call _JDK_FOUND,$(_TRY_HOME)))
    MY_JAVA_HOME = "$(_TRY_HOME)"
  endif

  _TRY_HOME = $(call _JDK_LATEST,"c:/Program Files/Java")
  ifneq (,$(call _JDK_FOUND,$(_TRY_HOME)))
    MY_JAVA_HOME = "$(_TRY_HOME)"
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

RESOURCES_DIR = src/main/resources
MODS_FILE = $(RESOURCES_DIR)/META-INF/mods.toml

MF_DIR = minecraft_forge
MF_MDK_DIR = $(MF_DIR)/mdk
MF_MODS_FILE = $(MF_MDK_DIR)/$(MODS_FILE)

# ********************************************************************
# Target definitions

# TODO ... Just for tests ...
.PHONY: all
all:
	JAVA_HOME=$(MY_JAVA_HOME) ./gradlew setupDecompWorkspace

.PHONY: bootstrap
bootstrap:
	$(MAKE) TEST_GIT=1 _bootstrap
.PHONY: _bootstrap
_bootstrap:
	$(GIT_CMD) submodule update --init $(MF_DIR)
	cd $(MF_DIR) && $(GIT_CMD) checkout $(MINECRAFT_FORGE_BRANCH) \
	  && $(GIT_CMD) pull --rebase
	cp -rf $(MF_DIR)/{gradle,gradlew{,.bat}} .
	cp -f $(MF_MDK_DIR)/{build.gradle,gradle.properties} .
	cp -f $(MF_MODS_FILE) $(MODS_FILE)

.PHONY: mf_deinit
mf_deinit:
	$(MAKE) TEST_GIT=1 _mf_deinit
.PHONY: _mf_deinit
_mf_deinit:
	$(GIT_CMD) submodule deinit $(MF_DIR)

.PHONY: clean_bootstrap
clean_bootstrap:
	rm -f build.gradle gradle.properties
	rm -rf gradle gradlew{,.bat} $(MODS_FILE)

# ********************************************************************

.PHONY: _clean_bak
_clean_bak:
	-rm -f $(shell $(FIND_CMD) . -name '*~')

.PHONY: clean
clean: _clean_bak

# ********************************************************************
