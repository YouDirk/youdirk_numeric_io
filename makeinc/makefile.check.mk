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
# Needed for checks (variables are included after this file)

# Newline variable and Error prefix variable
_BLANK :=
define NL

$(_BLANK)
endef
ERRB = $(NL)$(NL)  ERROR:

# win_path_escaped _2WINPATH_ESCAPE(unix_path)
_2WINPATH = $(shell echo '$(1)' | \
    $(SED_CMD) '/^\/.\//{s~^/\(.\)/~\1:/~;s~ ~\\ ~g}')

# unix_path_escaped _2UNIXPATH_ESCAPE(win_path)
_2UNIXPATH = $(shell echo '$(1)' | \
    $(SED_CMD) '/^.:/{s~^\(.\):~/\L\1~;s~\\~/~g;s~ ~\\ ~g}')

# ********************************************************************
# Linux/MSYS2 commands, feature check

ifneq (,$(_CACHE_FILE))

_CMD_TEST = $(shell which $(1) 2> /dev/null)

FIND_CMD = $(call _CMD_TEST,find)
ifeq (,$(FIND_CMD))
  $(shell rm -f $(_CACHE_FILE))
  $(error $(ERRB) FIND command not found!  Try '$$> pacman -S \
    msys/findutils' for installation.  Or use your Linux package manager)
else
  $(shell echo 'FIND_CMD = $(FIND_CMD)' >> $(_CACHE_FILE))
endif

SED_CMD = $(call _CMD_TEST,sed)
ifeq (,$(SED_CMD))
  $(shell rm -f $(_CACHE_FILE))
  $(error $(ERRB) SED command not found!  Try '$$> pacman -S \
    msys/sed' for installation.  Or use your Linux package manager)
else
  $(shell echo 'SED_CMD = $(SED_CMD)' >> $(_CACHE_FILE))
endif

DATE_CMD = $(call _CMD_TEST,date)
ifeq (,$(DATE_CMD))
  $(shell rm -f $(_CACHE_FILE))
  $(error $(ERRB) DATE command not found!  Try '$$> pacman -S \
    msys/coreutils' for installation.  Or use your Linux package manager)
else
  $(shell echo 'DATE_CMD = $(DATE_CMD)' >> $(_CACHE_FILE))
endif

MD5SUM_CMD = $(call _CMD_TEST,md5sum)
ifeq (,$(MD5SUM_CMD))
  $(shell rm -f $(_CACHE_FILE))
  $(error $(ERRB) MD5SUM command not found!  Try '$$> pacman -S \
    msys/coreutils' for installation.  Or use your Linux package manager)
else
  $(shell echo 'MD5SUM_CMD = $(MD5SUM_CMD)' >> $(_CACHE_FILE))
endif

SHA1SUM_CMD = $(call _CMD_TEST,sha1sum)
ifeq (,$(SHA1SUM_CMD))
  $(shell rm -f $(_CACHE_FILE))
  $(error $(ERRB) SHA1SUM command not found!  Try '$$> pacman -S \
    msys/coreutils' for installation.  Or use your Linux package manager)
else
  $(shell echo 'SHA1SUM_CMD = $(SHA1SUM_CMD)' >> $(_CACHE_FILE))
endif

GIT_CMD = "$(call _CMD_TEST,git)"
# if FAIL: GIT_CMD == ""
$(shell echo 'GIT_CMD = $(GIT_CMD)' >> $(_CACHE_FILE))

LAUNCHER_PROD_CMD = "$(call _CMD_TEST,/c/Program\ Files/Minecraft$(\
                      )/MinecraftLauncher.exe)"
ifeq ("",$(LAUNCHER_PROD_CMD))
  LAUNCHER_PROD_CMD = "$(call _CMD_TEST,/c/Program\ Files\ \(x86\)$(\
                        )/Minecraft/MinecraftLauncher.exe)"
endif
# if FAIL: LAUNCHER_PROD_CMD == ""
$(shell echo 'LAUNCHER_PROD_CMD = $(LAUNCHER_PROD_CMD)' >> $(_CACHE_FILE))

BROWSER_CMD = "$(call _CMD_TEST,/usr/bin/firefox)"
ifeq ("",$(BROWSER_CMD))
  BROWSER_CMD = "$(call _CMD_TEST,/c/Program\ Files/Mozilla\ Firefox$(\
                  )/firefox.exe)" 
endif
ifeq ("",$(BROWSER_CMD))
  BROWSER_CMD = "$(call _CMD_TEST,/c/Program\ Files\ \(x86\)/$(\
                  )Mozilla\ Firefox/firefox.exe)" 
endif
ifeq ("",$(BROWSER_CMD))
  BROWSER_CMD = "$(call _CMD_TEST,/c/Program\ Files/Internet\ Explorer$(\
                  )/iexplore.exe)" 
endif
ifeq ("",$(BROWSER_CMD))
  BROWSER_CMD = "$(call _CMD_TEST,/c/Program\ Files\ \(x86\)/$(\
                  )Internet\ Explorer/iexplore.exe)" 
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
    $(error $(ERRB) GIT command not found!  Try '$$> pacman -S msys/git' \
            for installation.  Or use your Linux package manager)
  endif
endif

ifneq (,$(TEST_LAUNCHER_PROD))
  ifeq ("",$(LAUNCHER_PROD_CMD))
    $(shell rm -f $(_CACHE_FILE))
    $(error $(ERRB) Minecraft Launcher (productive) not installed!  \
            Please download and install it from \
            'https://www.minecraft.net/download/' and try again)
  endif

  # Remove this IF condition for Linux compatibility
  ifeq (,$(APPDATA))
    $(shell rm -f $(_CACHE_FILE))
    $(error $(ERRB) Environment variable $$APPDATA to AppData path not \
            set!  Possible issues: You are not using Windows and/or not \
            running MAKE in a MSYS2 environment.  Feel free to port this \
            Makefile to another OS, for Linux it should be possible. \
            See bug tracking '#28')
  endif

  _LAUNCHER_PATH_FOUND = $(shell test -d $(1) && echo -n 1)
  LAUNCHER_PATH =

  _TRY_LAUNCHER_PATH = $(call _2UNIXPATH,$(APPDATA))/.minecraft
  ifneq (,$(call _LAUNCHER_PATH_FOUND,$(_TRY_LAUNCHER_PATH)))
    # Path seems to work
    LAUNCHER_PATH = $(_TRY_LAUNCHER_PATH)
  endif

  ifeq (,$(LAUNCHER_PATH))
    $(shell rm -f $(_CACHE_FILE))
    $(error $(ERRB) '.minecraft' path not found!  Run the productive \
            Minecraft Launcher one time to create it)
  endif

  $(shell mkdir -p $(LAUNCHER_PATH)/versions $(LAUNCHER_PATH)/mods)
  # LAUNCHER_PROD_CMD && LAUNCHER_PATH are set from here
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
  MY_JAVA_HOME = $(call _JDK_LATEST,"/c/Program Files/Java")
  ifeq (,$(call _JDK_FOUND,$(MY_JAVA_HOME)))
    MY_JAVA_HOME = $(call _JDK_LATEST,"/c/Program Files (x86)/Java")
  endif
  ifeq (,$(call _JDK_FOUND,$(MY_JAVA_HOME)))
    $(shell rm -f $(_CACHE_FILE))
    $(error $(ERRB) JAVAC command not found!  Please install the 'Java \
            SE Development Kit (JDK)' and/or set Makefile configuration \
            variable JDK_PATH in 'makefile.config.mk')
  endif
endif
$(shell echo 'MY_JAVA_HOME = $(MY_JAVA_HOME)' >> $(_CACHE_FILE))

endif # ifneq (,$(_CACHE_FILE))
# MY_JAVA_HOME is set from here
# --------------------------------------------------------------------

# End of Linux/MSYS2 commands, feature check
# ********************************************************************
