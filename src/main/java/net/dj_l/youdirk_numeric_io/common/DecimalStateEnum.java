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
 * This <code>enum</code> represents the <b>unsigned decimal</b>
 * number of a <code>Decimal{*}Block</code>
 */
public enum DecimalStateEnum
  implements INumericIOStateEnum<DecimalStateEnum>
{
  // First item is used as DEFAULT_STATE
  ZERO(0), ONE(1), TWO(2), THREE(3), FOUR(4), FIVE(5), SIX(6), SEVEN(7),
  EIGHT(8), NINE(9);

  private final int VALUE;
  private final String NAME;
  private final int RADIX = 10;

  private DecimalStateEnum(int value)
  {
    this.VALUE = value;
    this.NAME = Integer.toString(value, this.RADIX);
  }

  @Override
  public INumericIOStateEnum.Result<DecimalStateEnum> increment()
  {
    boolean lastLoop = false;
    for (DecimalStateEnum num: DecimalStateEnum.values()) {
      if (lastLoop) return new Result<DecimalStateEnum>(false, num);

      if (this.equals(num)) lastLoop = true;
    }

    return new Result<DecimalStateEnum>(true, ZERO);
  }

  @Override
  public String getName()
  {
    return this.NAME;
  }

  @Override
  public String toString()
  {
    return this.NAME;
  }
}
