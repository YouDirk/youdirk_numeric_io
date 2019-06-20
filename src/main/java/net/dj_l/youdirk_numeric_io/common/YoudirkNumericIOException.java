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

// Forge Mod Loader
import net.minecraftforge.fml.common.LoaderExceptionModCrash;


/**
 * Will be thrown if something goes wrong.
 */
public class YoudirkNumericIOException extends LoaderExceptionModCrash
{
  public YoudirkNumericIOException(String message)
  {
    super(message, null);
  }

  public YoudirkNumericIOException(String message, Throwable cause)
  {
    super(message, cause);
  }
}
