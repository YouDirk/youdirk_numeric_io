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

XXX. Temporary Fast written stuff
---------------------------------
## Linux
Mod-Development on Linux is now officially supported. The most `make`
targets are working. Exceptions are the following targets
* `mf_install`, `install` and `run_productive`

It seems that there exist no official Minecraft Launcher for Linux.
For that you must install the Forge-Jar and Mod-Jar manually to your
productive installation.  Such as every other user :P ...

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
implemented (commit 4b8eeed29be9970cbf738774adf5690e4f50c48b) `make`
`targets:`. You can run it using the command `$> make <target>`

```make
all <default>: Runs Java compiler and build all Mod classes (same as CLASSES)
classes: Same as official Forge command `$> ./gradlew classes`
run_client: Same as official Forge command `$> ./gradlew runClient`
run_server: Same as official Forge command `$> ./gradlew runServer`
build: Same as official Forge command `$> ./gradlew build`
run_productive: Run MF_INSTALL, INSTALL and runs the official Minecraft Launcher, downloadable from https://www.minecraft.net/download/
javadoc: Generate a Javadoc documentation for the Mod-API and open it in browser
mf_javadoc: Generate a Javadoc documentation for the Forge-API and open it in browser

clean_run: Reset all Minecraft runtime-configuration which were set during RUN_CLIENT, RUN_SERVER
clean: Remove all temporay/cache files which were generated during work

jdk_version: Output JDK version which will be used. Useful if you have more than one installed on your system

bootstrap: Runs FORGE followed by CONFIG_ALL
mf_publish: Build Forge Installer Jars, copy it to maven repository and add Version-Data to website
publish: Runs BUILD, copy Mod-Jar to maven repository and add Version-Data to website
clean_all: Delete all files which are possible to re-generate. Also files which were commited to Git. Useful for maintaining and upgrade to a new Minecraft-Version and/or Forge-Version

website_addtag: Same as WEBSITE_ADDTAG_NODEP, but check if Mod was PUBLISH before
website_addtag_nodep: Add a Tag of the current Mod-Version on website
website_rmtag: Same as WEBSITE_RMTAG_NODEP, but check if Mod was PUBLISH before
website_rmtag_nodep: Remove a Tag of the current Mod-Version from website

website_mf_addtag: Add a Tag of the current Forge-Version on website
website_mf_rmtag: Remove a Tag of the current Forge-Version from website

config_all: Generate all config files which are generally needed for the whole project. Normally it will called automatically
forge: clone/checkout Git submodule `forge`, the latest official Minecraft Forge source for branch defined in makefile.config.mk
install: Run BUILD, MF_INSTALL and install the Mod-Jar to the official Minecraft Launcher, downloadable from https://www.minecraft.net/download/
website_forge: Same as MF_PUBLISH, but a copy of the Forge Jars must be already available in maven repository
clean_bootstrap: Delete all files which were generated via BOOTSTRAP
clean_forge: Delete all files which were generated via FORGE
mf_deinit: Deinit the Forge Git submodule `forge` which was generated via FORGE
mf_install: Compile Forge Installer Jar and install it to official Minecraft Launcher, downloadable from https://www.minecraft.net/download/
website_mod: Same as PUBLISH, but a copy of the Mod-Jar must be already available in maven repository
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
