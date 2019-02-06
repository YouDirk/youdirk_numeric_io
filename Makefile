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


include makefile.config.mk

include .makefile.cache.mk
include makeinc/makefile.check.mk

include makeinc/makefile.variables.mk

# ********************************************************************
# Necessary Target definitions

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
clean: _clean_bak clean_run _clean_makecache
	-rm -rf .gradle $(BUILD_DIR)

.PHONY: jdk_version
jdk_version:
	javac -version

# --- Maintaining only ---

.PHONY: bootstrap
bootstrap: minecraft_forge config_all

# New MAKE instance, to update DOCS_FORGEBUILDS_JSONS
.PHONY: maven
maven: $(MAVEN_FORGE_DIR)/maven-metadata.xml
	$(MAKE) website_data

# --- End of Maintaining only ---

# End of Necessary Target definitions
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
	@echo "Updating '$@'"
	@$(SED_CMD) -i "s~$(MF_GROUP).test~$(MF_GROUP)~g; "\
"s~^\([ \t]*\)url *'file://.*'repo'.*$$~\\1url 'file://' + "\
"rootProject.file('../$(MAVEN_DIR)').getAbsolutePath()~g; " $@

$(MAVEN_FORGE_DIR)/maven-metadata.xml: $(MF_DIR)/build.gradle
	cd $(MF_DIR) \
	  && ./gradlew setup :forge:licenseFormat :forge:publish

# sed_cmd _SRC_PACK_SEDJSON(key, value)
_SRC_PACK_SEDJSON = 's~^\([ \t]*"$(1)" *: *"\)[^"]*~\1$(2)~g;'

$(RESOURCES_DIR)/pack.mcmeta: $(MF_RESOURCES_DIR)/pack.mcmeta Makefile
	@echo "Generating '$@'"
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
	@echo "Generating '$@'"
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

gradlew: $(MF_DIR)/gradlew
	cp -f $< $@
gradle: $(MF_DIR)/gradle gradlew
	cp -rf $< $@
gradlew.bat: $(MF_DIR)/gradlew.bat gradle
	cp -f $< $@
gradle.properties: $(MF_MDK_DIR)/gradle.properties gradlew.bat
	cp -f $< $@

# sed_cmd _BUILD_GRADLE_SEDVAL(key, value)
_BUILD_GRADLE_SEDVAL = 's~^\([ \t]*$(1) *= *['\''"]\)[^'\''"]*~\1$(2)~g;'

# sed_cmd _BUILD_GRADLE_SED_AT(key, value)
_BUILD_GRADLE_SED_AT = 's~@$(1)@~$(2)~g;'

build.gradle: $(MF_MDK_DIR)/build.gradle Makefile gradle.properties
	@echo "Generating '$@'"
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
  $(METAINF_DIR)/mods.toml $(RESOURCES_DIR)/pack.mcmeta \
  $(DOCS_DATA_DIR)/forge_promos.json

.PHONY: _cache
_cache:
.makefile.cache.mk: Makefile
	-rm -f $@
	$(MAKE) _CACHE_FILE=$@ _cache

# ********************************************************************

include makeinc/makefile.web.mk

# ********************************************************************
# Clean targets

# _CLEAN_MAKECACHE must be the last one in the dependency list,
# because it will be regenerated during recursive CLEAN calls
.PHONY: _clean_makecache
_clean_makecache:
	-rm -f .makefile.cache.mk

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
clean_all: clean_bootstrap clean_minecraft_forge clean _clean_makecache

# End of Clean targets
# ********************************************************************
