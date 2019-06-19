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

// Non Minecraft/Forge
import org.apache.logging.log4j.LogManager;


public abstract class Logger
{
  private static final org.apache.logging.log4j.Logger _LOGGER
    = LogManager.getLogger(Props.MODID);

  public static void debug(Object message)
  {
    _LOGGER.debug(message);
  }

  public static void debug(Object message, Throwable t)
  {
    _LOGGER.debug(message, t);
  }

  public static void info(Object message)
  {
    _LOGGER.info(message);
  }

  public static void info(Object message, Throwable t)
  {
    _LOGGER.info(message, t);
  }

  public static void warn(Object message)
  {
    _LOGGER.warn(message);
  }

  public static void warn(Object message, Throwable t)
  {
    _LOGGER.warn(message, t);
  }

  public static void error(Object message)
  {
    _LOGGER.error(message);
  }

  public static void error(Object message, Throwable t)
  {
    _LOGGER.error(message, t);
  }

  public static void fatal(Object message)
  {
    _LOGGER.fatal(message);
  }

  public static void fatal(Object message, Throwable t)
  {
    _LOGGER.fatal(message, t);
  }
}
