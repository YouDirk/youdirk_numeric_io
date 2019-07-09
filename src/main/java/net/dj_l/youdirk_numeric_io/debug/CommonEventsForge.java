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


package net.dj_l.youdirk_numeric_io.debug;
import net.dj_l.youdirk_numeric_io.common.*;
import net.dj_l.youdirk_numeric_io.*;

// Forge Mod Loader
import net.minecraftforge.fml.common.Mod;

// Event Bus
import net.minecraftforge.eventbus.api.SubscribeEvent;

// Events
import net.minecraftforge.event.entity.EntityJoinWorldEvent;

// Network
import net.minecraftforge.fml.network.PacketDistributor;

// Gameplay
import net.minecraft.world.World;
import net.minecraft.entity.Entity;
import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.item.ItemStack;
import net.minecraft.item.Item;
import net.minecraft.entity.player.InventoryPlayer;


/**
 * Implementation of all non-specific debug event handlers fired on
 * <code>FORGE</code> bus.
 *
 * <b>This class will not be compiled into productive builds.</b>
 */
@Mod.EventBusSubscriber(bus=Mod.EventBusSubscriber.Bus.FORGE)
public abstract class CommonEventsForge
{
  private static boolean _isLogicalServer(World world)
  {
    return !world.isRemote();
  }

  /* *****************************************************************
   *
   * Putting YoudirkNumericIO blocks and some other initial items into
   * players inventory on JOIN and RESPAWN for all Game-Modes.  So we
   * don't need to Grind&Craft it.
   */
  private static void _setItemToSlot(int slot, Item item,
                                     InventoryPlayer inventory)
  {
    ItemStack
      newStack = new ItemStack(item, item.getItemStackLimit(null)),
      replacedStack = inventory.getStackInSlot(slot);

    inventory.setInventorySlotContents(slot, newStack);

    if (replacedStack.getItem() != item)
      inventory.addItemStackToInventory(replacedStack);
  }

  @SubscribeEvent
  public static void
  onPlayerJoin(final EntityJoinWorldEvent event)
  {
    World world = event.getWorld().getWorld();
    if (!_isLogicalServer(world)) return; // Also fired on client side

    Entity entity = event.getEntity();
    if (!(entity instanceof EntityPlayer)) return;

    EntityPlayer player = (EntityPlayer) entity;

    if (player.allowLogging()) {
      player.sendMessage(new TextComponentDebug(
        "Hello %1$s, you are in Debug-Mode! Making a gift to your"
        + " inventory :)", player.getDisplayName().getString()));
    }

    _setItemToSlot(0,
      net.dj_l.youdirk_numeric_io.common.CommonEvents.DECIMAL_INPUT_ITEM,
      player.inventory);

    _setItemToSlot(5,
      net.minecraft.init.Blocks.REDSTONE_WIRE.asItem(),
      player.inventory);
    _setItemToSlot(6,
      net.minecraft.init.Blocks.REDSTONE_TORCH.asItem(),
      player.inventory);
    _setItemToSlot(7,
      net.minecraft.init.Blocks.LEVER.asItem(),
      player.inventory);
    _setItemToSlot(8,
      net.minecraft.init.Blocks.PISTON.asItem(),
      player.inventory);
    _setItemToSlot(9,
      net.minecraft.init.Blocks.CRAFTING_TABLE.asItem(),
      player.inventory);
  }
}
