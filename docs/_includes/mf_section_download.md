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
# Include variables: include.show_nopromo
#
{% endcomment %}


We are poviding some **unstable development** builds of Minecraft
Forge which you can download.  But we are highly recommend to download
the latest stable from the official Minecraft Forge website

* **[Download official STABLE from Minecraft Forge website
  ](https://files.minecraftforge.net/)**

{% if include.show_nopromo %}
<span class="more">[< back to Home >](.)</span>
{% endif %}
{% assign mcversions_sorted = site.data.forge_builds | sort %}
{% if include.show_nopromo %}
{%   assign loop_count = 999999 %}
{% else %}
{%   assign loop_count = 2 %}
{% endif %}
{% for cur_mcversion in mcversions_sorted reversed limit:loop_count %}
#### for Minecraft {{ cur_mcversion[0] | replace: "-", "." }}
{%   assign fb_nokey = "" | split: "," %}
{%   for cur in cur_mcversion[1] %}
{%     assign fb_nokey = fb_nokey | push: cur[1] %}
{%   endfor %}
{%   assign fb_sorted = fb_nokey | sort: "time" %}
{%   for build in fb_sorted reversed %}
{%     include mf_item.md build=build show_nopromo=include.show_nopromo
                          old_stable=forloop.first %}
{%   endfor %}
{% endfor %}
{% if include.show_nopromo %}
<span class="more">[< back to Home >](.)</span>
{% else %}
<span class="more">
[< show all Minecraft Forge builds >](minecraft-forge)</span>
{% endif %}