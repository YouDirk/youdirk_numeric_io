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
 * This <code>interface</code> declares methods which are possible to
 * call for every number-system, such like <code>increment()</code>.
 */
public interface INumericIOStateEnum
  <E extends Enum<E> & INumericIOStateEnum> extends IStringSerializable
{
  /**
   * Returns a new <code>T</code> which increment <code>this</code> by
   * one.  The <code>Result.CARRY == true</code> if the incrementation
   * overflows.
   */
  public Result<E> increment();

  /* *************************************************************  */

  /**
   * Represents the result of an linear arithmetic operation.
   */
  public class Result<V> {
    public final boolean CARRY;
    public final V VALUE;

    public Result(boolean carry, V value) {
      this.CARRY = carry;
      this.VALUE = value;
    }
  }

  /* *************************************************************  */
}
