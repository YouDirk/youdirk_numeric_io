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
import net.minecraft.state.EnumProperty;
import net.minecraft.util.IStringSerializable;

// Non Minecraft/Forge
import java.util.EnumSet;


/**
 * This class holds our <code>INumericIOStateEnum</code> enums and
 * represents the state of the <code>BlockState</code>.
 */
public class BlockNumericIOProperty
  <E extends Enum<E> & INumericIOStateEnum> extends EnumProperty<E>
{
  public BlockNumericIOProperty(Class<E> numericEnumClass)
  {
    super("number", numericEnumClass,  EnumSet.allOf(numericEnumClass));
  }
}
