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

MINECRAFT_FORGE_BRANCH = 1.13-pre

# End of Configuration
# ********************************************************************
# Linux/MSYS2 commands, feature check

_CMD_TEST = $(shell which $(1) 2> /dev/null)

FIND_CMD = $(call _CMD_TEST, find)
ifeq (,$(FIND_CMD))
  $(error FIND command not found!  Try '$$> pacman -S msys/findutils' \
          for installation.  Or use your Linux package manager.)
endif

ifneq (,$(TEST_GIT))
  GIT_CMD = "$(call _CMD_TEST, git)"
  ifeq ("",$(GIT_CMD))
    $(error GIT command not found!  Try '$$> pacman -S msys/git' \
            for installation.  Or use your Linux package manager.)
  endif
endif

# ********************************************************************
# Variable definitions

MF_PATH = minecraft_forge
MF_MDK_PATH = $(MF_PATH)/mdk

# ********************************************************************
# Target definitions

.PHONY: all
all:
	@echo "Hmmmmmm ...."

.PHONY: bootstrap
bootstrap:
	$(MAKE) TEST_GIT=1 _bootstrap
.PHONY: _bootstrap
_bootstrap:
	$(GIT_CMD) submodule update --init $(MF_PATH)
	cd $(MF_PATH) && $(GIT_CMD) checkout $(MINECRAFT_FORGE_BRANCH)
	cp -rf $(MF_PATH)/{gradle,gradlew{,.bat}} .
	cp -f $(MF_MDK_PATH)/{build.gradle,gradle.properties} .

.PHONY: mf_deinit
mf_deinit:
	$(MAKE) TEST_GIT=1 _mf_deinit
.PHONY: _mf_deinit
_mf_deinit:
	$(GIT_CMD) submodule deinit $(MF_PATH)

.PHONY: clean_bootstrap
clean_bootstrap:
	rm -f build.gradle gradle.properties
	rm -rf gradle gradlew{,.bat}

# ********************************************************************

.PHONY: _clean_bak
_clean_bak:
	-rm -f $(shell $(FIND_CMD) . -name '*~')

.PHONY: clean
clean: _clean_bak

# ********************************************************************
