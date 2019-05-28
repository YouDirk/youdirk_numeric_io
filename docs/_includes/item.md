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

{% assign promo = nil %}
{% for promo_vec in site.data.promos reversed %}
{%   if build.version == promo_vec[0] %}
{%     assign promo = promo_vec[1] %}
{%     break %}
{%   endif %}
{% endfor %}
{% if include.show_nopromo or promo %}
{% if promo
  %}<span class="mf_item_promo" style="background-color: {{
  promo.color }};">{{ promo.name
}}</span> <span class="item_downloadlink">{%
endif %}[YouDirk Numeric I/O version {{ include.build.version }}]({{
  site.numeric_io.github_maven_url }}/{{
  include.build.jar.maven-url
}})</span>  
<span class="mf_item_stats">{{
  include.build.time | date: "%a, %e. %b %Y %R %z"
}} for Minecraft {{
  include.build.mc_version
}} -- __tags:__ {%
  for tag in include.build.tags %} <span class="mf_item_tag">{{
    tag }}</span>{%
  endfor %}</span>  
<span class="mf_item_stats">File: **{{
  include.build.jar.name
}}**</span>
```
Patch Notes
***********
{% for line in include.build.patch_notes %}
{{   line | xml_escape }}{% endfor %}```
{% endif %}