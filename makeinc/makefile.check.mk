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

ifneq (,$(_CACHE_FILE))

_CMD_TEST = $(shell which $(1) 2> /dev/null)

FIND_CMD = $(call _CMD_TEST,find)
ifeq (,$(FIND_CMD))
  $(shell rm -f $(_CACHE_FILE))
  $(error FIND command not found!  Try '$$> pacman -S msys/findutils' \
          for installation.  Or use your Linux package manager.)
else
  $(shell echo 'FIND_CMD = $(FIND_CMD)' >> $(_CACHE_FILE))
endif

SED_CMD = $(call _CMD_TEST,sed)
ifeq (,$(SED_CMD))
  $(shell rm -f $(_CACHE_FILE))
  $(error SED command not found!  Try '$$> pacman -S msys/sed' \
          for installation.  Or use your Linux package manager.)
else
  $(shell echo 'SED_CMD = $(SED_CMD)' >> $(_CACHE_FILE))
endif

DATE_CMD = $(call _CMD_TEST,date)
ifeq (,$(DATE_CMD))
  $(shell rm -f $(_CACHE_FILE))
  $(error DATE command not found!  Try '$$> pacman -S msys/coreutils' \
          for installation.  Or use your Linux package manager.)
else
  $(shell echo 'DATE_CMD = $(DATE_CMD)' >> $(_CACHE_FILE))
endif

GIT_CMD = "$(call _CMD_TEST,git)"
ifeq ("",$(GIT_CMD))
  $(shell rm -f $(_CACHE_FILE))
  $(error GIT command not found!  Try '$$> pacman -S msys/git' \
          for installation.  Or use your Linux package manager.)
else
  $(shell echo 'GIT_CMD = $(GIT_CMD)' >> $(_CACHE_FILE))
endif

BROWSER_CMD = "$(call _CMD_TEST,/usr/bin/firefox)"
ifeq ("",$(BROWSER_CMD))
  BROWSER_CMD = "$(call _CMD_TEST,/c/Program\ Files/Mozilla\ Firefox/firefox.exe)" 
endif
ifeq ("",$(BROWSER_CMD))
  BROWSER_CMD = "$(call _CMD_TEST,/c/Program\ Files/Internet\ Explorer/iexplore.exe)" 
endif
ifeq ("",$(BROWSER_CMD))
  $(warning BROWSER command not found!  Using Microsoft Edge)
  BROWSER_CMD = /c/windows/explorer.exe microsoft-edge:
endif
$(shell echo 'BROWSER_CMD = $(BROWSER_CMD)' >> $(_CACHE_FILE))

endif # ifneq (,$(_CACHE_FILE))
# -----------------------------

ifneq (,$(TEST_GIT))
  ifeq ("",$(GIT_CMD))
    $(shell rm -f $(_CACHE_FILE))
    $(error GIT command not found!  Try '$$> pacman -S msys/git' \
            for installation.  Or use your Linux package manager.)
  endif
endif

# --------------------------------------------------------------------
# Find JDK installation
ifneq (,$(_CACHE_FILE))

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
    $(shell rm -f $(_CACHE_FILE))
    $(error JAVAC command not found!  Please install the 'Java SE \
            Development Kit (JDK)' and/or set Makefile configuration \
            variable JDK_PATH in 'makefile.config.mk')
  endif
endif
$(shell echo 'MY_JAVA_HOME = $(MY_JAVA_HOME)' >> $(_CACHE_FILE))

endif # ifneq (,$(_CACHE_FILE))
# MY_JAVA_HOME is set from here
# --------------------------------------------------------------------

# End of Linux/MSYS2 commands, feature check
# ********************************************************************
