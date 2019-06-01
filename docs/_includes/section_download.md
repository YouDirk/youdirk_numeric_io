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

You can download the current *YouDirk Numeric I/O Minecraft mod*
`youdirk_numeric_io` versions here

{% if include.show_nopromo %}
<span class="more">[< back to Home >](.)</span>
{% endif %}
{% assign mcversions_sorted = site.data.builds | sort %}
{% for cur_mcversion in mcversions_sorted reversed %}
#### for Minecraft {{ cur_mcversion[0] | replace: "-", "." }}
{%   assign build_nokey = "" | split: "," %}
{%   for cur in cur_mcversion[1] %}
{%     assign build_nokey = build_nokey | push: cur[1] %}
{%   endfor %}
{%   assign build_sorted = build_nokey | sort: "time" %}
{%   for build in build_sorted reversed %}
{%     include item.md build=build show_nopromo=include.show_nopromo
                       old_stable=forloop.first %}
{%   endfor %}
{%   unless include.show_nopromo %}
{%     break %}
{%   endunless %}
{% endfor %}
{% if include.show_nopromo %}
<span class="more">[< back to Home >](.)</span>
{% else %}
<span class="more">
[< show all Downloads >]({{ downloads_rel_url }})</span>
{% endif %}