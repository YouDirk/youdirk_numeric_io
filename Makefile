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
# Linux/MSYS2 commands, feature check

_CMD_TEST = $(shell which $(1) 2> /dev/null)

FIND_CMD = $(call _CMD_TEST, find)
ifeq (,$(FIND_CMD))
  $(error FIND command not found!  Try '$$> pacman -S msys/findutils' \
          for installation.  Or use your Linux package manager.)
endif

# ********************************************************************
# Target definitions

.PHONY: all
all:
	@echo "Hmmmmmm ...."

.PHONY: _clean_bak
_clean_bak:
	-rm -f $(shell $(FIND_CMD) . -name '*~')

.PHONY: clean
clean: _clean_bak

# ********************************************************************
