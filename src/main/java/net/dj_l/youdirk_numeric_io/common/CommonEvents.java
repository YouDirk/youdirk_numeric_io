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
import net.minecraftforge.eventbus.api.SubscribeEvent;
import net.minecraftforge.registries.ObjectHolder;

// Events
import net.minecraftforge.event.RegistryEvent;

// Gameplay
import net.minecraft.block.Block;
import net.minecraft.item.Item;


/**
 * Implementation of all non-specific side-independent event handlers
 * fired on <code>MOD</code> bus.
 */
@ObjectHolder(Props.MODID)
@Mod.EventBusSubscriber(bus=Mod.EventBusSubscriber.Bus.MOD)
public abstract class CommonEvents
{
  @SubscribeEvent
  public static void newRegistries(final RegistryEvent.NewRegistry event)
  {
    new NetMessageRegistry();
  }

  /* *****************************************************************
   * Blocks
   */

  @ObjectHolder("decimal_input")
  public static final
  DecimalInputBlock DECIMAL_INPUT_BLOCK = null;

  @SubscribeEvent
  public static void
  onRegisterBlocks(RegistryEvent.Register<Block> event)
  {
    event.getRegistry().registerAll(new DecimalInputBlock());
  }

  /* *****************************************************************
   * Items / ItemBlocks
   */

  @ObjectHolder("decimal_input")
  public static final
  DecimalInputItem DECIMAL_INPUT_ITEM = null;

  @SubscribeEvent
  public static void
  onRegisterItemBlocks(RegistryEvent.Register<Item> event)
  {
    event.getRegistry().registerAll(
     new DecimalInputItem(DECIMAL_INPUT_BLOCK));
  }
}
