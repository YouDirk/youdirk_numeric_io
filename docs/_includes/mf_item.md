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

#
# Include variables: include.build, include.show_nopromo
#
{% endcomment %}

{% assign promo_nokey = "" | split: "," %}
{% for cur in site.data.forge_promos %}
{%   assign promo_nokey = promo_nokey | push: cur[1] %}
{%   assign promo_nokey.key = cur[0] %}
{% endfor %}
{{ promo_nokey }}
{% assign promo_sorted = promo_nokey | sort: "priority" %}
{{ promo_sorted }}
{% assign promo = nil %}
{% for promo_hash in promo_sorted reversed %}
{%   if build.mf_version == promo_hash.key %}
{%     assign promo = promo_hash %}
{%     break %}
{%   endif %}
{% endfor %}
{% if include.show_nopromo or promo %}
**{% if promo
  %}<span class="mf_item_promo" style="background-color: {{
  promo.color }};">{{ promo.name }}</span> {%
endif %}Minecraft Forge build version {{ include.build.mf_version }}**  
<span class="mf_item_stats">{{
  include.build.time | date: "%a, %e. %b %Y %R %z"
}} for Minecraft {{
  include.build.mc_version
}} -- __tags:__ {%
  for tag in include.build.tags %} <span class="mf_item_tag">{{
    tag }}</span>{%
  endfor %}</span>  
<span class="mf_item_link">[Installer ({{
  include.build.jar_installer.name
}})]({{
site.numeric_io.github_maven_url }}/{{
  include.build.jar_installer.maven-url
}}),
[Universal ({{ include.build.jar_universal.name }})]({{
site.numeric_io.github_maven_url }}/{{
  include.build.jar_universal.maven-url
}})</span>
{% endif %}