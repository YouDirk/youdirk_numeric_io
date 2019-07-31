> This file is part of the `youdirk_numeric_io` Minecraft mod
> Copyright (C) 2019  Dirk "YouDirk" Lehmann
>
> This program is free software: you can redistribute it and/or modify
> it under the terms of the GNU General Public License as published by
> the Free Software Foundation, either version 3 of the License, or
> (at your option) any later version.
>
> This program is distributed in the hope that it will be useful,
> but WITHOUT ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> GNU General Public License for more details.
>
> You should have received a copy of the GNU General Public License
> along with this program.  If not, see <https://www.gnu.org/licenses/>.


Test Cases
==========

Here comes a list with weak spots in the code which could easy
unnoticed break it's hoped behavior during major changes, such like
porting to a new Minecraft version.  A description how to test if these
parts of the code is broken is following.

Feel free to test these cases and report bugs as described in

* [Bug Tracking section in **README.md**](README.md)


Cases
-----

1. **Vanilla Server - Creative Mode**  
   Youdirk Numeric IO Items should not be usable in Creative Mode from
   Creative Tab if we are connected to a Vanilla Server.  *In advanced
   these Items should not be accessible in all Game Modes if we are
   connected to a Vanilla Server, if you find a way you can report it
   :)*  
   **Behavior:** Should be grayed out in Creative Tab and not be
   dragable, craftable, enchantable, etc

2. **Block Break - Spawn Conditions**  
   If you break a Youdirk Numeric IO Block with and/or without a tool,
   it should spawn the corresponding Item to make it gatherable again.  
   **Behavior:** *<see description above>*
