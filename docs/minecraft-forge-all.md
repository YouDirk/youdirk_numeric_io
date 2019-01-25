---
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

permalink: /minecraft-forge-all/

---

Minecraft Forge development builds
----------------------------------

We are poviding some **unstable development** builds of Minecraft
Forge which you can download.  But we are highly recommend to download
the latest stable from the official Minecraft Forge website

* **[Download official STABLE from Minecraft Forge website
  ](https://files.minecraftforge.net/)**

<span class="more">[Back to Home](.)</span>

{% assign fb_sorted_hash = site.data.forge_builds | sort %}
{% for build_hash in fb_sorted_hash reversed %}
{% assign build = build_hash[1] %}
{% include mf_item.md build=build %}
{% endfor %}

<span class="more">[Back to Home](.)</span>