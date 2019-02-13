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
$(DOCS_FORGEBUILDS_DIR)/%.json: $(DOCS_DATA_DIR)/forge_builds.templ.json \
  $(MAVEN_FORGE_DIR)/%/$(MF_NAME)-$$*.pom $(MK_FILES)
	@if [ -f $@ ]; then \
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
	$(SED_CMD) -i $(call _REGEX_PACKJSON_REPL,time,'"$$date_time"') $@; \
	$(SED_CMD) -i $(call \
	           _REGEX_FBUILDSJSONLIST_REPL,tags,'"$$tags"') $@;
	@echo "Updating '$@'"
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

.SECONDEXPANSION:
$(DOCS_RELEASES_DIR)/%.json: $(DOCS_DATA_DIR)/builds.templ.json \
  $(MAVEN_MOD_DIR)/%/$(MODID)-$$*.pom $(MK_FILES)
	echo TODO
	touch $@

$(DOCS_DATA_DIR)/forge_promos.json: $(MK_FILES)
	@echo "Updating 'used-for-develop' to '$(MF_VERSION_FULL)'"
	@$(SED_CMD) -i $(call _REGEX_PROMO_REPL,used-for-develop,$(\
	                 )$(MF_VERSION_FULL)) $@

.PHONY: website_mf_addtag
website_mf_addtag: $(DOCS_FORGEBUILDS_DIR)/$(MF_VERSION_FULL).json
	@if [ -z "$(TAG)" ]; then \
	  echo -e "\nERROR: Usage '$$> $(MAKE) $@ TAG=new_tag'\n" \
	       > /dev/stderr; \
	  exit 1; \
	fi
	@echo "Adding tag '$(TAG)' to Forge build '$(MF_VERSION_FULL)'"
	@tags="`$(SED_CMD) -n \
	       $(call _REGEX_FBUILDSJSONLIST_RET,tags) $<`"; \
	tags="$$tags, \"$(TAG)\""; \
	$(SED_CMD) -i $(call \
	           _REGEX_FBUILDSJSONLIST_REPL,tags,'"$$tags"') $<;

.PHONY: website_mf_rmtag
website_mf_rmtag: $(DOCS_FORGEBUILDS_DIR)/$(MF_VERSION_FULL).json
	@if [ -z "$(TAG)" ]; then \
	  echo -e "\nERROR: Usage '$$> $(MAKE) $@ TAG=new_tag'\n" \
	       > /dev/stderr; \
	  exit 1; \
	fi
	@echo "Removing tag '$(TAG)' from Forge build '$(MF_VERSION_FULL)'"
	@tags="`$(SED_CMD) -n \
	       $(call _REGEX_FBUILDSJSONLIST_RET,tags) $<`"; \
	tags="`echo $$tags | $(SED_CMD) 's~\"$(TAG)\"~~g; \
	       s~, *$$~~g; s~^, *~~g; s~, *,~,~g;'`"; \
	$(SED_CMD) -i $(call \
	           _REGEX_FBUILDSJSONLIST_REPL,tags,'"$$tags"') $<;

.PHONY: website_data
website_data: | config_all $(DOCS_FORGEBUILDS_JSONS) \
  $(DOCS_RELEASES_JSONS)

# End of Website stuff
# ********************************************************************
