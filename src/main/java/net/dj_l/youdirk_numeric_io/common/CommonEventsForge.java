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
import net.minecraftforge.fml.LogicalSide;

// Event Bus
import net.minecraftforge.eventbus.api.SubscribeEvent;
import net.minecraftforge.eventbus.api.Event;

// Events
import net.minecraftforge.event.entity.player.PlayerInteractEvent;

// Gameplay
import net.minecraft.world.World;
import net.minecraft.util.math.BlockPos;
import net.minecraft.block.state.IBlockState;
import net.minecraft.block.Block;
import net.minecraft.util.EnumActionResult;


/**
 * Implementation of all non-specific side-independent event handlers
 * fired on <code>FORGE</code> bus.
 */
@Mod.EventBusSubscriber(bus=Mod.EventBusSubscriber.Bus.FORGE)
public abstract class CommonEventsForge
{
  @SubscribeEvent
  public static void
  onBlockRightClick(final PlayerInteractEvent.RightClickBlock event)
  {
    World world = event.getWorld().getWorld();
    BlockPos pos = event.getPos();

    IBlockState state = world.getBlockState(pos);
    Block block = state.getBlock();

    if (!(block instanceof BlockNumericInput)) return;

    BlockNumericInput inputBlock = (BlockNumericInput) block;

    if (event.getSide() == LogicalSide.CLIENT)
      inputBlock.onActivateClient(world, state);
    else
      inputBlock.onActivateServer(world, state);

    // Prevent to USE_ITEM or PLACE_BLOCK, etc ...
    event.setCancellationResult(EnumActionResult.SUCCESS);
    event.setCanceled(true);
  }
}
