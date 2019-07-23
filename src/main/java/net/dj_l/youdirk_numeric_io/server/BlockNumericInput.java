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

// Gameplay
import net.minecraft.world.WorldServer;
import net.minecraft.block.state.IBlockState;


/**
 * An abstract <code>BlockNumericIO</code> which implements the non
 * number-system specific, <b>server side input</b> mechanics.
 */
public abstract class BlockNumericInput
{
  /**
   * Only called on logical server side.
   */
  public static void onActivate(WorldServer world, IBlockState state)
  {
    // TODO
    Log.ger.debug("****** called Server 2 ...");
  }
}
