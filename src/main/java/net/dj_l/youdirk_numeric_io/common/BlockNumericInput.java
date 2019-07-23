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

// Gameplay
import net.minecraft.world.World;
import net.minecraft.block.state.IBlockState;
import net.minecraft.util.math.BlockPos;


/**
 * An abstract <code>BlockNumericIO</code> which implements the non
 * number-system specific, <b>common input</b> mechanics.
 */
public abstract class BlockNumericInput extends BlockNumericIO
{
  protected BlockNumericInput(String registryPath)
  {
    super(registryPath);
  }

  /**
   * Only called on logical client side.
   */
  public void onActivateClient(World world, IBlockState state,
                               BlockPos pos)
  {
    net.dj_l.youdirk_numeric_io.client.BlockNumericInputClient
      .onActivate(
        (net.minecraft.client.multiplayer.WorldClient) world,
        state, this, pos
      );
  }

  /**
   * Only called on logical server side.
   */
  public void onActivateServer(World world, IBlockState state,
                               BlockPos pos)
  {
    net.dj_l.youdirk_numeric_io.server.BlockNumericInputServer
      .onActivate(
        (net.minecraft.world.WorldServer) world,
        state, this, pos
      );
  }
}
