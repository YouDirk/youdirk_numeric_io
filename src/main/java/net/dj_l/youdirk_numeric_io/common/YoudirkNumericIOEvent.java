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

  private final IWorld _WORLD;

  public YoudirkNumericIOEvent(IWorld world)
  {
    super();

    this._WORLD = world;
  }

  public IWorld getWorld()
  {
    return this._WORLD;
  }

  /**
   * Returns <code>WorldClient</code> if we are on a logical client,
   * otherwise throw an Exception.
   */
  public net.minecraft.client.multiplayer.WorldClient
  getClientWorldOrThrow()
    throws net.dj_l.youdirk_numeric_io.client.NotClientException
  {
    World world = this._WORLD.getWorld();

    if (!world.isRemote())
      throw new net.dj_l.youdirk_numeric_io.client.NotClientException();

    return (net.minecraft.client.multiplayer.WorldClient) world;
  }

  /**
   * Returns <code>WorldServer</code> if we are on a logical server,
   * otherwise throw an Exception.
   */
  public net.minecraft.world.WorldServer
  getServerWorldOrThrow()
    throws net.dj_l.youdirk_numeric_io.server.NotServerException
  {
    World world = this._WORLD.getWorld();

    if (world.isRemote())
      throw new net.dj_l.youdirk_numeric_io.server.NotServerException();

    return (net.minecraft.world.WorldServer) world;
  }
}
