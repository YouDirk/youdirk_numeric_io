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

// Event Bus
import net.minecraftforge.eventbus.api.IEventBus;
import net.minecraftforge.eventbus.api.SubscribeEvent;

// Events
import net.minecraftforge.fml.event.lifecycle.FMLCommonSetupEvent;
import net.minecraftforge.fml.event.lifecycle.InterModEnqueueEvent;
import net.minecraftforge.fml.event.lifecycle.InterModProcessEvent;
import net.minecraftforge.event.RegistryEvent;

// IMC
import net.minecraftforge.fml.InterModComms;

// Gameplay
import net.minecraft.block.Block;
import net.minecraft.item.Item;

// Non Minecraft/Forge
import java.util.Random;


/**
 * Setup stuff for BOTH: logical server AND logical client
 */
@Mod.EventBusSubscriber(bus=Mod.EventBusSubscriber.Bus.MOD)
public class Setup
{
  public Setup(IEventBus forgeBus, IEventBus modBus)
  {
    modBus.addListener(this::_init);
    modBus.addListener(this::_enqueueInitialIMC);
    modBus.addListener(this::_processInitialIMC);

    modBus.addListener(this::_newRegistries);
  }

  /* *************************************************************  */

  private void _init(FMLCommonSetupEvent event)
  {
    Log.ger.debug("common.Setup::_init()");
  }

  private void _newRegistries(final RegistryEvent.NewRegistry event)
  {
    new ItemBlockNumericIORegistry();
    new NetMessageRegistry().registerOpposite();
  }

  /**
   * Must be used with <code>{@literal @}SubscribeEvent</code>,
   * otherwise the generic type is not overloadable.
   */
  @SubscribeEvent
  public static void
  onRegisterBlocks(RegistryEvent.Register<Block> event)
  {
    ItemBlockNumericIORegistry.get().registerOppositeBlocks(
      event.getRegistry());
  }

  /**
   * Must be used with <code>{@literal @}SubscribeEvent</code>,
   * otherwise the generic type is not overloadable.
   */
  @SubscribeEvent
  public static void
  onRegisterItemBlocks(RegistryEvent.Register<Item> event)
  {
    ItemBlockNumericIORegistry.get().registerOppositeItems(
      event.getRegistry());
  }

  /* *************************************************************  */

  private final long _IMC_CHECKVAL = new Random().nextLong();
  private void _enqueueInitialIMC(InterModEnqueueEvent event)
  {
    boolean send = InterModComms.sendTo(Props.MODID, "init_check",
                                        () -> this._IMC_CHECKVAL);

    if (!send) {
      throw new YoudirkNumericIOException(
        "Could not send initial Self Check IMC message!");
    }
  }

  private void _processInitialIMC(InterModProcessEvent event)
  {
    long count = event.getIMCStream(t -> t == "init_check")
      .filter(t -> t.getMessageSupplier().get().equals(this._IMC_CHECKVAL))
      .count();

    if (count > 1) {
      throw new YoudirkNumericIOException(
        "Too much Self Check IMC messages send!");
    } else if (count < 1) {
      throw new YoudirkNumericIOException(
        "Could not receive Self Check IMC message!");
    }
  }
}
