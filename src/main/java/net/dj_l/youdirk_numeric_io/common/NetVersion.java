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

// Non Minecraft/Forge
import java.util.regex.Pattern;
import java.util.regex.Matcher;


/**
 * Provides methods for outputing and comparing network protocol
 * compatibility.
 */
public class NetVersion implements Comparable<NetVersion>
{
  private final Pattern _VERSION_REGEX = Pattern.compile(
    "^([0-9]{1,4})\\.([0-9]{1,4})\\.([0-9]{1,4})$");

  public final int MAJOR, API, MINOR;

  public NetVersion()
  {
    this.MAJOR = Props.VERSION_MAJOR;
    this.API = Props.VERSION_API;
    this.MINOR = Props.VERSION_MINOR;
  }

  public NetVersion(int major, int api, int minor)
  {
    this.MAJOR = major;
    this.API = api;
    this.MINOR = minor;
  }

  public NetVersion(String versionString) throws YoudirkNumericIOException
  {
    final String ERR_STR
      = "'" + versionString + "' is not a network protocol version!";

    Matcher m = _VERSION_REGEX.matcher(versionString);

    if (!m.matches()) throw new YoudirkNumericIOException(ERR_STR);

    try {
      this.MAJOR = Math.abs(Integer.parseInt(m.group(1)));
      this.API = Math.abs(Integer.parseInt(m.group(2)));
      this.MINOR = Math.abs(Integer.parseInt(m.group(3)));
    } catch (Exception e) {
      throw new YoudirkNumericIOException(ERR_STR, e);
    }
  }

  @Override
  public String toString()
  {
    return String.format("%d.%d.%d", this.MAJOR, this.API, this.MINOR);
  }

  protected long toLong()
  {
    return this.MAJOR*((long)1E8) + this.API*((long)1E4) + this.MINOR;
  }

  /**
   * <code>a.compareTo(b) > 0</code> means <code>a >
   * b</code>.
   */
  @Override
  public int compareTo(NetVersion o)
  {
    /* Do not substract, it could overflow during cast from LONG to
     * INT!
     */

    long a = this.toLong();
    long b = o.toLong();

    if (a == b) return 0;

    return a > b? 1: -1;
  }

  public boolean equals(NetVersion o)
  {
    return this.toLong() == o.toLong();
  }

  public boolean isBreaking(NetVersion o)
  {
    return this.MAJOR != o.MAJOR || this.API != o.API;
  }
}
