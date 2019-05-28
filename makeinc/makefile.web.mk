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
# Website stuff

$(DOCS_DIR)/_config.yml: $(DOCS_DIR)/_config.templ.yml $(MK_FILES)
	@echo "Updating '$@'"; \
	version_stable="`$(SED_CMD) -n \
	    $(call _REGEX_WEBCONFIG_RET,version_stable) $@`"; \
	zip_url="`$(SED_CMD) -n \
	    $(call _REGEX_WEBCONFIG_RET,zip_url) $@`"; \
	tar_url="`$(SED_CMD) -n \
	    $(call _REGEX_WEBCONFIG_RET,tar_url) $@`"; \
	$(SED_CMD) $(\
	  )$(call _REGEX_GRADLEVAR_REPL,GITHUB_URL,$(PROJECT_URL))$(\
	  )$(call _REGEX_GRADLEVAR_REPL,WEBSITE_URL,$(WEBSITE_URL))$(\
	  )$(call _REGEX_GRADLEVAR_REPL,GITHUB_MAVEN_URL,$(\
                  )$(GITHUB_RAW_URL)/$(MAVEN_DIR))$(\
	  )$(call _REGEX_WEBCONFIG_REPL,version_stable,$(\
                  )'"$$version_stable"')$(\
	  )$(call _REGEX_WEBCONFIG_REPL,zip_url,'"$$zip_url"')$(\
	  )$(call _REGEX_WEBCONFIG_REPL,tar_url,'"$$tar_url"')$(\
	  ) $< > $@;

# sh_cmd _DOCS_FBUILDS_WHOLESUB(file, mf_version, kind, file_ext)
_DOCS_FBUILDS_WHOLESUB = \
  $(call _SED_FBUILDSJSON_GROUPREPL,$(1),$(4)_$(3),name,$(\
     )$(MF_NAME)-$(2)-$(3).$(4)) \$(NL) \
  && $(call _SED_FBUILDSJSON_GROUPREPL,$(1),$(4)_$(3),maven-url,$(\
     )$(MAVEN_FORGE_RELDIR)/$(2)/$(MF_NAME)-$(2)-$(3).$(4)) \$(NL) \
  && $(call _SED_FBUILDSJSON_GROUPREPL,$(1),$(4)_$(3),maven-sha1,$(\
     )$(MAVEN_FORGE_RELDIR)/$(2)/$(MF_NAME)-$(2)-$(3).$(4).sha1) \$(NL) \
  && $(call _SED_FBUILDSJSON_GROUPREPL,$(1),$(4)_$(3),maven-md5,$(\
     )$(MAVEN_FORGE_RELDIR)/$(2)/$(MF_NAME)-$(2)-$(3).$(4).md5)

.SECONDEXPANSION:
$(DOCS_FORGEBUILDS_VERSION_DIR)/%.json: \
  $(DOCS_DATA_DIR)/forge_builds.templ.json \
  $(MAVEN_FORGE_DIR)/%/$(MF_NAME)-$$*.pom $(MK_FILES)
	@mkdir -p $(shell echo $@ | $(SED_CMD) $(_REGEX_DIRNAME_RET))
	@if [ -f $@ ]; then \
	  echo "Updating '$@'"; \
	  date_time="`$(SED_CMD) -n \
	              $(call _REGEX_FBUILDSJSON_RET,time) $@`"; \
	  tags="`$(SED_CMD) -n \
	         $(call _REGEX_FBUILDSJSONLIST_RET,tags) $@`"; \
	else \
	  echo "Generating '$@'"; \
	  date_time="`$(DATE_CMD) -Iseconds`"; \
	  tags='"unstable"'; \
	  latest="`$(SED_CMD) -n $(call _REGEX_PROMO_RET,latest-build)\
	           $(DOCS_DATA_DIR)/forge_promos.json`"; \
	  if [ $$latest = $(MF_VERSION_FULL) ]; then \
	    echo "Updating 'seems-to-work' to '$(MF_VERSION_FULL)'"; \
	    $(SED_CMD) -i $(call _REGEX_PROMO_REPL,seems-to-work,$(\
	      )$(MF_VERSION_FULL)) $(DOCS_DATA_DIR)/forge_promos.json; \
	  fi; \
	  echo "Updating 'latest-build' to '$*'"; \
	  $(SED_CMD) -i $(call _REGEX_PROMO_REPL,latest-build,$(\
	    )$*) $(DOCS_DATA_DIR)/forge_promos.json; \
	fi; \
	cp -f $< $@; \
	$(SED_CMD) -i $(\
	)$(call _REGEX_PACKJSON_REPL,time,'"$$date_time"')$(\
	)$(call _REGEX_FBUILDSJSONLIST_REPL,tags,'"$$tags"')$(\
	) $@;
	@$(SED_CMD) -i $(\
	)$(call _REGEX_PACKJSON_REPL,mc_version,$(shell \
	        echo $* | $(SED_CMD) 's~^\([^-]*\)-.*$$~\1~'))$(\
	)$(call _REGEX_PACKJSON_REPL,mf_version,$*)$(\
	) $@
	@$(call _DOCS_FBUILDS_WHOLESUB,$@,$*,installer,jar)
	@$(call _DOCS_FBUILDS_WHOLESUB,$@,$*,universal,jar)
	@$(call _DOCS_FBUILDS_WHOLESUB,$@,$*,userdev,jar)
	@$(call _DOCS_FBUILDS_WHOLESUB,$@,$*,launcher,jar)
	@$(call _DOCS_FBUILDS_WHOLESUB,$@,$*,src,jar)
	@$(call _DOCS_FBUILDS_WHOLESUB,$@,$*,mdk,zip)

# sh_cmd _DOCS_BUILDS_WHOLESUB(file, version)
_DOCS_BUILDS_WHOLESUB = \
  $(call _SED_FBUILDSJSON_GROUPREPL,$(1),jar,name,$(\
     )$(MODID)-$(2).jar) \$(NL) \
  && $(call _SED_FBUILDSJSON_GROUPREPL,$(1),jar,maven-url,$(\
     )$(MAVEN_MOD_RELDIR)/$(2)/$(MODID)-$(2).jar) \$(NL) \
  && $(call _SED_FBUILDSJSON_GROUPREPL,$(1),jar,maven-sha1,$(\
     )$(MAVEN_MOD_RELDIR)/$(2)/$(MODID)-$(2).jar.sha1) \$(NL) \
  && $(call _SED_FBUILDSJSON_GROUPREPL,$(1),jar,maven-md5,$(\
     )$(MAVEN_MOD_RELDIR)/$(2)/$(MODID)-$(2).jar.md5)

.SECONDEXPANSION:
$(DOCS_BUILDS_VERSION_DIR)/%.json: $(DOCS_DATA_DIR)/builds.templ.json \
  $(MAVEN_MOD_DIR)/%/$(MODID)-$$*.pom $(MK_FILES)
	@mkdir -p $(shell echo $@ | $(SED_CMD) $(_REGEX_DIRNAME_RET))
	@if [ -f $@ ]; then \
	  echo "Updating '$@'"; \
	  date_time="`$(SED_CMD) -n \
	              $(call _REGEX_FBUILDSJSON_RET,time) $@`"; \
	  version="`$(SED_CMD) -n \
	            $(call _REGEX_FBUILDSJSON_RET,version) $@`"; \
	  mc_version="`$(SED_CMD) -n \
	               $(call _REGEX_FBUILDSJSON_RET,mc_version) $@`"; \
	  mf_version="`$(SED_CMD) -n \
	               $(call _REGEX_FBUILDSJSON_RET,mf_version) $@`"; \
	  mcp_channel="`$(SED_CMD) -n \
	      $(call _REGEX_FBUILDSJSON_RET,mcp_mapping_channel) $@`"; \
	  mcp_version="`$(SED_CMD) -n \
	      $(call _REGEX_FBUILDSJSON_RET,mcp_mapping_version) $@`"; \
	  tags="`$(SED_CMD) -n \
	         $(call _REGEX_FBUILDSJSONLIST_RET,tags) $@`"; \
	  patch_notes="`$(SED_CMD) -n \
	              $(call _REGEX_FBUILDSJSONLIST_RET,patch_notes) $@`"; \
	else \
	  echo "Generating '$@'"; \
	  date_time="`$(DATE_CMD) -Iseconds`"; \
	  version="$(VERSION_FULL)"; \
	  mc_version="$(MC_VERSION)"; \
	  mf_version="$(MF_VERSION)"; \
	  mcp_channel="$(MCP_MAPPING_CHANNEL)"; \
	  mcp_version="$(MCP_MAPPING_VERSION)"; \
	  tags='"release"'; \
	  if [ -n '$(GIT_CMD)' ]; then \
	    patch_notes=\"`$(GIT_CMD) log HEAD~5..HEAD -n1 \
	      --grep=patch_notes -i --format="%b" | $(SED_CMD) \
	      ':a;N;$$!ba; s~\n~", "~g;'`\"; \
	  else \
	    patch_notes='""'; \
	    echo "warning: GIT not found!  Could not generate PATCH_NOTES"$(\
                )"." >&2; \
	  fi; \
	  echo "Updating 'latest' to '$*'"; \
	  $(SED_CMD) -i $(call _REGEX_PROMO_REPL,latest,$(\
	    )$*) $(DOCS_DATA_DIR)/promos.json; \
	  if [ "$$patch_notes" != '""' ]; then \
	    echo "Updating 'stable' to '$*'"; \
	    $(SED_CMD) -i $(call _REGEX_PROMO_REPL,stable,$(\
	      )$*) $(DOCS_DATA_DIR)/promos.json; \
	    $(SED_CMD) -i $(\
	      )$(call _REGEX_WEBCONFIG_REPL,version_stable,$*)$(\
	      ) $(DOCS_DIR)/_config.yml; \
	    $(SED_CMD) -i $(\
	      )$(call _REGEX_WEBCONFIG_REPL,zip_url,$(GITHUB_RAW_URL)$(\
	      )/$(MAVEN_DIR)/$(MAVEN_MOD_RELDIR)/$*/$(MODID)-$*.jar)$(\
	      ) $(DOCS_DIR)/_config.yml; \
	  else \
	    patch_notes='"<Not a stable version>"'; \
	    echo "warning: PATCH_NOTES not given!  Release will NOT"$(\
	        )" be promoted as stable." >&2; \
	  fi; \
	fi; \
	cp -f $< $@; \
	$(SED_CMD) -i $(\
	)$(call _REGEX_PACKJSON_REPL,time,'"$$date_time"')$(\
	)$(call _REGEX_PACKJSON_REPL,version,'"$$version"')$(\
	)$(call _REGEX_PACKJSON_REPL,mc_version,'"$$mc_version"')$(\
	)$(call _REGEX_PACKJSON_REPL,mf_version,'"$$mf_version"')$(\
	)$(call _REGEX_PACKJSON_REPL,mcp_mapping_channel,'"$$mcp_channel"')$(\
	)$(call _REGEX_PACKJSON_REPL,mcp_mapping_version,'"$$mcp_version"')$(\
	)$(call _REGEX_FBUILDSJSONLIST_REPL,tags,'"$$tags"')$(\
	)$(call _REGEX_FBUILDSJSONLIST_REPL,patch_notes,'"$$patch_notes"')$(\
	) $@;
	@$(call _DOCS_BUILDS_WHOLESUB,$@,$*)

$(DOCS_DATA_DIR)/forge_promos.json: $(MK_FILES)
	@echo "Updating 'used-for-develop' to '$(MF_VERSION_FULL)'"
	@$(SED_CMD) -i $(call _REGEX_PROMO_REPL,used-for-develop,$(\
	                 )$(MF_VERSION_FULL)) $@
	@$(SED_CMD) -i $(\
	    )$(call _REGEX_WEBCONFIG_REPL,tar_url,$(GITHUB_RAW_URL)$(\
	    )/$(MAVEN_DIR)/$(MAVEN_FORGE_RELDIR)/$(MF_VERSION_FULL)/$(\
	    )$(MF_NAME)-$(MF_VERSION_FULL)-installer.jar)$(\
	    ) $(DOCS_DIR)/_config.yml;


.PHONY: website_mf_addtag
website_mf_addtag: $(DOCS_FORGEBUILDS_VERSION_DIR)/$(MF_VERSION_FULL).json
	@if [ -z "$(TAG)" ]; then \
	  echo -e "\nERROR: Usage '$$> $(MAKE) $@ TAG=new_tag'\n" \
	       > /dev/stderr; \
	  exit 1; \
	fi
	@echo "Adding tag '$(TAG)' to Forge build '$(MF_VERSION_FULL)'"
	@tags="`$(SED_CMD) -n \
	       $(call _REGEX_FBUILDSJSONLIST_RET,tags) $<`"; \
	tags="`echo $$tags, \\\"$(TAG)\\\" | $(SED_CMD) $(\
	      )$(_REGEX_FBUILDSJSONLIST_RMCOMMA)`"; \
	$(SED_CMD) -i $(call \
	           _REGEX_FBUILDSJSONLIST_REPL,tags,'"$$tags"') $<;

.PHONY: website_addtag
website_addtag: | config_all \
  $(DOCS_BUILDS_VERSION_DIR)/$(VERSION_FULL).json website_addtag_nodep
.PHONY: website_addtag_nodep
website_addtag_nodep: | config_all
	@if [ -z "$(TAG)" ]; then \
	  echo -e "\nERROR: Usage '$$> $(MAKE) $@ TAG=new_tag'\n" \
	       > /dev/stderr; \
	  exit 1; \
	fi
	@echo "Adding tag '$(TAG)' to Build '$(VERSION_FULL)'"
	@tags="`$(SED_CMD) -n \
	       $(call _REGEX_FBUILDSJSONLIST_RET,tags) \
	              $(DOCS_BUILDS_VERSION_DIR)/$(VERSION_FULL).json`"; \
	tags="`echo $$tags, \\\"$(TAG)\\\" | $(SED_CMD) $(\
	      )$(_REGEX_FBUILDSJSONLIST_RMCOMMA)`"; \
	$(SED_CMD) -i $(call \
	           _REGEX_FBUILDSJSONLIST_REPL,tags,'"$$tags"') \
	           $(DOCS_BUILDS_VERSION_DIR)/$(VERSION_FULL).json;


.PHONY: website_mf_rmtag
website_mf_rmtag: $(DOCS_FORGEBUILDS_VERSION_DIR)/$(MF_VERSION_FULL).json
	@if [ -z "$(TAG)" ]; then \
	  echo -e "\nERROR: Usage '$$> $(MAKE) $@ TAG=bad_tag'\n" \
	       > /dev/stderr; \
	  exit 1; \
	fi
	@echo "Removing tag '$(TAG)' from Forge build '$(MF_VERSION_FULL)'"
	@tags="`$(SED_CMD) -n \
	       $(call _REGEX_FBUILDSJSONLIST_RET,tags) $<`"; \
	tags="`echo $$tags | $(SED_CMD) 's~\"$(TAG)\"~~g;'$(\
	      )$(_REGEX_FBUILDSJSONLIST_RMCOMMA)`"; \
	$(SED_CMD) -i $(call \
	           _REGEX_FBUILDSJSONLIST_REPL,tags,'"$$tags"') $<;

.PHONY: website_rmtag
website_rmtag: | config_all \
  $(DOCS_BUILDS_VERSION_DIR)/$(VERSION_FULL).json website_rmtag_nodep
.PHONY: website_rmtag_nodep
website_rmtag_nodep: | config_all
	@if [ -z "$(TAG)" ]; then \
	  echo -e "\nERROR: Usage '$$> $(MAKE) $@ TAG=bad_tag'\n" \
	       > /dev/stderr; \
	  exit 1; \
	fi
	@echo "Removing tag '$(TAG)' from Build '$(VERSION_FULL)'"
	@tags="`$(SED_CMD) -n \
	       $(call _REGEX_FBUILDSJSONLIST_RET,tags) \
	              $(DOCS_BUILDS_VERSION_DIR)/$(VERSION_FULL).json`"; \
	tags="`echo $$tags | $(SED_CMD) 's~\"$(TAG)\"~~g;'$(\
	      )$(_REGEX_FBUILDSJSONLIST_RMCOMMA)`"; \
	$(SED_CMD) -i $(call \
	           _REGEX_FBUILDSJSONLIST_REPL,tags,'"$$tags"') \
	           $(DOCS_BUILDS_VERSION_DIR)/$(VERSION_FULL).json;


.PHONY: website_forge
website_forge: | config_all $(DOCS_FORGEBUILDS_JSONS)

.PHONY: website_mod
website_mod: | config_all $(DOCS_BUILDS_JSONS)

# End of Website stuff
# ********************************************************************
