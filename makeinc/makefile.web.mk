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

# sed_cmd _DOCS_FBUILDS_JSONPARSE(key)
_DOCS_FBUILDS_JSONPARSE = 's~^[ \t]*"$(1)" *: *"\([^"]*\).*~\1~p;'

# sed_cmd _DOCS_FBUILDS_LISTREGEX(key, value)
_DOCS_FBUILDS_LISTREGEX = 's~^\([ \t]*"$(1)" *: *\[\)[^]]*~\1$(2)~g;'
# comma_list _DOCS_FBUILDS_LISTPARSE(key)
_DOCS_FBUILDS_LISTPARSE = 's~^[ \t]*"$(1)" *: *\[\([^]]*\).*~\1~p;'

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
	@if [ -f $@ ]; then \
	  date_time="`$(SED_CMD) -n \
	              $(call _DOCS_FBUILDS_JSONPARSE,time) $@`"; \
	  tags="`$(SED_CMD) -n \
	         $(call _DOCS_FBUILDS_LISTPARSE,tags) $@`"; \
	else \
	  echo "Generating '$@'"; \
	  date_time="`$(DATE_CMD) -Iseconds`"; \
	  tags='"unstable"'; \
	  latest="`$(SED_CMD) -n $(call _WEBSITE_PROMO_PARSE,latest-build)\
	           $(DOCS_DATA_DIR)/forge_promos.json`"; \
	  if [ $$latest = $(MF_VERSION_FULL) ]; then \
	    echo "Updating 'seems-to-work' to '$(MF_VERSION_FULL)'"; \
	    $(SED_CMD) -i $(call _WEBSITE_PROMO_REGEX,seems-to-work,$(\
	      )$(MF_VERSION_FULL)) $(DOCS_DATA_DIR)/forge_promos.json; \
	  fi; \
	  echo "Updating 'latest-build' to '$*'"; \
	  $(SED_CMD) -i $(call _WEBSITE_PROMO_REGEX,latest-build,$(\
	    )$*) $(DOCS_DATA_DIR)/forge_promos.json; \
	fi; \
	cp -f $< $@; \
	$(SED_CMD) -i $(call _SRC_PACK_SEDJSON,time,'"$$date_time"') $@; \
	$(SED_CMD) -i $(call _DOCS_FBUILDS_LISTREGEX,tags,'"$$tags"') $@;
	@echo "Updating '$@'"
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

# sed_cmd _WEBSITE_PROMO_REGEX(name, version)
_WEBSITE_PROMO_REGEX = 's~^\( *"\)[^"]*\(" *:.*"$(1)"\)~\1$(2)\2~g;'

# version _WEBSITE_PROMO_PARSE(name)
_WEBSITE_PROMO_PARSE = 's~^ *"\([^"]*\)" *:.*"$(1)".*~\1~p;'

$(DOCS_DATA_DIR)/forge_promos.json: Makefile
	@echo "Updating 'used-for-develop' to '$(MF_VERSION_FULL)'"
	@$(SED_CMD) -i $(call _WEBSITE_PROMO_REGEX,used-for-develop,$(\
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
	       $(call _DOCS_FBUILDS_LISTPARSE,tags) $<`"; \
	tags="$$tags, \"$(TAG)\""; \
	$(SED_CMD) -i $(call _DOCS_FBUILDS_LISTREGEX,tags,'"$$tags"') $<;

.PHONY: website_mf_rmtag
website_mf_rmtag: $(DOCS_FORGEBUILDS_DIR)/$(MF_VERSION_FULL).json
	@if [ -z "$(TAG)" ]; then \
	  echo -e "\nERROR: Usage '$$> $(MAKE) $@ TAG=new_tag'\n" \
	       > /dev/stderr; \
	  exit 1; \
	fi
	@echo "Removing tag '$(TAG)' from Forge build '$(MF_VERSION_FULL)'"
	@tags="`$(SED_CMD) -n \
	       $(call _DOCS_FBUILDS_LISTPARSE,tags) $<`"; \
	tags="`echo $$tags | $(SED_CMD) 's~\"$(TAG)\"~~g; \
	       s~, *$$~~g; s~^, *~~g; s~, *,~,~g;'`"; \
	$(SED_CMD) -i $(call _DOCS_FBUILDS_LISTREGEX,tags,'"$$tags"') $<;

.PHONY: website_data
website_data: config_all $(DOCS_FORGEBUILDS_JSONS)

# End of Website stuff
# ********************************************************************
