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
# Regex Callables

# sed_cmd _REGEX_FILENAME_RET
_REGEX_FILENAME_RET = 's~^.*/\([^/]\+\)~\1~;'

# sed_cmd _REGEX_DIRNAME_RET
_REGEX_DIRNAME_RET = 's~^\(.*\)/[^/]\+~\1~;'


# sed_cmd _REGEX_GRADLE_REPL(key, value)
_REGEX_GRADLE_REPL = 's~^\([ \t]*$(1) *= *['\''"]\)[^'\''"]*~\1$(2)~g;'

# sed_cmd _REGEX_GRADLEVAR_REPL(key, value)
_REGEX_GRADLEVAR_REPL = 's~@$(1)@~$(2)~g;'

# sed_cmd _REGEX_GRADLEMANIFEST_REPL(key, value)
_REGEX_GRADLEMANIFEST_REPL = 's~\("$(1)" *:\)[^],]*~\1 "$(2)"~g;'


# sed_cmd _REGEX_PACKJSON_REPL(key, value)
_REGEX_PACKJSON_REPL = 's~^\([ \t]*"$(1)" *: *"\)[^"]*~\1$(2)~g;'

# sed_cmd _REGEX_MODS_REPL(key, value)
_REGEX_MODS_REPL = 's~^\([ \t]*$(1) *= *"\)[^"]*~\1$(2)~g;'

# sed_cmd _REGEX_MODS_GROUPREPL(file, group, key, value)
_REGEX_MODS_GROUPREPL = $(SED_CMD) -i \
  ':a;N;$$!ba; s~\(\n *\[\[$(2)\]\][^\n]*\n[^[]*$(3) *= *"\)[^"]*~\1$(4)~g;'\
  $(1)


# sed_cmd _REGEX_FBUILDSJSON_RET(key)
_REGEX_FBUILDSJSON_RET = 's~^[ \t]*"$(1)" *: *"\([^"]*\).*~\1~p;'

# sed_cmd _REGEX_FBUILDSJSONLIST_REPL(key, value)
_REGEX_FBUILDSJSONLIST_REPL = 's~^\([ \t]*"$(1)" *: *\[\)[^]]*~\1$(2)~g;'
# comma_list _REGEX_FBUILDSJSONLIST_RET(key)
_REGEX_FBUILDSJSONLIST_RET = 's~^[ \t]*"$(1)" *: *\[\([^]]*\).*~\1~p;'
# comma_list _REGEX_FBUILDSJSONLIST_RMCOMMA()
_REGEX_FBUILDSJSONLIST_RMCOMMA = 's~, *$$~~g; s~^, *~~g; s~, *,~,~g;'

# sh_cmd _SED_FBUILDSJSON_GROUPREPL(file, group, key, value)
_SED_FBUILDSJSON_GROUPREPL = $(SED_CMD) -i ':a;N;$$!ba; '$(\
  )'s~\(\n *"$(2)" *: *{ *\n[^}]*"$(3)" *: *"\)[^"]*~\1$(4)~g;' $(1)


# sed_cmd _REGEX_PROMO_REPL(name, version)
_REGEX_PROMO_REPL = 's~^\( *"\)[^"]*\(" *:.*"$(1)"\)~\1$(2)\2~g;'

# version _REGEX_PROMO_RET(name)
_REGEX_PROMO_RET = 's~^ *"\([^"]*\)" *:.*"$(1)".*~\1~p;'


# sed_cmd _REGEX_POMXML_REPL(intdent_no, key, value)
_REGEX_POMXML_REPL \
  = 's~^\( \{$(1)\}< *$(2) *>\)[^<]*\(< */ *$(2) *>\)'$(\
    )'~\1$(3)\2~g;'

# sed_cmd _REGEX_POMXML_EXIST(key, value)
_REGEX_POMXML_EXIST = 's~^ *< *$(1) *>$(2)< */ *$(1) *>.*~found~p;'

# sed_cmd _REGEX_POMXML_ADDVERSION(version)
_REGEX_POMXML_ADDVERSION = 's~^\( *\)\(< */ *versions *>.*\)'$(\
  )'~\1  <version>$(1)</version>\n\1\2~g;'


# sed_cmd _REGEX_WEBCONFIG_RET(name)
_REGEX_WEBCONFIG_RET = 's~^ *$(1) *: *\(.*\)~\1~p;'

# sed_cmd _REGEX_WEBCONFIG_REPL(name, value)
_REGEX_WEBCONFIG_REPL = 's~^\( *$(1) *: *\).*~\1$(2)~g;'

# End of Regex Callables
# ********************************************************************
