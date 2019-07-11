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
include makeinc/makefile.regex.mk

# Must be the first target definition
.PHONY: all
all: classes

include makeinc/makefile.web.mk
include makeinc/makefile.run.mk

# ********************************************************************
# Necessary Target definitions

.PHONY: classes
classes: | config_all
	./gradlew $(ARGS)

.PHONY: run_client
run_client: | config_all _run_client_deps
	./gradlew $(ARGS) runClient $(_CLIENT_USERNAME)
.PHONY: run_client_player2 run_client_player3 run_client_player4
run_client_player2: _CLIENT_USERNAME = --args " --username=player2"
run_client_player2: run_client
run_client_player3: _CLIENT_USERNAME = --args " --username=player3"
run_client_player3: run_client
run_client_player4: _CLIENT_USERNAME = --args " --username=player4"
run_client_player4: run_client

.PHONY: run_server
run_server: | config_all _run_server_deps
	./gradlew $(ARGS) runServer $(_SERVER_NOGUI)

.PHONY: run_server_nogui
run_server_nogui: _SERVER_NOGUI = --args nogui
run_server_nogui: run_server

.PHONY: build
build: | config_all
	./gradlew $(ARGS) build

.PHONY: run_productive_client
run_productive_client: | config_all _os_windows
	$(MAKE) TEST_LAUNCHER_PROD=1 _run_productive_client

.PHONY: run_productive_server
run_productive_server: | config_all _run_productive_server

.PHONY: run_productive_server_nogui
run_productive_server_nogui: _SERVER_NOGUI = nogui
run_productive_server_nogui: run_productive_server

# New MAKE instance, to update DOCS_BUILDS_JSONS
.PHONY: publish
publish: | config_all build $(MAVEN_MOD_DIR)/maven-metadata.xml
	$(MAKE) website_mod

.PHONY: jdk_version
jdk_version:
	javac -version

# --------------------------------------------------------------------
# Removing temporary files

.PHONY: clean_run
clean_run:
	-rm -rf $(RUN_DIR)
.PHONY: clean
clean: | _clean_bak _clean_build clean_run _clean_makecache
	-rm -rf .gradle installer.log forge-*-installer.jar.log

# --------------------------------------------------------------------
# Documentation stuff

.PHONY: javadoc
javadoc: | config_all $(JAVADOC_DIR)/index.html
	$(BROWSER_CMD)file:///$(call \
	  _2WINPATH,$(shell echo $$PWD)/$(JAVADOC_DIR)/index.html) \
	  || true

.PHONY: mf_javadoc
mf_javadoc: | config_all $(MF_JAVADOC_DIR)/index.html
	$(BROWSER_CMD)file:///$(call \
	  _2WINPATH,$(shell echo $$PWD)/$(MF_JAVADOC_DIR)/index.html) \
	  || true

# --------------------------------------------------------------------
# Developing on Forge sources

.PHONY: mf_classes
mf_classes: | config_all $(MF_DIR)/build.gradle
	cd $(MF_DIR) && ./gradlew :forge:classes

# New MAKE instance, to update DOCS_FORGEBUILDS_JSONS
.PHONY: mf_publish
mf_publish: $(MAVEN_FORGE_DIR)/maven-metadata.xml
	$(MAKE) website_forge

# --------------------------------------------------------------------
# Maintaining only

.PHONY: bootstrap
bootstrap: | forge config_all

.PHONY: clean_all
clean_all: | clean_bootstrap clean_forge clean

# End of Necessary Target definitions
# ********************************************************************

.PHONY: forge
forge:
	$(MAKE) TEST_GIT=1 _forge
.PHONY: _forge
_forge:
	$(GIT_CMD) submodule update -f --init $(MF_DIR)
	cd $(MF_DIR) && $(GIT_CMD) checkout -f $(MF_BRANCH) \
	  && $(GIT_CMD) pull -f --rebase \
	  $(foreach INODE,$(MF_FALLBACK_INODES), \
	      && $(GIT_CMD) checkout $(MF_FALLBACK_BRANCH) -- $(INODE))

.git/modules/$(MF_DIR)/HEAD .git/modules/$(MF_DIR)/FETCH_HEAD \
  $(MF_DIR)/.gitignore:
	$(error $(ERRB) Git submodule FORGE not cloned, your action \
                need it!  '$$> MAKE FORGE' is an ez way do it)

$(MF_BUILD_SRG2MCP_DIR)/output.zip: .git/modules/$(MF_DIR)/HEAD \
  .git/modules/$(MF_DIR)/FETCH_HEAD $(MF_DIR)/.gitignore
	cd $(MF_DIR) && ./gradlew setup
	@$(TOUCH_VCMD) $@

.PHONY: $(MF_DIR)/build.gradle
$(MF_DIR)/build.gradle: $(MF_BUILD_SRG2MCP_DIR)/output.zip
	@echo "Updating '$@'"
	@$(SED_CMD) -i \
	  "s~$(MF_GROUP).test~$(MF_GROUP)~g;$(\
	  )s~^\([ \t]*\)url *'file://.*'repo'.*$$~\\1url 'file://' + $(\
	  )rootProject.file('../$(MAVEN_DIR)').getAbsolutePath()~g; " $@
	@if [ -z "`$(SED_CMD) -n '\~../$(MAVEN_DIR)~i\ok' $@`" ]; then \
	  printf "$(ERR2) Could not patch maven repository in file" \
	         "'$@'!\n\n" >&2; \
	  exit 1; \
	fi

.PHONY: $(MAVEN_FORGE_DIR)/maven-metadata.xml
$(MAVEN_FORGE_DIR)/maven-metadata.xml: $(MF_DIR)/build.gradle
	cd $(MF_DIR) && ./gradlew :forge:licenseFormat :forge:publish
	@$(DOS2UNIX_VCMD) $@ `$(FIND_CMD) $(MAVEN_FORGE_DIR) -name '*.pom'`

$(RESOURCES_DIR)/pack.mcmeta: $(MF_RESOURCES_DIR)/pack.mcmeta $(MK_FILES)
	@echo "Generating '$@'"
	@$(SED_CMD) $(\
	)$(call _REGEX_PACKJSON_REPL,description,$(MODDESC_ONELINE))$(\
	) $< > $@

$(METAINF_DIR)/mods.toml: $(MF_METAINF_DIR)/mods.toml $(MK_FILES)
	@echo "Generating '$@'"
	@$(SED_CMD) $(\
	)$(call _REGEX_MODS_REPL,updateJSONURL,$(UPDATE_JSON_URL))$(\
	)$(call _REGEX_MODS_REPL,issueTrackerURL,$(BUGTRACKING_URL))$(\
	)$(call _REGEX_MODS_REPL,displayURL,$(WEBSITE_URL))$(\
	)$(call _REGEX_MODS_REPL,logoFile,$(LOGO_FILE))$(\
	)$(call _REGEX_MODS_REPL,authors,$(CREDITS))$(\
	)$(call _REGEX_MODS_REPL,credits,$(MODTHANKS))$(\
	)'s~^\[\[dependencies.examplemod\]\]\( *\)[^ #]*$(\
	  )~[[dependencies.$(MODID)]]\1~g;' \
	$< > $@
	@$(SED_CMD) -i \
	  ':a;N;$$!ba; '"s~\\ndescription \\?= \\?'''.*\\n'''$(\
	  )~\\ndescription='''\\n$(MODDESC)\\n'''~g;" $@
	@$(call _REGEX_MODS_GROUPREPL,$@,mods,modId,$(MODID))
	@$(call _REGEX_MODS_GROUPREPL,$@,mods,version,$(VERSION_FULL))
	@$(call _REGEX_MODS_GROUPREPL,$@,mods,displayName,$(MODNAME))

$(JAVA_DIR)/%.java: $(JAVA_DIR)/%.java.templ $(MK_FILES)
	@echo "Generating '$@'"
	@$(SED_CMD) $(\
	)$(call _REGEX_GRADLEVAR_REPL,MODID,$(MODID))$(\
	)$(call _REGEX_GRADLEVAR_REPL,MC_VERSION,$(MC_VERSION))$(\
	)$(call _REGEX_GRADLEVAR_REPL,VERSION_MAJOR,$(VER_MAJOR))$(\
	)$(call _REGEX_GRADLEVAR_REPL,VERSION_API,$(VER_API))$(\
	)$(call _REGEX_GRADLEVAR_REPL,VERSION_MINOR,$(VER_MINOR))$(\
	)$(call _REGEX_GRADLEVAR_REPL,VERSION_PATCH,$(VER_PATCH))$(\
	)$(call _REGEX_GRADLEVAR_REPL,VERSION_SUFFIX,$(VER_SUFFIX))$(\
	) $< > $@

gradlew: $(MF_DIR)/gradlew
	@echo "Generating '$@'"
	@$(call DOS2UNIX_CP_VCMD,$<,$@)
gradle: $(MF_DIR)/gradle gradlew
	cp -rf $< $@
gradlew.bat: $(MF_DIR)/gradlew.bat gradle
	@echo "Generating '$@'"
	@$(call DOS2UNIX_CP_VCMD,$<,$@)

gradle.properties: $(MF_MDK_DIR)/gradle.properties gradlew.bat
	@echo "Generating '$@'"
	@$(call DOS2UNIX_CP_VCMD,$<,$@)

build.gradle: $(MF_MDK_DIR)/build.gradle $(MK_FILES) gradle.properties
	@echo "Generating '$@'"
	@$(call DOS2UNIX_CP_VCMD,$<,$@)
	@$(SED_CMD) -i $(\
	)$(call _REGEX_GRADLE_REPL,version,$(VERSION_FULL))$(\
	)$(call _REGEX_GRADLE_REPL,group,$(GROUP))$(\
	)$(call _REGEX_GRADLE_REPL,archivesBaseName,$(MODID))$(\
	)$(call _REGEX_GRADLEVAR_REPL \
	        ,MAPPING_CHANNEL,$(MCP_MAPPING_CHANNEL))$(\
	)$(call _REGEX_GRADLEVAR_REPL \
	        ,MAPPING_VERSION,$(MCP_MAPPING_VERSION))$(\
	)$(call _REGEX_GRADLEVAR_REPL \
	        ,FORGE_GROUP,$(MF_GROUP))$(\
	)$(call _REGEX_GRADLEVAR_REPL \
	        ,FORGE_NAME,$(MF_NAME))$(\
	)$(call _REGEX_GRADLEVAR_REPL \
	        ,FORGE_VERSION,$(MF_VERSION_FULL))$(\
	)$(call _REGEX_GRADLEMANIFEST_REPL \
	        ,Specification-Title,$(MODID)_api)$(\
	)$(call _REGEX_GRADLEMANIFEST_REPL \
	        ,Specification-Vendor,$(VENDOR))$(\
	)$(call _REGEX_GRADLEMANIFEST_REPL \
	        ,Specification-Version,$(VERSION_SPEC))$(\
	)$(call _REGEX_GRADLEMANIFEST_REPL \
	        ,Implementation-Title,$(MODNAME))$(\
	)$(call _REGEX_GRADLEMANIFEST_REPL \
	        ,Implementation-Vendor,$(VENDOR))$(\
	)$(call _REGEX_GRADLEMANIFEST_REPL \
	        ,Implementation-Version,$(VERSION_FULL))$(\
	)'s~minecraft \?{~repositories {\n'$(\
	  )"  maven { url 'file://' + rootProject.file('$(MAVEN_DIR)')"$(\
	  )".getAbsolutePath() }\n"$(\
	  )'}\n\n'$(\
	  )'minecraft {\n\n'$(\
	  )'    tasks.withType(JavaCompile) {\n'$(\
	  )'      options.compilerArgs << "-Xlint:unchecked"'$(\
	                            )' << "-Xlint:deprecation"\n'$(\
	  )'    }\n\n'$(\
	  )'    sourceSets {\n'$(\
	  )'      debug {\n'$(\
	  )'        java.srcDirs += sourceSets.main.java.srcDirs\n'$(\
	  )'        resources.srcDirs += sourceSets.main.resources.srcDirs\n'$(\
	  )'        compileClasspath = sourceSets.main.compileClasspath\n'$(\
	  )'        runtimeClasspath = sourceSets.main.runtimeClasspath\n'$(\
	  )'      }\n'$(\
	  )'    }\n\n'$(\
	  )"    defaultTasks 'compileDebugJava', 'processResources'\n"$(\
	  )'~g;'$(\
	  )'s~\(source sourceSets.\)main~\1debug~g;'$(\
	)'s~examplemod~$(MODID)~g;' \
	$@

.PHONY: mf_deinit
mf_deinit:
	$(MAKE) TEST_GIT=1 _mf_deinit
.PHONY: _mf_deinit
_mf_deinit:
	$(GIT_CMD) submodule deinit -f $(MF_DIR)

$(JAVADOC_DIR)/index.html: $(SRC_FILES)
	./gradlew javadoc || true
	@$(TOUCH_VCMD) $@

# Depends on $(MF_DIR)/BUILD.GRADLE, but it is PHONY
$(MF_JAVADOC_DIR)/index.html: $(MF_BUILD_SRG2MCP_DIR)/output.zip
	cd $(MF_DIR) && ./gradlew :forge:javadoc || true
	@$(TOUCH_VCMD) $@

# Only if $(MF_DIR) is checked out
.PHONY: config_all
ifeq (,$(wildcard $(MF_MDK_DIR)/build.gradle))
config_all:
else
config_all: build.gradle $(DOCS_DIR)/_config.yml \
  $(METAINF_DIR)/mods.toml $(JAVA_MOD_DIR)/common/Props.java \
  $(RESOURCES_DIR)/pack.mcmeta $(DOCS_DATA_DIR)/forge_promos.json
endif

.PHONY: _cache
_cache:
.makefile.cache.mk: $(MK_FILES)
	-rm -f $@
	$(MAKE) _CACHE_FILE=$@ _cache

# ********************************************************************

$(BUILDLIBS_DIR)/$(BUILD_JARNAME).jar: $(SRC_FILES)
	./gradlew build

$(MAVEN_MOD_DIR)/$(VERSION_FULL)/$(BUILD_JARNAME).jar: \
  $(BUILDLIBS_DIR)/$(BUILD_JARNAME).jar
	@echo "Generating '$@.*'"
	@mkdir -p $(MAVEN_MOD_DIR)/$(VERSION_FULL)
	@cp -f $< $@
	@$(SHA1SUM_CMD) $@ | $(SED_CMD) 's~ .*~~' > $@.sha1
	@$(MD5SUM_CMD) $@ | $(SED_CMD) 's~ .*~~' > $@.md5

$(MAVEN_MOD_DIR)/$(VERSION_FULL)/$(BUILD_JARNAME).pom: \
  $(MAVEN_MOD_DIR)/pom.templ.xml \
  $(MAVEN_MOD_DIR)/$(VERSION_FULL)/$(BUILD_JARNAME).jar
	@echo "Generating '$@.*'"
	@$(SED_CMD) $(\
	)$(call _REGEX_GRADLEVAR_REPL,GROUP_ID,$(GROUP))$(\
	)$(call _REGEX_GRADLEVAR_REPL,ARTIFACT_ID,$(MODID))$(\
	)$(call _REGEX_GRADLEVAR_REPL,VERSION,$(VERSION_FULL))$(\
	)$(call _REGEX_GRADLEVAR_REPL,NAME,$(MODNAME))$(\
	)$(call _REGEX_GRADLEVAR_REPL,DESCRIPTION,$(MODDESC_ONELINE))$(\
	)$(call _REGEX_GRADLEVAR_REPL,URL,$(WEBSITE_URL))$(\
	)$(call _REGEX_GRADLEVAR_REPL,LICENSE_NAME,$(LICENSE_SHORT))$(\
	)$(call _REGEX_GRADLEVAR_REPL,LICENSE_URL,$(LICENSE_URL))$(\
	)$(call _REGEX_GRADLEVAR_REPL,SCM_CONNECTION,scm:git:$(GIT_URL))$(\
	)$(call _REGEX_GRADLEVAR_REPL,SCM_DEVCONNECTION,scm:git:$(GIT_URL))$(\
	)$(call _REGEX_GRADLEVAR_REPL,SCM_URL,$(PROJECT_URL))$(\
	)$(call _REGEX_GRADLEVAR_REPL,ISSUE_SYSTEM,$(BUGTRACKING_SYSTEM))$(\
	)$(call _REGEX_GRADLEVAR_REPL,ISSUE_URL,$(BUGTRACKING_URL))$(\
	) $< > $@
	@$(SHA1SUM_CMD) $@ | $(SED_CMD) 's~ .*~~' > $@.sha1
	@$(MD5SUM_CMD) $@ | $(SED_CMD) 's~ .*~~' > $@.md5

$(MAVEN_MOD_DIR)/maven-metadata.xml: \
  $(MAVEN_MOD_DIR)/$(VERSION_FULL)/$(BUILD_JARNAME).pom
	@echo "Updating '$@.*'"
	@$(SED_CMD) -i $(\
	)$(call _REGEX_POMXML_REPL,2,groupId,$(GROUP))$(\
	)$(call _REGEX_POMXML_REPL,2,artifactId,$(MODID))$(\
	)$(call _REGEX_POMXML_REPL,4,release,$(VERSION_FULL))$(\
	)$(call _REGEX_POMXML_REPL,4,lastUpdated,$(shell $(DATE_CMD) \
	        -u '+%Y%m%d%H%M%S'))$(\
	) $@
	@if [ -z `$(SED_CMD) -n $(call _REGEX_POMXML_EXIST,version$(\
	         ),$(VERSION_FULL)) $@` ]; then \
	  echo "Adding version $(VERSION_FULL) to '$@'"; \
	  $(SED_CMD) -i \
	    $(call _REGEX_POMXML_ADDVERSION,$(VERSION_FULL)) $@; \
	fi
	@$(SHA1SUM_CMD) $@ | $(SED_CMD) 's~ .*~~' > $@.sha1
	@$(MD5SUM_CMD) $@ | $(SED_CMD) 's~ .*~~' > $@.md5

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

.PHONY: _clean_build
_clean_build:
	-rm -rf $(BUILD_DIR)

.PHONY: clean_forge
clean_forge:
	$(MAKE) TEST_GIT=1 _clean_forge
.PHONY: _clean_forge
_clean_forge:
	(cd $(MF_DIR) && $(GIT_CMD) checkout build.gradle \
	  && $(GIT_CMD) clean -xdf) 2> /dev/null || true

.PHONY: clean_bootstrap
clean_bootstrap:
	-rm -f build.gradle gradle.properties
	-rm -rf gradle gradlew{,.bat}
	-rm -f $(RESOURCES_DIR)/pack.mcmeta $(METAINF_DIR)/mods.toml

.PHONY: clean_javadoc
clean_javadoc:
	-rm -rf $(JAVADOC_DIR)

.PHONY: mf_clean_javadoc
mf_clean_javadoc:
	-rm -rf $(MF_JAVADOC_DIR)

.PHONY: clean_gradlecache
clean_gradlecache: _clean_build
	@win_home=$(call _2UNIXPATH,$(USERPROFILE)); \
	unix_home=$(call _2UNIXPATH,$(HOME)); \
	if [ -d "$$win_home/$(GRADLE_CACHE_DIR)" ]; then \
	  my_home="$$win_home"; \
	elif [ -d "$$unix_home/$(GRADLE_CACHE_DIR)" ]; then \
	  my_home="$$unix_home"; \
	else \
	  printf "$(ERR2) Could not find the Gradle Cache!\n\n" >&2; \
	  exit 1; \
	fi; \
	echo "Cleaning Gradle cache$(\
	     ) '$$my_home/$(GRADLE_CACHE_USERREPO_DIR)'"; \
	rm -rf "$$my_home/$(GRADLE_CACHE_USERREPO_DIR)"

# End of Clean targets
# ********************************************************************

# For tests with productive Launcher installation, downloaded from
# https://www.minecraft.net/download/

.PHONY: _os_windows
_os_windows:
	@if [ -z "$(OS_IS_WIN)" ]; then \
	  printf "$(ERR2) This action runs only under Windows OS :($(\
                 ) ...  You need to setup your productive Minecraft$(\
	         ) Launcher manually.\n\n" >&2; \
	  exit 1; \
	fi

# Build only if file not exist
$(MAVEN_FORGE_CURINSTALLER):
	$(MAKE) $(MAVEN_FORGE_DIR)/maven-metadata.xml

# --- Client ---

.PHONY: mf_install_client
mf_install_client: | config_all _os_windows
	$(MAKE) TEST_LAUNCHER_PROD=1 _mf_install_client
.PHONY: _mf_install_client
_mf_install_client: $(MAVEN_FORGE_CURINSTALLER)
	java -jar $<

.PHONY: install_client
install_client: | config_all _os_windows
	$(MAKE) TEST_LAUNCHER_PROD=1 _install_client
.PHONY: _install_client
_install_client: $(BUILDLIBS_DIR)/$(BUILD_JARNAME).jar
	@if [ ! -d $(LAUNCHER_PATH)/versions/$(MC_VERSION)-$(MF_NAME)$(\
	           )-$(MF_VERSION) ]; then \
	  $(MAKE) _mf_install_client; \
	else \
	  echo 'skipped: Minecraft Forge $(MF_VERSION_FULL)$(\
	       ) installation'; \
	fi
	@mkdir -p $(LAUNCHER_PATH)/mods && cp -fv $< $(LAUNCHER_PATH)/mods/

.PHONY: _run_productive_client
_run_productive_client: _install_client
	@echo "Running productive Minecraft Launcher"
	@$(LAUNCHER_PROD_CMD)

# --- Server ---

.PHONY: _productive_server_dir
_productive_server_dir:
	@if [ -z "$(PREFIX)" ]; then \
	  printf \
	  "$(ERR2) Usage '$$> $(MAKE) <target> PREFIX=1' installs to$(\
	    ) directory '$(RUN_SERVERPROD_DIR)'\n$(\
	  )$(ERRS)    or '$$> $(MAKE) <target> PREFIX=\"/c/path_to$(\
	    )/installdir\"'\n\n" >&2; \
	  exit 1; \
	fi
	@if [ "$(PREFIX)" = "1" ]; then \
	  printf "$(WAR2) Using default install directory$(\
                 ) '$(INSTALL_SERVERDIR)'!\n\n" >&2; \
	fi

.PHONY: mf_install_server
mf_install_server: \
  | config_all _productive_server_dir $(MAVEN_FORGE_CURINSTALLER)
	@installer="`echo $$PWD`/$(MAVEN_FORGE_CURINSTALLER)"; \
	echo "Installing Minecraft Forge Server to$(\
	     ) '$(INSTALL_SERVERDIR)'"; \
	mkdir -p "$(INSTALL_SERVERDIR)" && cd "$(INSTALL_SERVERDIR)" \
	  && java -jar "$$installer" --installServer

.PHONY: install_server
install_server: | config_all \
  _productive_server_dir $(BUILDLIBS_DIR)/$(BUILD_JARNAME).jar
	@if [ ! -f \
             "$(INSTALL_SERVERDIR)/$(RUN_SERVER_JARNAME).jar" ]; then \
	  $(MAKE) mf_install_server PREFIX="$(INSTALL_SERVERDIR)"; \
	else \
	  echo 'skipped: Minecraft Forge Server $(MF_VERSION_FULL)$(\
	       ) installation'; \
	fi
	@mkdir -p "$(INSTALL_SERVERDIR)/mods/" \
	  && cp -fv $(BUILDLIBS_DIR)/$(BUILD_JARNAME).jar $(\
	  )"$(INSTALL_SERVERDIR)/mods/"

.PHONY: _run_productive_server
_run_productive_server: | config_all \
  _productive_server_dir install_server _run_productive_server_deps
	@echo "Running productive dedicated Minecraft Forge server"
	@cd "$(INSTALL_SERVERDIR)" \
	  && java -jar $(RUN_SERVER_JARNAME).jar $(_SERVER_NOGUI)

# End productive Launcher stuff
# ********************************************************************
