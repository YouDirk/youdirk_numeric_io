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
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.javafmlmod.FMLJavaModLoadingContext;

// Event Bus
import net.minecraftforge.eventbus.api.IEventBus;
import net.minecraftforge.eventbus.api.SubscribeEvent;

// Events
import net.minecraftforge.event.RegistryEvent;
import net.minecraftforge.event.world.BlockEvent;

// API
import net.minecraftforge.api.distmarker.OnlyIn;
import net.minecraftforge.api.distmarker.Dist;

// Gameplay
import net.minecraftforge.common.MinecraftForge;
import net.minecraft.world.World;
import net.minecraft.block.Block;
import net.minecraft.util.math.BlockPos;

import net.minecraft.client.Minecraft;
import net.minecraft.init.SoundEvents;
import net.minecraft.util.SoundCategory;

// Non Minecraft/Forge
import java.util.stream.Collectors;


@Mod(Props.MODID)
public class YoudirkNumericIO
{
  private final net.dj_l.youdirk_numeric_io.common.Setup setupCommon;
  private final net.dj_l.youdirk_numeric_io.server.Setup setupServer;
  private final net.dj_l.youdirk_numeric_io.client.Setup setupClient;

  public YoudirkNumericIO() {
    IEventBus forgeEventBus = MinecraftForge.EVENT_BUS;
    IEventBus modEventBus
      = FMLJavaModLoadingContext.get().getModEventBus();

    this.setupCommon
      = new net.dj_l.youdirk_numeric_io.common.Setup(modEventBus);
    this.setupServer
      = new net.dj_l.youdirk_numeric_io.server.Setup(forgeEventBus);
    this.setupClient
      = new net.dj_l.youdirk_numeric_io.client.Setup(modEventBus);

    forgeEventBus.register(this);
  }

  // EntityPlayerSP is not part of DEDICATED_SERVER
  @OnlyIn(Dist.CLIENT)
  private void _c_onBlockBreak(World world, BlockPos pos)
  {
    world.playSound(Minecraft.getInstance().player, pos,
      SoundEvents.ENTITY_WITCH_DEATH, SoundCategory.BLOCKS, 1.0f, 1.0f);
  }

  // Test event, on destroying a Block
  @SubscribeEvent
  public void onBlockBreak(BlockEvent.BreakEvent event)
  {
    World world = event.getWorld().getWorld();

    if (world.isRemote()) {
      this._c_onBlockBreak(world, event.getPos());

      Log.ger.debug("Client Destroyed Block {}",
                    event.getState().getBlock().getRegistryName());
    } else {
      Log.ger.debug("Server Destroyed Block {}",
                    event.getState().getBlock().getRegistryName());
    }
  }

  // You can use EventBusSubscriber to automatically subscribe events on the contained class (this is subscribing to the MOD
  // Event bus for receiving Registry Events)
  @Mod.EventBusSubscriber(bus=Mod.EventBusSubscriber.Bus.MOD)
  public static class RegistryEvents {
    @SubscribeEvent
    public static void onBlocksRegistry(final RegistryEvent.Register<Block> blockRegistryEvent) {
      // register a new block here
      Log.ger.info("HELLO from Register Block");
    }
  }

}
