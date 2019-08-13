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

Here comes a list with code weak spots which could break the expected
behavior unnoticed during major changes, such like porting the YouDirk
Numeric I/O mod to a new Minecraft version.  A description of how to
test these parts of the code is following.

Feel free to test these cases and report bugs as described in

* [**Issues & Bug reports** section (README.md)](README.md)


Cases
-----

1. **Vanilla Server - Creative Tab**  
   YouDirk Numeric I/O Items should not be usable in Creative Mode
   from Creative Tab if we are connected to a Vanilla Server.  _In
   advanced these Items should also not be accessible in all other
   Game Modes if we are connected to a Vanilla Server, if you find a
   way you can report it :)_  
   **Expected Behavior:** Should be grayed out in Creative Tab and not
   be dragable, craftable, enchantable, etc

2. **Breaking Blocks  - Spawning Conditions**  
   If you break a YouDirk Numeric I/O Block with or without any tool,
   it should spawn the corresponding Item to make it gatherable again.  
   **Expected Behavior:** Breaking a YouDirk Numeric I/O Block should
   always spawn the corresponding Item.

3. **Net Version compatibility**  
   Try out to connect different Client Versions to different Server
   Versions, also mixed with Vanilla Server/Clients.  A specification
   of which versions are compatible you can find in the comments of
   source file [`Net.java`](
   src/main/java/net/dj_l/youdirk_numeric_io/common/Net.java) and in
   the implementation of `Net::_isClientAcceptVersion()` and
   `Net::_isServerAcceptVersion()`.  
   **Expected Behavior:** Clients should only connect to servers of
   versions as described in source file [`Net.java`](
   src/main/java/net/dj_l/youdirk_numeric_io/common/Net.java).

4. **Faked NetMessages**  
   If you are a little bit a Hacker then you can try to
   fake/compromise the Net Packets of the YouDirk Numeric I/O mod
   specific NetChannel `youdirk_numeric_io:main`.  Take a look to
   classes which are inheriting from [`class NetMessage`](
   src/main/java/net/dj_l/youdirk_numeric_io/common/NetMessage.java).  
   **Expected Behavior:** It should be thrown a
   `NetPacketErrorException` and you get a warning in the log output,
   such like `IGNORING network packet!` and the `NetMessage` itself
   will be ignored.
