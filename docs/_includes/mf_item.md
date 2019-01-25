{% comment %}
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
{% endcomment %}

**Minecraft Forge build version {{ include.build.mf_version }}**  
_<span class="mf_item_stats">{{
  include.build.time | date: "%a, %e. %b %Y %R %Z"
}} for Minecraft {{
  include.build.mc_version
}} -- __tags:__ {%
  for tag in include.build.tags %} <span class="mf_item_tag">{{
    tag }}</span>{%
  endfor %}.</span>_  
[Installer ({{ include.build.jar_installer.name }})]({{
site.numeric_io.github_maven_url }}/{{
  include.build.jar_installer.maven-url
}}),
[Universal ({{ include.build.jar_universal.name }})]({{
site.numeric_io.github_maven_url }}/{{
  include.build.jar_universal.maven-url
}})
