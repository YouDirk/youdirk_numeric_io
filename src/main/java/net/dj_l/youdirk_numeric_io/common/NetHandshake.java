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

// Forge Mod Loader
import net.minecraftforge.fml.common.Mod;

// Network
import net.minecraft.network.PacketBuffer;
import net.minecraftforge.fml.network.PacketDistributor;

// Event Bus
import net.minecraftforge.eventbus.api.SubscribeEvent;

// Events
import net.minecraftforge.event.RegistryEvent;

// Non Minecraft/Forge
import java.util.List;
import org.apache.commons.lang3.tuple.Pair;
import java.util.Arrays;


/**
 * Handshake protocol for our YouDirk Numeric I/O network channel.
 */
@Mod.EventBusSubscriber(bus=Mod.EventBusSubscriber.Bus.MOD)
public class NetHandshake extends NetMessage<NetHandshake>
{
  @SubscribeEvent
  public static void
  onRegister(final RegistryEvent.Register<NetMessageBase> event)
  {
    event.getRegistry().register(new NetHandshake());
  }
  private static final String _REGISTRY_PATH = "net_handshake";

  /**
   * A default constructor without any parameter must be implemented
   * to instanciate dummy objects.  It can be empty, but
   * <code>super(String registryPath)</code> must be called.
   */
  public NetHandshake()
  {
    super(NetHandshake._REGISTRY_PATH);
  }
  public NetHandshake(int loginIndex)
  {
    super(NetHandshake._REGISTRY_PATH);

    this._loginIndex = loginIndex;
  }

  /* *****************************************************************
   * Handshake specific stuff
   */

  private int _loginIndex = 0;

  public void setLoginIndex(int index)
  {
    Log.ger.debug("setLoginIndex(" +index+ ") " + this);

    this._loginIndex = index;
  }

  public int getLoginIndex()
  {
    Log.ger.debug("getLoginIndex " + this);

    return this._loginIndex;
  }

  public static
  List<Pair<String,NetHandshake>> buildLoginPacketList(boolean isLocal)
  {
    /*
    return Arrays.asList(
      Pair.of("NetHandshake(0)", new NetHandshake(0)),
      Pair.of("NetHandshake(1)", new NetHandshake(1)));
    */
    return Arrays.asList();
  }

  /* *****************************************************************
   * NetMessage overridings
   */

  @Override
  protected void encode(PacketBuffer buf)
  {
    buf.writeInt(this._loginIndex);
  }

  @Override
  protected NetHandshake decode(PacketBuffer buf)
  {
    // THIS is a dummy instance!

    return new NetHandshake(
      buf.readInt());
  }

  @Override
  protected void validateDecoded() throws NetPacketErrorException
  {
  }

  @Override
  protected void onReceiveServer() throws NetPacketErrorException
  {
    Log.ger.debug("onReceiveServer " + this);
  }

  @Override
  protected void onReceiveClient() throws NetPacketErrorException
  {
    Log.ger.debug("onReceiveClient " + this);

    Net.replySelf(this);
  }

  /* *****************************************************************
   * Optional overridings
   */

  @Override
  public String toString()
  {
    return "HANDSHAKE(" +this._loginIndex+ ") " +super.toString();
  }
}
