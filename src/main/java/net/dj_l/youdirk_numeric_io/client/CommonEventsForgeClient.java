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


package net.dj_l.youdirk_numeric_io.client;
import net.dj_l.youdirk_numeric_io.common.*;
import net.dj_l.youdirk_numeric_io.*;

// Client
import net.minecraft.client.Minecraft;
import net.minecraft.client.multiplayer.ServerData;

// Forge Mod Loader
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.api.distmarker.OnlyIn;
import net.minecraftforge.api.distmarker.Dist;

// Event Bus
import net.minecraftforge.eventbus.api.SubscribeEvent;
import net.minecraftforge.client.event.GuiScreenEvent;

// Events
import net.minecraftforge.event.entity.player.PlayerSetSpawnEvent;

// Gameplay
import net.minecraft.world.World;
import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.client.entity.EntityPlayerSP;
import net.minecraft.client.gui.GuiScreen;
import net.minecraft.client.gui.inventory.GuiContainerCreative;
import net.minecraft.inventory.Slot;
import net.minecraft.item.Item;


/**
 * Implementation of all non-specific client-side event handlers fired
 * on <code>FORGE</code> bus.
 */
@Mod.EventBusSubscriber(bus=Mod.EventBusSubscriber.Bus.FORGE)
public abstract class CommonEventsForgeClient
{
  private static boolean _isLogicalClient(World world)
  {
    return world.isRemote();
  }

  /**
   * Will be fired twice on respawn!
   */
  @OnlyIn(Dist.CLIENT)
  @SubscribeEvent
  public static void
  onPlayerSetSpawn(final PlayerSetSpawnEvent event)
  {
    EntityPlayer entityPlayer = event.getEntityPlayer();

    World world = entityPlayer.getEntityWorld();
    if (!_isLogicalClient(world)) throw new NotClientException();

    if (!(entityPlayer instanceof EntityPlayerSP)) return;
    EntityPlayerSP player = (EntityPlayerSP) entityPlayer;

    Minecraft mc = Minecraft.getInstance();
    if (mc.getIntegratedServer() != null) {
      ItemBlockNumericIORegistry.get().setClientConnectedModded(true);
      return;
    }

    ItemBlockNumericIORegistry.get().setClientConnectedModded(false);
    Net.sendToServer(new ModdedCheckNetMessage());
  }

  @OnlyIn(Dist.CLIENT)
  @SubscribeEvent
  public static void
  onMouseClicked(final GuiScreenEvent.MouseClickedEvent.Pre event)
  {
    GuiScreen guiScreen = event.getGui();
    if (!(guiScreen instanceof GuiContainerCreative)) return;

    GuiContainerCreative container = (GuiContainerCreative) guiScreen;

    Slot slot = container.getSlotUnderMouse();
    if (slot == null) return;

    Item item = slot.getStack().getItem();
    if (!(item instanceof ItemBlockNumericIO)) return;

    ItemBlockNumericIO itemIO = (ItemBlockNumericIO) item;
    if (itemIO.isEnabled(true)) return;

    event.setCanceled(true);
  }
}
