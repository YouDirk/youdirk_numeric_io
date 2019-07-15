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
# Include variables:
#
{% endcomment %}


{%- for lang in site.data.localization.langs -%}
{%-   assign key = lang[0] -%}
{%-   assign val = lang[1] -%}
{%-   if key contains "__" -%}
{%-     continue -%}
{%-   endif -%}
{%-   if val.generated -%}
        <span class="lang_generated" title="Generated from {{ val.name
         }}">{{ key }}</span>
{%-   else -%}
        <span class="lang_notgenerated" title="Translated by human">{{
         val.name }}</span>
{%-   endif -%}
{%-   unless forloop.last
        -%}, {%
      endunless %}
{%- endfor -%}
