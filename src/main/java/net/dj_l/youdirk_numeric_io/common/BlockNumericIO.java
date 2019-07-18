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
import net.minecraft.util.ResourceLocation;
import net.minecraft.block.Block;
import net.minecraft.block.material.Material;
import net.minecraft.block.SoundType;

import net.minecraft.state.StateContainer;
import net.minecraft.block.state.IBlockState;
import net.minecraft.state.EnumProperty;


/**
 * An abstract <code>Block</code> which implements the non
 * number-system specific, <b>common</b> mechanics.
 */
public abstract class BlockNumericIO extends Block
{
  private static final Block.Properties _BUILDER
    = Block.Properties.create(Material.WOOD)
    // Hardness: dirt:0.5, stone:1.5
    // (explosion) Resistance: 5 x Hardness
    .hardnessAndResistance(0.5f)
    // Emitting light: 0-15, redstone_torch:7, torch: 14
    .lightValue(0)
    // Sound-set for default events, like PLACE, BREAK, STEP, HIT, FALL
    .sound(SoundType.METAL);

  protected static final EnumProperty<BlockNumericIOPowerEnum>
  STATE_POWER = EnumProperty.create("power",
                                    BlockNumericIOPowerEnum.class);

  protected BlockNumericIO(String registryPath)
  {
    super(BlockNumericIO._BUILDER);

    this.setRegistryName(new ResourceLocation(Props.MODID, registryPath));

    this.setDefaultState(this.getDefaultState()
      .with(BlockNumericIO.STATE_POWER, BlockNumericIOPowerEnum.OFF));
  }

  @Override
  protected void
  fillStateContainer(StateContainer.Builder<Block,IBlockState> builder)
  {
    builder.add(BlockNumericIO.STATE_POWER);

    super.fillStateContainer(builder);
  }
}
