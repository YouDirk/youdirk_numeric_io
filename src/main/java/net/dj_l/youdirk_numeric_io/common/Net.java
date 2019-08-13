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

// Non Minecraft/Forge
import java.util.regex.Pattern;


/**
 * Provides a network channel for task depended messages
 */
public abstract class Net
{
  /** Use this for SNPRINTF like stuff on network socket  */
  public static final int STRLEN = 256;

  private static final NetVersion _LOCAL_VERSION = new NetVersion();

  private static final ResourceLocation _CHANNEL_NAME
    = new ResourceLocation(Props.MODID, "main");

  private static final SimpleChannel _CHANNEL
    = NetworkRegistry.newSimpleChannel(Net._CHANNEL_NAME,
      Net::getVersionString, Net::_isClientAcceptVersion,
      Net::_isServerAcceptVersion);

  /* *************************************************************  */

  public static String getVersionString()
  {
    return Net._LOCAL_VERSION.toString();
  }

  @SuppressWarnings("unchecked")
  public static
  void registerMessage(NetMessage dummyInstance)
  {
    Class<? extends NetMessage> msgClass = dummyInstance.getClass();

    Net._CHANNEL.registerMessage(
      dummyInstance.getNetId(), msgClass, dummyInstance.getEncoder(),
      dummyInstance.getDecoder(), dummyInstance.getReceiver());
  }

  public static <T extends NetMessage<T>>
  void send(PacketDistributor.PacketTarget target, T msg)
  {
    Net._CHANNEL.send(target, msg);
  }

  public static <T extends NetMessage<T>> void sendToServer(T msg)
  {
    Net._CHANNEL.sendToServer(msg);
  }

  /* *************************************************************  */

  /**
   * The version format is: "MAJOR.API.MINOR"
   *
   * <p>The following rules decides, which side is accepting which
   * remote version.</p>
   *
   * <pre><code>
   * 1. If (Local.isClient && Remote.isVanilla): ACCEPT
   *    If (Local.isServer && Remote.isVanilla): DENY
   *
   *    Clients can connect to vanilla servers, but servers are not
   *    allowing vanilla clients
   *
   * 2. If (Remote.Version >= Local.Version):
   *      ACCEPT and let decide the remote host
   *
   *    So we make sure that the newer implementation decides if
   *    protocol is compatible.
   *
   * 3. If (Remote.MAJOR != Local.MAJOR || Remote.API != Local.API):
   *      DENY, cause of breaking changes
   *
   *    In opposite, if you make breaking changes in the protocol then
   *    increment the API Version
   *
   * 4. If (Client.MINOR >= Server.MINOR):
   *      ACCEPT, cause there are only new features on the client
   *    else:
   *      DENY, cause server has new features which are not supported
   *            by the client
   *
   * </code></pre>
   */
  private static final
  Pattern _VANILLASTRING_REGEX = Pattern.compile("^ALLOWVANILLA.*$");
  private static final
  Pattern _ABSENT_REGEX = Pattern.compile("^ABSENT.*$");

  private static boolean _isClientAcceptVersion(String serverVersionString)
  {
    // Forge self-test
    if (_ABSENT_REGEX.matcher(serverVersionString).matches())
      return false;

    // If (Local.isClient && Remote.isVanilla): ACCEPT
    if (_VANILLASTRING_REGEX.matcher(serverVersionString).matches())
      return true;

    NetVersion serverVersion;

    try {
      serverVersion = new NetVersion(serverVersionString);
    } catch (YoudirkNumericIOException e) {
      Log.ger.warn("Server version is junk: '{}'!", serverVersionString);
      return false;
    }

    // If (Remote.Version >= Local.Version): ACCEPT
    if (serverVersion.compareTo(Net._LOCAL_VERSION) >= 0)
      return true;

    // If (Remote.MAJOR != Local.MAJOR || Remote.API != Local.API): DENY
    if (serverVersion.isBreaking(Net._LOCAL_VERSION))
      return false;

    // If (Client.MINOR >= Server.MINOR): ACCEPT
    if (Net._LOCAL_VERSION.MINOR >= serverVersion.MINOR)
      return true;

    return false;
  }

  private static boolean _isServerAcceptVersion(String clientVersionString)
  {
    // Forge self-test
    if (_ABSENT_REGEX.matcher(clientVersionString).matches())
      return false;

    // If (Local.isServer && Remote.isVanilla): DENY
    if (_VANILLASTRING_REGEX.matcher(clientVersionString).matches())
      return false;

    NetVersion clientVersion;

    try {
      clientVersion = new NetVersion(clientVersionString);
    } catch (YoudirkNumericIOException e) {
      Log.ger.warn("Client version is junk: '{}'!", clientVersionString);
      return false;
    }

    // If (Remote.Version >= Local.Version): ACCEPT
    if (clientVersion.compareTo(Net._LOCAL_VERSION) >= 0)
      return true;

    // If (Remote.MAJOR != Local.MAJOR || Remote.API != Local.API): DENY
    if (clientVersion.isBreaking(Net._LOCAL_VERSION))
      return false;

    // If (Client.MINOR >= Server.MINOR): ACCEPT
    if (clientVersion.MINOR >= Net._LOCAL_VERSION.MINOR)
      return true;

    return false;
  }
}
