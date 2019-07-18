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


package net.dj_l.youdirk_numeric_io.common;
import net.dj_l.youdirk_numeric_io.*;

// Gameplay
import net.minecraft.util.IStringSerializable;


/**
 * This <code>enum</code> represents the <b>power state</b> of every
 * <code>BlockNumericIO</code> block
 */
public enum BlockNumericIOPowerEnum implements IStringSerializable
{
  ON(true, "on"), OFF(false, "off");

  private final boolean is_powered;
  private final String name;

  private BlockNumericIOPowerEnum(boolean is_powered, String name)
  {
    this.is_powered = is_powered;
    this.name = name;
  }

  @Override
  public String getName()
  {
    return this.name;
  }

  @Override
  public String toString()
  {
    return this.name;
  }
}
