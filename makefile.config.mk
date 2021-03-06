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


# ********************************************************************
# Configuration

# (optional) JAVA_HOME path, if not automatically detected
JDK_PATH =

# YouDirk Numeric I/O Version (without Minecraft Version)
#   Take a look to the conventions for versioning
#   <https://mcforge.readthedocs.io/en/latest/conventions/versioning/>
#
# Version format: MAJOR.API.MINOR.PATCH{-SUFFIX}
#        example: 1.1.0.25-beta
#
# MAJOR  - Breaking (changing/removing) gameplay mechanics changes
# API    - Breaking (changing/removing) Network/API changes
# MINOR  - Backward compatible (adding) Game/Network/API stuff
# PATCH  - Bug fixes only
# SUFFIX - (optional) -dev/-beta{X}/-rc{X}
VER_MAJOR  = 0
VER_API    = 1
VER_MINOR  = 0
VER_PATCH  = 0
VER_SUFFIX = -dev

# Dependency Version stuff
MC_VERSION = 1.13.2

# Official version from <https://files.minecraftforge.net/> or self
# deployed version from DOCS/MAVEN directory
MF_VERSION = 25.0.219

# Official Mappings are here <http://export.mcpbot.bspk.rs/>
MCP_MAPPING_CHANNEL = snapshot
MCP_MAPPING_VERSION = 20180921-1.13

# Mincraft Forge branch/commit from which will be bootstraped
MF_BRANCH = 1.13.x

# Mincraft Forge branch/commit from which will be bootstraped
# if current development is too heavily.
#
# Or a MincraftForge Fork with your own patches
#
MF_FALLBACK_BRANCH = upstream/for-1.13.x

# (optional) Inodes (files, directories, etc) relative to
# MINECRAFT_FORGE directory which will be using fallback versions
#
# MF_FALLBACK_INODES = \
#   src/fmllauncher \
#   src/main/java/net/minecraftforge/fml \
#   ...
#
MF_FALLBACK_INODES =

# Name of your fork
VENDOR = YouDirk Maintained

# Comma separated list
CREDITS = Dirk (YouDirk) Lehmann

# End of Configuration
# ********************************************************************
