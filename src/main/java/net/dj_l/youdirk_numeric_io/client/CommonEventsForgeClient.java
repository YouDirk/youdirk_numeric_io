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

// Forge Mod Loader
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.api.distmarker.OnlyIn;
import net.minecraftforge.api.distmarker.Dist;

// Event Bus
import net.minecraftforge.eventbus.api.SubscribeEvent;

// Gameplay
import net.minecraft.world.World;


import net.minecraftforge.client.event.GuiScreenEvent;
import net.minecraft.client.gui.GuiScreen;
import net.minecraft.client.gui.inventory.GuiContainerCreative;
import net.minecraft.item.ItemStack;
/**
 * Implementation of all non-specific client-side event handlers fired
 * on <code>FORGE</code> bus.
 */
@Mod.EventBusSubscriber(bus=Mod.EventBusSubscriber.Bus.FORGE)
public abstract class CommonEventsForgeClient
{
  @OnlyIn(Dist.CLIENT)
  @SubscribeEvent
  public static void
  onGuiCreativeInit(final GuiScreenEvent.InitGuiEvent.Post event)
  {
    _onGuiCreative(event);
  }

  @OnlyIn(Dist.CLIENT)
  @SubscribeEvent
  public static void
  onGuiCreativeScroll(final GuiScreenEvent.MouseScrollEvent.Pre event)
  {
    _onGuiCreative(event);
  }

  @OnlyIn(Dist.CLIENT)
  @SubscribeEvent
  public static void
  onGuiCreativeDrag(final GuiScreenEvent.MouseDragEvent.Pre event)
  {
    _onGuiCreative(event);
  }

  @OnlyIn(Dist.CLIENT)
  @SubscribeEvent
  public static void
  onGuiCreativePressed(final GuiScreenEvent.KeyboardKeyPressedEvent.Pre event)
  {
    _onGuiCreative(event);
  }

  @OnlyIn(Dist.CLIENT)
  @SubscribeEvent
  public static void
  onGuiCreativeClicked(final GuiScreenEvent.MouseReleasedEvent.Pre event)
  {
    _onGuiCreative(event);
  }

  @OnlyIn(Dist.CLIENT)
  private static void _onGuiCreative(final GuiScreenEvent event)
  {
    // TODO
    GuiScreen guiScreen = event.getGui();
    if (!(guiScreen instanceof GuiContainerCreative)) return;

    GuiContainerCreative guiContainer = (GuiContainerCreative) guiScreen;

    GuiContainerCreative.ContainerCreative container =
      (GuiContainerCreative.ContainerCreative) guiContainer.inventorySlots;

    Log.ger.debug("***************");

    for (ItemStack stack: container.itemList) {
      if (stack.getItem() != CommonEvents.DECIMAL_INPUT_ITEM)
        continue;

      Log.ger.debug("*************** FOUND!");
    }
  }
}
