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

---
{% include common.html %}

This is the official website of the **YouDirk Numeric I/O Minecraft
mod** `youdirk_numeric_io`.  It adds to the game

* **Blocks** which are **outputing decimal (and hexadecimal) numbers**
  to represent the connected binary encoded Redstone Wires

* **Blocks** which you can **input a number (by right clicking on
  it)**.  These will be encoded to binary and outputed to the
  connected Redstone Wires

* **Negative values** (*Two´s Complement encoding*) are supported

* **Multiplayer support** - also compatible with Minecraft vanilla
  servers
    - For admins - _but vanilla clients cannot connect to modded
      YouDirk Numeric I/O Minecraft servers_

* **Languages** {% include localization.md %}

For a detailed in-game usage take a look to our [**Wiki** at
github.com]({{site.numeric_io.github_url}}/{{
              site.numeric_io.wiki_rel_url }}).

## Downloads
------------

{% include section_download.md show_nopromo=false %}

### Download Minecraft Forge
----------------------------

{% include mf_section_download.md show_nopromo=false %}

## Install
----------

To install you need *[...] TODO*

Issues & Bug reports
--------------------

If you found a *bug* or if you like to provide a *feature-request*
then take a look to the

* [**Bug Tracking System** (github.com)
  ]({{site.numeric_io.github_url}}/{{ site.numeric_io.issues_rel_url }})

Contributing
------------

### Wiki

You can contribute some tutorials or instructions how to use the
*YouDirk Numeric I/O Minecraft mod* by writing it down to the

* [**Wiki** (github.com)
  ]({{site.numeric_io.github_url}}/{{ site.numeric_io.wiki_rel_url }})

### Translation / Assets / Hacking

If you want to **translate**, contribute some **code** or **assets**
such like *models*, *textures* or *sounds* then take a look to the
GitHub repository and read the

* [**Contribution Guidelines** (github.com)
  ]({{site.numeric_io.github_url}}/{{
      site.numeric_io.contribdoc_rel_url }})

### Donate and become a Patron

Make our society more funny with relaxed free time activities and
support small video game productions.  The whole YouDirk Numeric I/O
Minecraft mod is [Open Source/Free
Software](https://en.wikipedia.org/wiki/Free_software).  So it
supports liberty for software developers and make it possible to
everyone to understand it's software.  With your pledge you are not
only supporting this Minecraft project, you are not only supporting
video games - you are also supporting a free thinking and a free
acting society :)

* [![Patreon](assets/svg/patreon-plastic.svg
  )](https://www.patreon.com/YouDirk) at [patreon.com/YouDirk
  ](https://www.patreon.com/YouDirk)

Initial idea
------------

I want to build a [calculator in vanilla Minecraft
(twitch.tv/you_dirk)](https://www.twitch.tv/collections/jN0fzROVchV32A)
using Redstones and it's logic properties.  In conclusion it is an
8-bit ALU *(Arithmetic Logic Unit)* based on an *Intel 8085* ALU
circuit.  It should be possible to build it without using any mod.
But it's not easy to output the result of your calculation in-game and
there is no suitable way to input the operands into the calculator.
For that reason I decided to implement a mod to do that.

Well, so have fun with it :)
