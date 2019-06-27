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

// Event Bus
import net.minecraftforge.eventbus.api.IEventBus;
import net.minecraftforge.eventbus.api.Event;

// Gameplay
import net.minecraft.world.IWorld;
import net.minecraft.world.World;

// Non Minecraft/Forge
import javax.annotation.Nullable;


/**
 * Super class of all own Events.
 */
public class YoudirkNumericIOEvent extends Event
{
  public static IEventBus FORGE_BUS;
  public static IEventBus MOD_BUS;

  public static void init(IEventBus forgeBus, IEventBus modBus)
  {
    YoudirkNumericIOEvent.FORGE_BUS = forgeBus;
    YoudirkNumericIOEvent.MOD_BUS = modBus;
  }

  public static boolean post(YoudirkNumericIOEvent event)
  {
    return YoudirkNumericIOEvent.MOD_BUS.post(event);
  }

  /* *************************************************************  */

  private final IWorld world;

  public YoudirkNumericIOEvent(IWorld world)
  {
    super();

    this.world = world;
  }

  public IWorld getWorld()
  {
    return this.world;
  }

  /**
   * Returns <code>WorldClient</code> if we are on a logical client.
   * Otherwise <code>null</code>
   */
  public @Nullable net.minecraft.client.multiplayer.WorldClient
  getClientWorld()
  {
    World world = this.world.getWorld();

    return world.isRemote()
      ? (net.minecraft.client.multiplayer.WorldClient) world
      : null;
  }

  /**
   * Returns <code>WorldServer</code> if we are on a logical server.
   * Otherwise <code>null</code>
   */
  public @Nullable net.minecraft.world.WorldServer
  getServerWorld()
  {
    World world = this.world.getWorld();

    return !world.isRemote()
      ? (net.minecraft.world.WorldServer) world
      : null;
  }
}
