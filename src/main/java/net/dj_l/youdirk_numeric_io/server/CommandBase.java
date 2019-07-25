/* This file is part of the `youdirk_numeric_io` Minecraft mod
 * Copyright (C) 2019  Dirk "YouDirk" Lehmann
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


package net.dj_l.youdirk_numeric_io.server;
import net.dj_l.youdirk_numeric_io.common.*;
import net.dj_l.youdirk_numeric_io.*;

// Non Minecraft/Forge
import java.util.regex.Pattern;
import java.util.regex.Matcher;


/**
 * This class is a work-around for the poor Java Generics type
 * checking.  Use this type for <code>CommandRegistry</code> stuff.
 */
public abstract class CommandBase
  extends YoudirkNumericIORegistryEntry<CommandBase>
{
  private final Pattern _2UNDERLINE_REGEX = Pattern.compile("[-_]");

  private final String _REGISTRY_PATH;
  protected final String COMMAND_NAME;

  protected CommandBase(String commandName)
  {
    super(CommandBase.class);

    this.COMMAND_NAME = commandName;

    Matcher m = _2UNDERLINE_REGEX.matcher(commandName);
    this._REGISTRY_PATH = m.replaceAll("_");

    this.setRegistryName(this._REGISTRY_PATH);
  }
}
