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
import net.minecraftforge.fml.InterModComms;

// Event Bus
import net.minecraftforge.eventbus.api.IEventBus;
import net.minecraftforge.eventbus.api.SubscribeEvent;

// Events
import net.minecraftforge.fml.event.lifecycle.FMLCommonSetupEvent;
import net.minecraftforge.fml.event.lifecycle.FMLClientSetupEvent;
import net.minecraftforge.fml.event.lifecycle.InterModEnqueueEvent;
import net.minecraftforge.fml.event.lifecycle.InterModProcessEvent;
import net.minecraftforge.fml.event.server.FMLServerStartingEvent;
import net.minecraftforge.event.RegistryEvent;
import net.minecraftforge.event.world.BlockEvent;

// Gameplay
import net.minecraftforge.common.MinecraftForge;
import net.minecraft.init.Blocks;
import net.minecraft.block.Block;

import net.minecraft.client.Minecraft;
import net.minecraft.init.SoundEvents;
import net.minecraft.util.SoundCategory;

// Non Minecraft/Forge
import java.util.stream.Collectors;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/* TODO: Currently not working :( ... Forge API change?

@Mod(
     modid = "youdirk_numeric_io",
     certificateFingerprint = "",

     guiFactory = "", // TODO config screen

     // FALSE: mods.toml overrides
     useMetadata = false,
     canBeDeactivated = false,

     // Same JAR for Server and Client
     clientSideOnly = false,
     serverSideOnly = false,

     // Allow also to connect to remote side if the mod is not present
     acceptableRemoteVersions = "*",

     // Allow also to load vanilla worlds
     acceptableSaveVersions = "*"
     )
*/

@Mod(Props.MODID)
public class YoudirkNumericIO
{
  public static final Logger LOGGER = LogManager.getLogger(Props.MODID);

  public YoudirkNumericIO() {
    IEventBus fmlEventBus
      = FMLJavaModLoadingContext.get().getModEventBus();

    // Register the setup method for modloading
    fmlEventBus.addListener(this::setup);
    // Register the enqueueIMC method for modloading
    fmlEventBus.addListener(this::enqueueIMC);
    // Register the processIMC method for modloading
    fmlEventBus.addListener(this::processIMC);
    // Register the doClientStuff method for modloading
    fmlEventBus.addListener(this::doClientStuff);

    // Register ourselves for server and other game events we are interested in
    MinecraftForge.EVENT_BUS.register(this);
  }

  private void setup(final FMLCommonSetupEvent event)
  {
    // some preinit code
    LOGGER.info("HELLO FROM PREINIT");
    LOGGER.info("DIRT BLOCK >> {}", Blocks.DIRT.getRegistryName());
  }

  private void doClientStuff(final FMLClientSetupEvent event) {
    // do something that can only be done on the client
    LOGGER.info("Got game settings {}", event.getMinecraftSupplier().get().gameSettings);
  }

  private void enqueueIMC(final InterModEnqueueEvent event)
  {
    // some example code to dispatch IMC to another mod
    InterModComms.sendTo(Props.MODID, "helloworld", () -> { LOGGER.info("Hello world from the MDK"); return "Hello world";});
  }

  private void processIMC(final InterModProcessEvent event)
  {
    // some example code to receive and process InterModComms from other mods
    LOGGER.info("Got IMC {}", event.getIMCStream().
                map(m->m.getMessageSupplier().get()).
                collect(Collectors.toList()));
  }
  // You can use SubscribeEvent and let the Event Bus discover methods to call
  @SubscribeEvent
  public void onServerStarting(FMLServerStartingEvent event) {
    // do something when the server starts
    LOGGER.info("HELLO from server starting");
  }

  // Test event, on destroying a Block
  @SubscribeEvent
  public void onBlockBreak(BlockEvent.BreakEvent event)
  {
    event.getWorld().playSound(Minecraft.getInstance().player,
      event.getPos(), SoundEvents.ENTITY_WITCH_DEATH, SoundCategory.BLOCKS,
      1.0f, 1.0f);
    LOGGER.debug("Destroyed Block {}",
                 event.getState().getBlock().getRegistryName());
  }

  // You can use EventBusSubscriber to automatically subscribe events on the contained class (this is subscribing to the MOD
  // Event bus for receiving Registry Events)
  @Mod.EventBusSubscriber(bus=Mod.EventBusSubscriber.Bus.MOD)
  public static class RegistryEvents {
    @SubscribeEvent
    public static void onBlocksRegistry(final RegistryEvent.Register<Block> blockRegistryEvent) {
      // register a new block here
      LOGGER.info("HELLO from Register Block");
    }
  }

}
