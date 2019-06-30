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
# Runtime Config stuff

.PHONY: _run_server_deps
_run_server_deps: $(RUN_DIR)/eula.txt $(RUN_DIR)/server.properties

%/eula.txt: $(RUN_TEMPL_DIR)/eula.txt
	@echo "Agreeing EULA '$@'" \
	  && mkdir -p "$*" && cp -f "$<" "$@"

%/server.properties: $(RUN_TEMPL_DIR)/server.properties
	@echo "Generating '$@'" \
	  && mkdir -p "$*" && cp -f "$<" "$@"


.PHONY: _run_productive_server_deps
_run_productive_server_deps: \
  $(call _INSTALL_SERVERDIR_ESC_CMD,$(PREFIX))/eula.txt


.PHONY: _run_client_deps
_run_client_deps: $(RUN_DIR)/servers.dat

%/servers.dat: $(RUN_TEMPL_DIR)/servers.dat
	@echo "Generating '$@'" \
	  && mkdir -p "$*" && cp -f "$<" "$@"

# --- Others ---

# Removes circular dependency warning
$(RUN_TEMPL_DIR)/eula.txt $(RUN_TEMPL_DIR)/server.properties \
  $(RUN_TEMPL_DIR)/servers.dat:
	$(error $(ERRB) '$@' is part of the sources!)

# End of Runtime Config stuff
# ********************************************************************
