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


package net.dj_l.youdirk_numeric_io.server;
import net.dj_l.youdirk_numeric_io.common.*;
import net.dj_l.youdirk_numeric_io.*;

// Forge Mod Loader
import net.minecraftforge.fml.common.Mod;

// Event Bus
import net.minecraftforge.eventbus.api.SubscribeEvent;

// Events
import net.minecraftforge.event.world.BlockEvent;
import net.minecraftforge.fml.event.server.FMLServerStartingEvent;

// Network
import net.minecraftforge.fml.network.PacketDistributor;

// Gameplay
import net.minecraft.world.World;
import net.minecraft.util.ResourceLocation;
import net.minecraft.util.math.BlockPos;
import net.minecraft.util.SoundCategory;

// Non Minecraft/Forge
import java.util.function.Supplier;


/**
 * Implementation of all non-specific server-side event handlers fired
 * on <code>FORGE</code> bus.
 */
@Mod.EventBusSubscriber(bus=Mod.EventBusSubscriber.Bus.FORGE)
public abstract class CommonEventsForge
{
  private static boolean _isLogicalServer(World world)
  {
    return !world.isRemote();
  }

  /**
   * TODO: Just a Test event, on destroying a Block
   */
  @SubscribeEvent
  public static void onBlockBreak(final BlockEvent.BreakEvent event)
  {
    World world = event.getWorld().getWorld();
    if (!_isLogicalServer(world)) throw new NotServerException();

    // SoundEvents.ENTITY_WITCH_DEATH, does not exist on dedicated server
    final ResourceLocation sound
      = new ResourceLocation("minecraft", "entity.witch.death");

    final double RADIUS_FACTOR = 7.0;
    final BlockPos pos = event.getPos();
    final TestSoundNetMessage msg = new TestSoundNetMessage(pos, sound,
      SoundCategory.BLOCKS, 1.0f, 1.0f);

    Supplier<PacketDistributor.TargetPoint> netPos = () ->
      {
       return new PacketDistributor.TargetPoint(
         pos.getX(), pos.getY(), pos.getZ(), RADIUS_FACTOR*msg.VOLUME,
         world.getDimension().getType());
      };

    Net.send(PacketDistributor.NEAR.with(netPos), msg);
  }

  @SubscribeEvent
  public static void
  onServerStarting(final FMLServerStartingEvent event)
  {
    // TODO
    //DebugLagCommand cmd = new DebugLagCommand();
    //event.getCommandDispatcher().register(cmd.getLiteralForRegister());
  }
}
