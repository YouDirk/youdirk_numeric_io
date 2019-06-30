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


public class NetMessageRegistry
{
  private final RegItem[] CLASSES =
  {
   new RegItem(1, NetMessageTestSound.class),
  };

  /* *************************************************************  */

  public static final NetMessageRegistry get()
  {
    return NetMessageRegistry.INSTANCE;
  }

  public void registerAllMessages()
  {
    for (RegItem m: this.CLASSES)
      Net.registerMessage(m.netIndex, m.msgClass);
  }

  /* *************************************************************  */

  private class RegItem {
    int netIndex;
    Class<? extends NetMessage> msgClass;

    RegItem(int netIndex, Class<? extends NetMessage> msgClass) {
      this.netIndex = netIndex;
      this.msgClass = msgClass;
    }
  }

  private static final NetMessageRegistry INSTANCE
    = new NetMessageRegistry();
}
