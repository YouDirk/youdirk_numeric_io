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

// Network
import net.minecraftforge.fml.network.simple.SimpleChannel;
import net.minecraftforge.fml.network.NetworkRegistry;

// Gameplay
import net.minecraft.util.ResourceLocation;


/**
 * Provides a network channel for task depended messages
 */
public abstract class Net
{
  private static final String PROTOCOL_VERSION = "1";

  private static final ResourceLocation CHANNEL_NAME
    = new ResourceLocation(Props.MODID, "main");

  private static final SimpleChannel CHANNEL
    = NetworkRegistry.newSimpleChannel(Net.CHANNEL_NAME,
      Net::getProtocolVersion, Net::isClientAcceptVersion,
      Net::isServerAcceptVersion);

  /* *************************************************************  */

  public static final String getProtocolVersion()
  {
    return Net.PROTOCOL_VERSION;
  }

  public static final SimpleChannel get()
  {
    return Net.CHANNEL;
  }

  public static void registerMessage(int index,
                                     Class<? extends NetMessage> msgClass)
  {
    NetMessage inst;

    try {
      inst = msgClass.newInstance();
    } catch (Exception e) {
      throw new YoudirkNumericIOException(
        "Could not instanciate a Dummy NetMessage for registering"
        + " purposes!", e);
    }

    Net.CHANNEL.registerMessage(index, msgClass, inst.getEncoder(),
                                inst.getDecoder(), inst.getReceiver());
  }

  /* *************************************************************  */

  private static boolean isClientAcceptVersion(String serverVersion)
  {
    return Net.PROTOCOL_VERSION.equals(serverVersion);
  }

  private static boolean isServerAcceptVersion(String clientVersion)
  {
    return Net.PROTOCOL_VERSION.equals(clientVersion);
  }
}
