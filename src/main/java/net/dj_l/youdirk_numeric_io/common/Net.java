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

// Network
import net.minecraftforge.fml.network.simple.SimpleChannel;
import net.minecraftforge.fml.network.NetworkRegistry;
import net.minecraftforge.fml.network.PacketDistributor;

// Gameplay
import net.minecraft.util.ResourceLocation;


/**
 * Provides a network channel for task depended messages
 */
public abstract class Net
{
  /** Use this for SNPRINTF like stuff on network socket  */
  public static final int STRLEN = 256;

  private static final NetVersion localVersion = new NetVersion();

  private static final ResourceLocation CHANNEL_NAME
    = new ResourceLocation(Props.MODID, "main");

  private static final SimpleChannel CHANNEL
    = NetworkRegistry.newSimpleChannel(Net.CHANNEL_NAME,
      Net::getVersionString, Net::isClientAcceptVersion,
      Net::isServerAcceptVersion);

  /* *************************************************************  */

  public static String getVersionString()
  {
    return Net.localVersion.toString();
  }

  @SuppressWarnings("unchecked")
  public static
  void registerMessage(int netIndex, Class<? extends NetMessage> msgClass)
  {
    NetMessage inst;

    try {
      inst = msgClass.newInstance();
    } catch (Exception e) {
      throw new YoudirkNumericIOException(
        "Could not instanciate a Dummy NetMessage for registering"
        + " purposes!", e);
    }

    Net.CHANNEL.registerMessage(netIndex, msgClass, inst.getEncoder(),
                                inst.getDecoder(), inst.getReceiver());
  }

  public static <T extends NetMessage<T>>
  void send(PacketDistributor.PacketTarget target, T msg)
  {
    Net.CHANNEL.send(target, msg);
  }

  /* *************************************************************  */

  /**
   * The version format is: "MAJOR.API.MINOR"
   *
   * <p>The following rules decides, which side is accepting which
   * remote version.</p>
   *
   * <pre><code>
   * 1. If (Remote.Version >= Local.Version):
   *      ACCEPT and let decide the remote host
   *
   *    So we make sure that the newer implementation decides if
   *    protocol is compatible.
   *
   * 2. If (Remote.MAJOR != Local.MAJOR || Remote.API != Local.API):
   *      DENY, cause of breaking changes
   *
   *    In opposite, if you make breaking changes in the protocol then
   *    increment the API Version
   *
   * 3. If (Client.MINOR >= Server.MINOR):
   *      ACCEPT, cause there are only new features on the client
   *    else:
   *      DENY, cause server has new features which are not supported
   *            by the client
   *
   * </code></pre>
   */

  private static boolean isClientAcceptVersion(String serverVersionString)
  {
    NetVersion serverVersion;

    try {
      serverVersion = new NetVersion(serverVersionString);
    } catch (YoudirkNumericIOException e) {
      return false;
    }

    // If (Remote.Version >= Local.Version): ACCEPT
    if (serverVersion.compareTo(Net.localVersion) >= 0)
      return true;

    // If (Remote.MAJOR != Local.MAJOR || Remote.API != Local.API): DENY
    if (serverVersion.isBreaking(Net.localVersion))
      return false;

    //If (Client.MINOR >= Server.MINOR): ACCEPT
    if (Net.localVersion.MINOR >= serverVersion.MINOR)
      return true;

    return false;
  }

  private static boolean isServerAcceptVersion(String clientVersionString)
  {
    NetVersion clientVersion;

    try {
      clientVersion = new NetVersion(clientVersionString);
    } catch (YoudirkNumericIOException e) {
      return false;
    }

    // If (Remote.Version >= Local.Version): ACCEPT
    if (clientVersion.compareTo(Net.localVersion) >= 0)
      return true;

    // If (Remote.MAJOR != Local.MAJOR || Remote.API != Local.API): DENY
    if (clientVersion.isBreaking(Net.localVersion))
      return false;

    //If (Client.MINOR >= Server.MINOR): ACCEPT
    if (clientVersion.MINOR >= Net.localVersion.MINOR)
      return true;

    return getVersionString().equals(clientVersionString);
  }
}
