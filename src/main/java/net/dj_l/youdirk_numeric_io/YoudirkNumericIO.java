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


package net.dj_l.youdirk_numeric_io;
import net.dj_l.youdirk_numeric_io.common.*;

// Forge Mod Loader
import net.minecraftforge.common.MinecraftForge;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.javafmlmod.FMLJavaModLoadingContext;

// Events
import net.minecraftforge.event.RegistryEvent;
import net.minecraftforge.event.world.BlockEvent;


/**
 * The beginning of all =D
 */
@Mod(Props.MODID)
public class YoudirkNumericIO
{
  private final net.dj_l.youdirk_numeric_io.common.Setup setupCommon;
  private final net.dj_l.youdirk_numeric_io.server.Setup setupServer;
  private final net.dj_l.youdirk_numeric_io.client.Setup setupClient;

  public YoudirkNumericIO()
  {
    YoudirkNumericIOEvent.init(
      MinecraftForge.EVENT_BUS,
      FMLJavaModLoadingContext.get().getModEventBus());

    this.setupCommon
      = new net.dj_l.youdirk_numeric_io.common.Setup(
            YoudirkNumericIOEvent.MOD_BUS);
    this.setupServer
      = new net.dj_l.youdirk_numeric_io.server.Setup(
            YoudirkNumericIOEvent.FORGE_BUS);
    this.setupClient
      = new net.dj_l.youdirk_numeric_io.client.Setup(
            YoudirkNumericIOEvent.MOD_BUS);
  }

  // You can use EventBusSubscriber to automatically subscribe events on the contained class (this is subscribing to the MOD
  // Event bus for receiving Registry Events)

  /*
  @Mod.EventBusSubscriber(bus=Mod.EventBusSubscriber.Bus.MOD)
  public static class RegistryEvents
  {
    @SubscribeEvent
    public static void onBlocksRegistry(final RegistryEvent.Register<Block> blockRegistryEvent)
    {
      // register a new block here
      Log.ger.debug("HELLO from Register Block");
    }
  }
  */
}
