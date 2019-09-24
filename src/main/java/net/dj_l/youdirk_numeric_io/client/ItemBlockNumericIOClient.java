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
import net.minecraftforge.api.distmarker.OnlyIn;
import net.minecraftforge.api.distmarker.Dist;

// Gameplay
import net.minecraft.item.ItemStack;
import net.minecraft.world.World;
import net.minecraft.client.util.ITooltipFlag;
import net.minecraft.util.text.ITextComponent;
import net.minecraft.util.text.TextComponentTranslation;

// Non Minecraft/Forge
import java.util.List;


/**
 * An abstract <code>ItemBlock</code> which implements the non
 * number-system specific, <b>client side common</b> mechanics.
 */
public abstract class ItemBlockNumericIOClient
{
  /**
   * Only called on logical client side.
   */
  @OnlyIn(Dist.CLIENT)
  public static void addInformation(ItemBlockNumericIO item,
    ItemStack stack, World world, List<ITextComponent> tooltip,
    ITooltipFlag flag)
  {
    // TODO
    if (!item.isEnabled())
      tooltip.add(new TextComponentTranslation("<disabled>"));
  }
}
