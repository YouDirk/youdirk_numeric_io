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


Contributing
============

Here comes the answer to the question _"How can I contribute to the
YouDirk Numeric I/O Minecraft mod?"_ If you want to contribute some
tutorials or instructions how to use the *YouDirk Numeric I/O
Minecraft mod* then you can write it down in the

* [Wiki https://github.com/YouDirk/youdirk_numeric_io/wiki
  ](https://github.com/YouDirk/youdirk_numeric_io/wiki)

If you want to contribute some **code**, **assets** such like
*models*, *textures* or *sounds* then read this document below.

This file contains the following sections:

|         |                                            |
|-------: | -------------------------------------------|
|      I. | **Guidelines**                             |
|     II. | **Recommended toolchain**                  |
|    III. | **Recommended workflow using Git**         |
|         | _Setting up a local repository for commit_ |
|         | _Contributing session_                     |
|         | _Merging Upstream into Origin_             |

**********************************************************************

I. Guidelines
-------------

1. If it possible then prevent that lines of code are longer than **70
   characters per line**.

2. If you **add a new file** to the YouDirk Numeric I/O Minecraft mod
   **then add the following license** text if it is possible,
   depending on the file format  
```java
/* This file is part of the `youdirk_numeric_io` Minecraft mod
 * Copyright (C) <year>  <name of author>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
```
   Take a look into the [LICENSE](LICENSE) file for more details.

**********************************************************************

## Linux
Mod-Development on Linux is now officially supported. The most `make`
targets are working. Exceptions are the following targets
* ~~`mf_install_client`~~, ~~`install_client`~~ and
  ~~`run_productive_client`~~

But the **recommended** way to test your code works fine. Use the
targets
* `run_client` and `run_server`

The setup for productive use of dedicated server does also work on
Linux
* `mf_install_server`, `install_server`, `run_productive_server` and
  `run_productive_server_nogui`

It seems that there doesn't exist an official Minecraft Launcher for
Linux.  For that reason you must install the Forge-Jar and Mod-Jar
manually to your productive Minecraft installation.  Such as every
other user :P ...

tested on system:
* Debian 10.0 (Buster), Kernel `Linux 4.19.0-5-amd64`
* JDK: Oracle Java SE Development Kit `1.8.0_211` for `Linux amd64`
* necessary *GLX Info*
    ```make
    direct rendering: Yes
    glx vendor string: NVIDIA Corporation
    glx version string: 1.4
    OpenGL renderer string: GeForce GTX 850M/PCIe/SSE2
    OpenGL core profile version string: 4.6.0 NVIDIA 430.14
    OpenGL core profile shading language version string: 4.60 NVIDIA
    ```

## Default Windows 10
The current mostly used development environment is
* Windows 10 (x86_64)
* using `MSYS2` as POSIX compatible `bash` shell environment
* `GNU make` to define build rules. To install run command in MSYS2
  shell `$> pacman -S msys/make`
* all other dependencies will be checked automatically in
  `makefile.check.mk` and outputs an error with an instruction what
  and how to install

Until `CONTRIBUTING.md`
[#4](https://github.com/YouDirk/youdirk_numeric_io/issues/4) was not
fully written, here comes a short reference about the currently
implemented `make` `targets:`. You can run it using the command `$>
make <target>`

```make
# --- Necessary targets ---
all <default>: Runs CLASSES
classes: Compiles all Mod classes including Debug classes, nearly same as official Forge command `$> ./gradlew classes`
run_client: Runs a client in DebugMode.  Same as official Forge command `$> ./gradlew runClient`
run_client_player2: Runs another client in DebugMode instance for multiplayer tests
run_client_player3: Runs a third client in DebugMode instance for multiplayer tests
run_client_player4: Runs a fourth client in DebugMode instance for multiplayer tests
run_server: Runs a dedicated server in DebugMode.  Same as official Forge command `$> ./gradlew runServer`
run_server_nogui: Same as RUN_SERVER, but run in terminal/console mode instead of open a GUI

build: Same as official Forge command `$> ./gradlew build`
run_productive_client: (only Windows) Run MF_INSTALL_CLIENT, INSTALL_CLIENT and runs the official Minecraft Launcher, downloadable from https://www.minecraft.net/download/
run_productive_server: (also Linux) Run MF_INSTALL_SERVER, INSTALL_SERVER and runs the productive Dedicated modded Forge Server installed in `PREFIX=/c/installdir`
run_productive_server_nogui: (also Linux) Same as RUN_PRODUCTIVE_SERVER, but run in terminal/console mode instead of open a GUI
run_productive_server_vanilla: (also Linux) Run MF_INSTALL_SERVER, INSTALL_SERVER and runs the productive Dedicated Vanilla Server installed in `PREFIX=/c/installdir`
run_productive_server_vanilla_nogui: (also Linux) Same as RUN_PRODUCTIVE_SERVER_VANILLA, but run in terminal/console mode instead of open a GUI

publish: Runs BUILD, copy Mod-Jar to maven repository and add Version-Data to website
jdk_version: Output JDK version which will be used.  Useful if you have more than one installed on your system

# --- Removing temporary files ---
clean_run: Reset all Minecraft runtime-configuration which were set during RUN_CLIENT, RUN_SERVER
clean: Remove all temporay/cache files which were generated during work
clean_gradlecache: Clear the Gradle UserRepo cache.  Useful if it is broken and needs to re-accesstransformed.  If so, you get Missing-Symbol-Errors in injected files

# --- Documentation stuff ---
javadoc: Generate a Javadoc documentation for the Mod-API and open it in browser
mf_javadoc: Generate a Javadoc documentation for the Forge-API and open it in browser

clean_javadoc: Delete generated Mod-API documentation to enforce regeneration
mf_clean_javadoc: Delete generated Forge-API documentation to enforce regeneration

# --- Developing on Forge sources ---
mf_classes: Runs Java compiler and build all Forge classes
mf_publish: Build Forge Installer Jars, copy it to maven repository and add Version-Data to website

# --- Maintaining only ---
bootstrap: Runs FORGE followed by CONFIG_ALL
clean_all: Delete all files which are possible to re-generate. Also files which were commited to Git.  Useful for maintaining and upgrade to a new Minecraft-Version and/or Forge-Version

# --- Website stuff ---
website_addtag: Same as WEBSITE_ADDTAG_NODEP, but check if Mod was PUBLISH before
website_addtag_nodep: Add a Tag of the current Mod-Version on website
website_rmtag: Same as WEBSITE_RMTAG_NODEP, but check if Mod was PUBLISH before
website_rmtag_nodep: Remove a Tag of the current Mod-Version from website

website_mf_addtag: Add a Tag of the current Forge-Version on website
website_mf_rmtag: Remove a Tag of the current Forge-Version from website

# --- Others ---
install_client: (only Windows) Run BUILD, MF_INSTALL_CLIENT and install the Mod-Jar to the official Minecraft Launcher, downloadable from https://www.minecraft.net/download/
install_server: (also Linux) Run BUILD, MF_INSTALL_SERVER and install the Mod-Jar to the productive Dedicated Server installed in `PREFIX=/c/installdir`
mf_install_client: (only Windows) Compile Forge Installer Jar and install the Client part to official Minecraft Launcher, downloadable from https://www.minecraft.net/download/
mf_install_server: (also Linux) Compile Forge Installer Jar and install a productive Dedicated Server to `PREFIX=/c/installdir`
config_all: Generate all config files which are generally needed for the whole project. Normally it will called automatically
forge: clone/checkout Git submodule `forge`, the latest official Minecraft Forge source for branch defined in makefile.config.mk
website_forge: Same as MF_PUBLISH, but a copy of the Forge Jars must be already available in maven repository
clean_bootstrap: Delete all files which were generated via BOOTSTRAP
clean_forge: Delete all files which were generated via FORGE
mf_deinit: Deinit the Forge Git submodule `forge` which was generated via FORGE
website_mod: Same as PUBLISH, but a copy of the Mod-Jar must be already available in maven repository

# ****** Additional MAKE arguments ******

all classes run_client% run_server build:

      (optional) ARGS=<gradlew arguments>

  example $> make <target> ARGS=--stacktrace
  runs `./gradlew --stacktrace <target>`

website_mf_addtag website_mf_rmtag website_addtag% website_rmtag%:

      TAG=<the tag>

  example $> make <target> TAG=unstable

mf_install_server install_server run_productive_server%:

      PREFIX=<install dir>

  example1 $> make <target> PREFIX=1
  Installs to a default directory inside the project directory

  example2 $> make <target> PREFIX="/c/Progam Files/installdir"
  Installs to a `/c/Progam Files/installdir`
```

II. Recommended toolchain
-------------------------

*[... TODO]*

**********************************************************************

III. Recommended workflow using Git
-----------------------------------

### Setting up a local repository for commit

*[... TODO]*

----------------------------------------------------------------------

### Contributing session

*[... TODO]*

----------------------------------------------------------------------

### Merging Upstream into Origin

*[... TODO]*

**********************************************************************
