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


/**
 * Fallback solution to check if the server connected to is a modded
 * or vanilla server.
 */
@Mod.EventBusSubscriber(bus=Mod.EventBusSubscriber.Bus.MOD)
public class VanillaCheckNetMessage
  extends NetMessage<VanillaCheckNetMessage>
{
  @SubscribeEvent
  public static void
  onRegister(final RegistryEvent.Register<NetMessageBase> event)
  {
    event.getRegistry().register(new VanillaCheckNetMessage());
  }
  private static final String _REGISTRY_PATH = "vanilla_check_message";

  /**
   * If we are initial sending this message from client side, make
   * sure that we assuming that we don´t get a response and the server
   * is vanilla.
   */
  public VanillaCheckNetMessage()
  {
    super(VanillaCheckNetMessage._REGISTRY_PATH);
  }


  @Override
  protected void encode(PacketBuffer buf) {}

  @Override
  protected VanillaCheckNetMessage decode(PacketBuffer buf)
  {
    // THIS is a dummy instance!

    return new VanillaCheckNetMessage();
  }

  @Override
  protected void validateDecoded() throws NetPacketErrorException {}

  @Override
  protected void onReceiveServer() throws NetPacketErrorException
  {
    /* If we are here then the server is modded, so we answer back to
     * requesting client.
     */
    Net.send(PacketDistributor.PLAYER.with(() -> this.sender),
             new VanillaCheckNetMessage());
  }

  @Override
  protected void onReceiveClient() throws NetPacketErrorException
  {
    /* If we are here then the modded server has sent to us this
     * NetMessage and we are sure that the it is not a vanilla server.
     */
    ItemBlockNumericIORegistry.get().setClientConnectedVanilla(false);
  }
}
