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


/**
 * Provides methods for outputing and comparing network protocol
 * compatibility.
 */
public class NetVersion implements Comparable<NetVersion>
{
  public final int major, api, minor;

  public NetVersion()
  {
    this.major = Props.VERSION_MAJOR;
    this.api = Props.VERSION_API;
    this.minor = Props.VERSION_MINOR;
  }

  public NetVersion(int major, int api, int minor)
  {
    this.major = major;
    this.api = api;
    this.minor = minor;
  }

  @Override
  public String toString()
  {
    return String.format("%d.%d.%d", this.major, this.api, this.minor);
  }

  protected long toLong()
  {
    return this.major*((long)1E8) + this.api*((long)1E4) + this.minor;
  }

  /**
   * <code>a.compareTo(b) > 0</code> means <code>a >
   * b</code>.
   */
  @Override
  public int compareTo(NetVersion o)
  {
    // Do not substract, it could overflow during cast from LONG to
    // INT!

    long a = this.toLong();
    long b = o.toLong();

    if (a == b) return 0;

    return a > b? 1: -1;
  }

  public boolean equals(NetVersion o)
  {
    return this.toLong() == o.toLong();
  }
}
