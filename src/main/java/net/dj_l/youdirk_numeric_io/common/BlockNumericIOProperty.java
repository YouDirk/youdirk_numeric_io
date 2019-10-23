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
import net.minecraft.state.IntegerProperty;

// Non Minecraft/Forge
import java.util.EnumSet;


/**
 * This class holds the borders and radix of the number-system and
 * represents the <code>number</code> property of the
 * <code>BlockState</code>.
 */
public class BlockNumericIOProperty extends IntegerProperty
{
  private final int RADIX;

  public BlockNumericIOProperty(int radix)
  {
    super("number", 0, radix-1);

    this.RADIX = radix;
  }

  public BlockNumericIOProperty.Result increment(int value)
  {
    int incr = value + 1;

    return new Result(incr >= this.RADIX, incr % this.RADIX);
  }

  /* *************************************************************  */

  /**
   * Represents the result of an linear arithmetic operation.
   */
  public static class Result {
    public final boolean CARRY;
    public final int VALUE;

    public Result(boolean carry, int value) {
      this.CARRY = carry;
      this.VALUE = value;
    }
  }

  /* *************************************************************  */
}
