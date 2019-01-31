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
VERSION = 0.0.0.1-dummy

# Dependency Version stuff
MC_VERSION = 1.13

# Official version from <https://files.minecraftforge.net/> or self
# deployed version from DOCS/MAVEN directory
MF_VERSION = 24.0.97-1.13-pre

# Official Mappings are here <http://export.mcpbot.bspk.rs/>
MCP_MAPPING_CHANNEL = snapshot
MCP_MAPPING_VERSION = 20180921-1.13

# Mincraft Forge branch/commit from which will be bootstraped
MF_BRANCH = 1.13-pre

# Mincraft Forge branch/commit from which will be bootstraped
# if current development is too heavily
MF_FALLBACK_BRANCH = origin/1.12.x

# (optional) Inodes (files, directories, etc) relative to
# MINECRAFT_FORGE directory which will be using fallback versions
MF_FALLBACK_INODES =

# Comma separated list
CREDITS = Dirk (YouDirk) Lehmann

# End of Configuration
include .makefile.cache.inc
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
            variable JDK_PATH)
  endif
endif
$(shell echo 'MY_JAVA_HOME = $(MY_JAVA_HOME)' >> $(_CACHE_FILE))

endif # ifneq (,$(_CACHE_FILE))
# MY_JAVA_HOME is set from here
# --------------------------------------------------------------------

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

LOGO_FILE = youdirk_numeric_io.png
WEBSITE_URL = https://youdirk.github.io/youdirk_numeric_io
BUGTRACKING_URL = https://github.com/YouDirk/youdirk_numeric_io/issues
UPDATE_JSON_URL = $(WEBSITE_URL)/releases/update.json

_BLANK :=
define NL

$(_BLANK)
endef

# ********************************************************************
# Environment variables

PATH := $(MY_JAVA_HOME)/bin:$(PATH)
JAVA_HOME := $(MY_JAVA_HOME)

# ********************************************************************
# Target definitions

.PHONY: all
all: config_all
	./gradlew classes

.PHONY: classes
classes: config_all
	./gradlew classes

.PHONY: run_client
run_client: config_all
	./gradlew runClient

.PHONY: run_server
run_server: config_all
	./gradlew runServer

.PHONY: build
build: config_all
	./gradlew build

.PHONY: javadoc
javadoc: config_all $(JAVADOC_DIR)/index.html
	$(BROWSER_CMD)file:///$(call \
	  _2WINPATH,$(PWD)/$(JAVADOC_DIR)/index.html) || true

.PHONY: mf_javadoc
mf_javadoc: config_all $(MF_JAVADOC_DIR)/index.html
	$(BROWSER_CMD)file:///$(call \
	  _2WINPATH,$(PWD)/$(MF_JAVADOC_DIR)/index.html) || true

.PHONY: clean_run
clean_run:
	-rm -rf $(RUN_DIR)
.PHONY: clean
clean: _clean_bak clean_run
	-rm -rf .gradle $(BUILD_DIR) .makefile.cache.inc

.PHONY: jdk_version
jdk_version:
	javac -version

# --- Maintaining only ---

.PHONY: bootstrap
bootstrap: minecraft_forge config_all

.PHONY: maven
maven: $(MAVEN_FORGE_DIR)/maven-metadata.xml

# --- End of Maintaining only ---

# ********************************************************************

.PHONY: minecraft_forge
minecraft_forge:
	$(MAKE) TEST_GIT=1 _minecraft_forge
.PHONY: _minecraft_forge
_minecraft_forge:
	$(GIT_CMD) submodule update -f --init $(MF_DIR)
	cd $(MF_DIR) && $(GIT_CMD) checkout -f $(MF_BRANCH) \
	  && $(GIT_CMD) pull -f --rebase \
	  $(foreach INODE,$(MF_FALLBACK_INODES), \
	      && $(GIT_CMD) checkout $(MF_FALLBACK_BRANCH) -- $(INODE))

$(MF_DIR)/build.gradle: .git/modules/$(MF_DIR)/HEAD \
  .git/modules/$(MF_DIR)/FETCH_HEAD
	$(SED_CMD) -i "s~$(MF_GROUP).test~$(MF_GROUP)~g; "\
"s~^\([ \t]*\)url *'file://.*'repo'.*$$~\\1url 'file://' + "\
"rootProject.file('../$(MAVEN_DIR)').getAbsolutePath()~g; " $@

$(MAVEN_FORGE_DIR)/maven-metadata.xml: $(MF_DIR)/build.gradle
	cd $(MF_DIR) \
	  && ./gradlew setup :forge:licenseFormat :forge:publish

# sed_cmd _SRC_PACK_SEDJSON(key, value)
_SRC_PACK_SEDJSON = 's~^\([ \t]*"$(1)" *: *"\)[^"]*~\1$(2)~g;'

$(RESOURCES_DIR)/pack.mcmeta: $(MF_RESOURCES_DIR)/pack.mcmeta Makefile
	@echo Generating '$@'
	@$(SED_CMD) $(\
	)$(call _SRC_PACK_SEDJSON,description,$(MODDESC_ONELINE))$(\
	) $< > $@

# sed_cmd _SRC_MODS_SEDCMD(key, value)
_SRC_MODS_SEDCMD = 's~^\([ \t]*$(1) *= *"\)[^"]*~\1$(2)~g;'

# sed_cmd _SRC_MODS_SEDGROUP(file, group, key, value)
_SRC_MODS_SEDGROUP = $(SED_CMD) -i \
  ':a;N;$$!ba; s~\(\n *\[\[$(2)\]\][^\n]*\n[^[]*$(3) *= *"\)[^"]*~\1$(4)~g;'\
  $(1)

$(METAINF_DIR)/mods.toml: $(MF_METAINF_DIR)/mods.toml Makefile
	@echo Generating '$@'
	@$(SED_CMD) $(\
	)$(call _SRC_MODS_SEDCMD,updateJSONURL,$(UPDATE_JSON_URL))$(\
	)$(call _SRC_MODS_SEDCMD,issueTrackerURL,$(BUGTRACKING_URL))$(\
	)$(call _SRC_MODS_SEDCMD,displayURL,$(WEBSITE_URL))$(\
	)$(call _SRC_MODS_SEDCMD,logoFile,$(LOGO_FILE))$(\
	)$(call _SRC_MODS_SEDCMD,authors,$(CREDITS))$(\
	)$(call _SRC_MODS_SEDCMD,credits,$(MODTHANKS))\
's~^\[\[dependencies.examplemod\]\]\( *\)[^ #]*~[[dependencies.$(MODID)]]\1~g; '\
	  $< > $@
	@$(SED_CMD) -i ':a;N;$$!ba; '"s~\\ndescription \\?= \\?'''.*\\n'''"\
"~\\ndescription='''\\n$(MODDESC)\\n'''~g;" $@
	@$(call _SRC_MODS_SEDGROUP,$@,mods,modId,$(MODID))
	@$(call _SRC_MODS_SEDGROUP,$@,mods,version,$(VERSION_FULL))
	@$(call _SRC_MODS_SEDGROUP,$@,mods,displayName,$(MODNAME))

gradle: $(MF_DIR)/gradle
	cp -rf $< $@
gradlew: $(MF_DIR)/gradlew gradle
	cp -f $< $@
gradlew.bat: $(MF_DIR)/gradlew.bat gradlew
	cp -f $< $@
gradle.properties: $(MF_MDK_DIR)/gradle.properties gradlew.bat
	cp -f $< $@

# sed_cmd _BUILD_GRADLE_SEDVAL(key, value)
_BUILD_GRADLE_SEDVAL = 's~^\([ \t]*$(1) *= *['\''"]\)[^'\''"]*~\1$(2)~g;'

# sed_cmd _BUILD_GRADLE_SED_AT(key, value)
_BUILD_GRADLE_SED_AT = 's~@$(1)@~$(2)~g;'

build.gradle: $(MF_MDK_DIR)/build.gradle Makefile gradle.properties
	@echo Generating '$@'
	@$(SED_CMD) $(\
	)$(call _BUILD_GRADLE_SEDVAL,version,$(VERSION_FULL))$(\
	)$(call _BUILD_GRADLE_SEDVAL,group,$(GROUP))$(\
	)$(call _BUILD_GRADLE_SEDVAL,archivesBaseName,$(MODID))$(\
	)$(call _BUILD_GRADLE_SED_AT,MAPPING_CHANNEL,$(MCP_MAPPING_CHANNEL))$(\
	)$(call _BUILD_GRADLE_SED_AT,MAPPING_VERSION,$(MCP_MAPPING_VERSION))$(\
	)$(call _BUILD_GRADLE_SED_AT,FORGE_GROUP,$(MF_GROUP))$(\
	)$(call _BUILD_GRADLE_SED_AT,FORGE_NAME,$(MF_NAME))$(\
	)$(call _BUILD_GRADLE_SED_AT,FORGE_VERSION,$(MF_VERSION_FULL))$(\
	)$(call _BUILD_GRADLE_SED_AT,MC_VERSION,$(MF_VERSION_FULL))$(\
	)\
's~META_INF/mods.toml~META-INF/mods.toml~g; '\
's~minecraft \?{~repositories {\n'\
"  maven { url 'file://' + rootProject.file('$(MAVEN_DIR)')"\
".getAbsolutePath() }\n"\
'}\n'\
'\nminecraft {~g; '\
	  $< > $@

.PHONY: mf_deinit
mf_deinit:
	$(MAKE) TEST_GIT=1 _mf_deinit
.PHONY: _mf_deinit
_mf_deinit:
	$(GIT_CMD) submodule deinit $(MF_DIR)

$(JAVADOC_DIR)/index.html: $(JAVA_FILES)
	./gradlew javadoc && touch $(JAVADOC_DIR)/index.html

$(MF_JAVADOC_DIR)/index.html: $(MF_DIR)/build.gradle
	cd $(MF_DIR) \
	  && ./gradlew setup :forge:licenseFormat :forge:javadoc || true

.PHONY: config_all
config_all: build.gradle \
  $(METAINF_DIR)/mods.toml $(RESOURCES_DIR)/pack.mcmeta

.PHONY: _cache
_cache:
.makefile.cache.inc: Makefile
	-rm -f $@
	$(MAKE) _CACHE_FILE=$@ _cache

# ********************************************************************

# sh_cmd _DOCS_FBUILDS_SUBREGEX(file, group, key, value)
_DOCS_FBUILDS_SUBREGEX = $(SED_CMD) -i ':a;N;$$!ba; '$(\
  )'s~\(\n *"$(2)" *: *{ *\n[^}]*"$(3)" *: *"\)[^"]*~\1$(4)~g;' $(1)

# sh_cmd _DOCS_FBUILDS_SUBREGEX(file, mf_version, kind, file_ext)
_DOCS_FBUILDS_WHOLESUB = \
  $(call _DOCS_FBUILDS_SUBREGEX,$(1),$(4)_$(3),name,$(\
         )$(MF_NAME)-$(2)-$(3).$(4)) \$(NL) \
  && $(call _DOCS_FBUILDS_SUBREGEX,$(1),$(4)_$(3),maven-url,$(\
            )$(MAVEN_FORGE_RELDIR)/$(2)/$(MF_NAME)-$(2)-$(3).$(4)) \$(NL) \
  && $(call _DOCS_FBUILDS_SUBREGEX,$(1),$(4)_$(3),maven-sha1,$(\
            )$(MAVEN_FORGE_RELDIR)/$(2)/$(MF_NAME)-$(2)-$(3).$(4).sha1) \$(NL) \
  && $(call _DOCS_FBUILDS_SUBREGEX,$(1),$(4)_$(3),maven-md5,$(\
            )$(MAVEN_FORGE_RELDIR)/$(2)/$(MF_NAME)-$(2)-$(3).$(4).md5)

.SECONDEXPANSION:
$(DOCS_FORGEBUILDS_DIR)/%.json: $(DOCS_DATA_DIR)/forge_builds.templ.json \
  $(MAVEN_FORGE_DIR)/%/$(MF_NAME)-$$*.pom Makefile
	@if [ ! -f $@ ]; then \
	  echo Generating '$@'; \
	  cp -f $< $@; \
	  $(SED_CMD) -i $(\
	  )$(call _SRC_PACK_SEDJSON,time,$(shell \
	          $(DATE_CMD) -Iseconds))$(\
	  )\
	    $@; \
	fi
	@echo Updating '$@'
	@$(SED_CMD) -i $(\
	)$(call _SRC_PACK_SEDJSON,mc_version,$(shell \
	        echo $* | $(SED_CMD) 's~^\([^-]*\)-.*$$~\1~'))$(\
	)$(call _SRC_PACK_SEDJSON,mf_version,$*)$(\
	) $@
	@$(call _DOCS_FBUILDS_WHOLESUB,$@,$*,installer,jar)
	@$(call _DOCS_FBUILDS_WHOLESUB,$@,$*,universal,jar)
	@$(call _DOCS_FBUILDS_WHOLESUB,$@,$*,userdev,jar)
	@$(call _DOCS_FBUILDS_WHOLESUB,$@,$*,launcher,jar)
	@$(call _DOCS_FBUILDS_WHOLESUB,$@,$*,src,jar)
	@$(call _DOCS_FBUILDS_WHOLESUB,$@,$*,mdk,zip)

# ********************************************************************

.PHONY: _clean_bak
_clean_bak:
	-rm -f $(shell $(FIND_CMD) . -name '*~')

.PHONY: clean_minecraft_forge
clean_minecraft_forge:
	$(MAKE) TEST_GIT=1 _clean_minecraft_forge
.PHONY: _clean_minecraft_forge
_clean_minecraft_forge:
	cd $(MF_DIR) && $(GIT_CMD) checkout build.gradle \
	  && $(GIT_CMD) clean -xdf

.PHONY: clean_bootstrap
clean_bootstrap:
	-rm -f build.gradle gradle.properties
	-rm -rf gradle gradlew{,.bat}
	-rm -f $(RESOURCES_DIR)/pack.mcmeta $(METAINF_DIR)/mods.toml

.PHONY: clean_all
clean_all: clean clean_bootstrap clean_minecraft_forge

# ********************************************************************
