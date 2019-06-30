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
 * A place where all sub-classes of <code>NetMessage</code> are
 * collected for registering these during <code>Setup</code>.
 * Currently there is no way to collect them automatically, so add
 * them manually here if you implement a <code>NetMessage</code>.
 *
 * <p>Do not change the <code>netIndex</code> for existing items, it
 * will break the network protocol.</p>
 *
 * <pre><code>
 * private final RegItem[] CLASSES =
 * {
 *   new RegItem(1, MyMsg1NetMessage.class),
 *   new RegItem(2, AnotherHereNetMessage.class),
 *   new RegItem(4, AndSoOnNetMessage.class),
 *   ...
 * };
 * </code></pre>
 */
public class NetMessageRegistry
{
  private final RegItem[] CLASSES =
  {
   new RegItem(1, TestSoundNetMessage.class),
  };

  /* *************************************************************  */

  public static NetMessageRegistry get()
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
